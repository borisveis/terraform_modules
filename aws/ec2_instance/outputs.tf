output "test_module_ip_public_ip" {
  value = aws_instance.test_module.public_ip
}
output "wev_ip_associate_public_ip_address" {

  value = aws_instance.test_module.associate_public_ip_address
}
output "default_subnet_id" {
  value = data.aws_vpc.aws_vpc.id
}