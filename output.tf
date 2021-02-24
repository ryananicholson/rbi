output "sec488-hrweb-password" {
  value = random_password.sec488-hrweb-password.result
}

output "sec488-hrweb-ipaddress" {
  value = azurerm_public_ip.sec488-hrweb-pip.ip_address
}
