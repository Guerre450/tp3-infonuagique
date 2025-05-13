output "web_server_public_ip" {
  description = "Adresse IP publique du serveur web"
  value       = try([aws_instance.web_server.*.public_ip],"")
}