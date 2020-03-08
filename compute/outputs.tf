#--- compute/outputs.tf
output "keypair_id" {
  value = "${join(", ", aws_key_pair.keypair.*.id)}"
}
output "provider_ids" {
  value = "${join(", ", aws_instance.provider.*.id)}"
}
output "provider_public_ips" {
  value = "${join(", ", aws_instance.provider.*.public_ip)}"
}
output "consumer_ids" {
  value = "${join(", ", aws_instance.consumer.*.id)}"
}
output "consumer_public_ips" {
  value = "${join(", ", aws_instance.consumer.*.public_ip)}"
}

#--- VPC Endpoint Service
output "vpce_id" {
  value = aws_vpc_endpoint_service.vpce.id
}
output "vpce_dns_names" {
  value = aws_vpc_endpoint_service.vpce.base_endpoint_dns_names
}
output "vpcept_id" {
  value = aws_vpc_endpoint.vpcept.id
}
output "vpcept_dns_entry" {
  value = aws_vpc_endpoint.vpcept.dns_entry
}
