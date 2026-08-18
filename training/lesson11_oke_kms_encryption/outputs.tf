output "KubeConfig" {
  value = module.fk-oke.KubeConfig
}

output "Cluster" {
  value = module.fk-oke.cluster
}

output "NodePool" {
  value = module.fk-oke.node_pool
}

output "VaultId" {
  value = module.fk-vault.vault_id
}

output "KmsKeyId" {
  value = module.fk-vault.key_ids["oke-secrets"]
}
