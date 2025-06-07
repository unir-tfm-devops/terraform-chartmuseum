output "instance_public_ip" {
  value = aws_instance.chartmuseum.public_ip
}

output "chartmuseum_url" {
  value = "http://${aws_instance.chartmuseum.public_ip}"
}
