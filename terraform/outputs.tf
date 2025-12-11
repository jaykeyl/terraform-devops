output "site_url" {
  value = "http://${aws_instance.web.public_ip}"
  description = "URL to reach the site"
}
