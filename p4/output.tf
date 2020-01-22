output "vm_fqdn" {
  value = azurerm_public_ip.bot-pub-ip.fqdn
}
output "private_key" {
  value = tls_private_key.example.private_key_pem
}
output "ssh_command" {
  value = "ssh ${local.admin_username}@${azurerm_public_ip.bot-pub-ip.ip_address}"
}
