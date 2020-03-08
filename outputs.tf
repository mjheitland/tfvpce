#--- root/outputs.tf ---
output "project_name" {
  value = var.project_name
}

#--- networking
output "vpc1_id" {
  value = module.networking.vpc1_id
}
output "subprv1_id" {
  value = module.networking.subprv1_id
}
output "sgprv1_id" {
  value = module.networking.sgprv1_id
}
output "rtprv1_id" {
  value = module.networking.rtprv1_id
}
output "rtprv1assoc_id" {
  value = module.networking.rtprv1assoc_id
}
output "vpc2_id" {
  value = module.networking.vpc2_id
}
output "igw2_id" {
  value = module.networking.igw2_id
}
output "subpub1_id" {
  value = module.networking.subpub1_id
}
output "sgpub1_id" {
  value = module.networking.sgpub1_id
}
output "rtpub1_id" {
  value = module.networking.rtpub1_id
}
output "rtpub1assoc_id" {
  value = module.networking.rtpub1assoc_id
}

#--- compute
output "keypair_id" {
  value = module.compute.keypair_id
}
output "server1_ids" {
  value = module.compute.server1_ids
}
output "server1_public_ips" {
  value = module.compute.server1_public_ips
}
output "server2_ids" {
  value = module.compute.server2_ids
}
output "server2_public_ips" {
  value = module.compute.server2_public_ips
}

#--- VPC Endpoint Service
output "vpce_id" {
  value = module.compute.vpce_id
}
output "vpce_dns_names" {
  value = module.compute.vpce_dns_names
}
