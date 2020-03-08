#--- compute/outputs.tf
output "keypair_id" {
  value = "${join(", ", aws_key_pair.keypair.*.id)}"
}
output "server1_ids" {
  value = "${join(", ", aws_instance.server1.*.id)}"
}
output "server1_public_ips" {
  value = "${join(", ", aws_instance.server1.*.public_ip)}"
}
output "server2_ids" {
  value = "${join(", ", aws_instance.server2.*.id)}"
}
output "server2_public_ips" {
  value = "${join(", ", aws_instance.server2.*.public_ip)}"
}

#--- VPC Endpoint Service
output "vpce_id" {
  value = aws_vpc_endpoint_service.vpce.id
}
output "vpce_dns_names" {
  value = aws_vpc_endpoint_service.vpce.base_endpoint_dns_names
}
