#!/usr/bin/env python3
"""Validate a module/example in an isolated copy with synthetic, plan-only fixtures."""
import argparse,json,os,pathlib,re,shutil,subprocess,tempfile

parser=argparse.ArgumentParser()
parser.add_argument('--root',default='.')
parser.add_argument('--modules-dir',type=pathlib.Path)
args=parser.parse_args()
repo=pathlib.Path(__file__).resolve().parents[1]

def run(command,cwd=None):
    print('+ '+' '.join(command),flush=True)
    subprocess.run(command,cwd=cwd,check=True)

def ignore(folder,names):
    return [n for n in names if n in ('.git','.terraform','terraform.tfvars','terraform.tfvars.json','.terraform.lock.hcl') or '.tfstate' in n or n.endswith(('.tfplan','.pem','.key','.auto.tfvars','.auto.tfvars.json'))]

with tempfile.TemporaryDirectory(prefix='oci9-plan-') as temp:
    work=pathlib.Path(temp)/repo.name
    shutil.copytree(repo,work,ignore=ignore)
    root=work/args.root
    deps={}
    for f in root.glob('*.tf'):
        def source(m):
            src=m[1];match=re.search(r'(terraform-oci-fk-[a-z-]+)',src)
            if not match:return m[0]
            name=match[1]
            if name==repo.name:return 'source = '+json.dumps(str(work))
            if name not in deps:
                local=args.modules_dir/name if args.modules_dir else None
                if local and local.is_dir():deps[name]=local.resolve()
                else:
                    url=src.removeprefix('git::').split('?')[0]
                    ref=src.split('?ref=',1)[1] if '?ref=' in src else 'main'
                    dep=pathlib.Path(temp)/'dependencies'/name;dep.parent.mkdir(exist_ok=True)
                    commit_pin=bool(re.fullmatch('[a-f0-9]{40}',ref))
                    exists=commit_pin or subprocess.run(['git','ls-remote','--exit-code','--tags',url,'refs/tags/'+ref],stdout=subprocess.DEVNULL).returncode==0
                    if not exists:
                        if os.getenv('OCI9_ALLOW_UNRELEASED')!='1':raise RuntimeError('Unreleased module tag: '+src)
                        print('Migration integration: '+name+' '+ref+' is unreleased; testing oci-provider-9.',flush=True)
                        ref='oci-provider-9'
                    if commit_pin:
                        run(['git','init',str(dep)])
                        run(['git','remote','add','origin',url],dep)
                        run(['git','fetch','--depth','1','origin',ref],dep)
                        run(['git','checkout','--detach','FETCH_HEAD'],dep)
                    else:run(['git','clone','--depth','1','--branch',ref,url,str(dep)])
                    deps[name]=dep
            return 'source = '+json.dumps(str(deps[name]))
        f.write_text(re.sub(r'\bsource\s*=\s*"([^"]+)"',source,f.read_text()))
    for f in (root/'tests').glob('*.tftest.hcl'):
        # These identifiers have no corresponding tenancy resources and never leave this temporary copy.
        f.write_text(re.sub(r'MOCK_OCID_([A-Z0-9_]+)',lambda m:'ocid1.'+m[1].lower()+'.oc1..mock',f.read_text()))
    (root/'ci_override.tf').write_text('terraform {\n required_providers {\n oci = {\n source = "oracle/oci"\n version = "= 9.12.1"\n }\n }\n}\n')
    run(['tofu','fmt','-check','-recursive'],repo/args.root)
    run(['tofu','fmt'],root)
    run(['tofu','init','-upgrade','-backend=false','-input=false'],root)
    run(['tofu','validate'],root)
    run(['tofu','test'],root)
