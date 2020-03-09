#--- compute/main.tf
resource "aws_key_pair" "keypair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}  

#--- Server Provider 1
data "template_file" "userdata_provider1" {
  template = file("${path.module}/userdata.tpl")
  vars = {
    server_name = "provider1"
  }
}

resource "aws_instance" "provider1" {
  instance_type           = "t3.micro"
  ami                     = data.aws_ami.amazon-linux-2.id
  key_name                = aws_key_pair.keypair.id
  subnet_id               = var.subprv1_id
  vpc_security_group_ids  = [var.sgprv1_id]
  user_data               = data.template_file.userdata_provider1.*.rendered[0]
  tags = { 
    Name = format("%s_provider1", var.project_name)
    project_name = var.project_name
  }
}

#--- Server Provider 2
data "template_file" "userdata_provider2" {
  template = file("${path.module}/userdata.tpl")
  vars = {
    server_name = "provider2"
  }
}

resource "aws_instance" "provider2" {
  instance_type           = "t3.micro"
  ami                     = data.aws_ami.amazon-linux-2.id
  key_name                = aws_key_pair.keypair.id
  subnet_id               = var.subprv2_id
  vpc_security_group_ids  = [var.sgprv1_id]
  user_data               = data.template_file.userdata_provider2.*.rendered[0]
  tags = { 
    Name = format("%s_provider2", var.project_name)
    project_name = var.project_name
  }
}

#--- Server Consumer 1
data "template_file" "userdata_consumer" {
  template = file("${path.module}/userdata.tpl")
  vars = {
    server_name = "consumer"
  }
}
resource "aws_instance" "consumer" {
  instance_type           = "t3.micro"
  ami                     = data.aws_ami.amazon-linux-2.id
  key_name                = aws_key_pair.keypair.id
  subnet_id               = var.subpub1_id
  vpc_security_group_ids  = [var.sgpub1_id]
  user_data               = data.template_file.userdata_consumer.*.rendered[0]
  tags = { 
    Name = format("%s_consumer", var.project_name)
    project_name = var.project_name
  }
}

#--- Network Load Balancer
resource "aws_lb" "nlb" {
  name               = "nlb"
  load_balancer_type = "network"
  internal           = true
  subnets            = [var.subprv1_id, var.subprv2_id]
  enable_cross_zone_load_balancing = true
# enable_deletion_protection = true
  tags = { 
    Name = format("%s_nlb", var.project_name)
    project_name = var.project_name
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    target_group_arn = aws_lb_target_group.nlbtrggroup.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "nlbtrggroup" {
  name                  = "nlbtrggroup"
  port                  = 80
  protocol              = "TCP"
  target_type           = "instance"
  deregistration_delay  = 90
  proxy_protocol_v2     = false
  vpc_id                = var.vpc1_id
  health_check {
    port = 80
    protocol = "TCP"
    interval = "10"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
  tags = { 
    Name = format("%s_nlbtrggroup", var.project_name)
    project_name = var.project_name
  }
}

resource "aws_lb_target_group_attachment" "nlbtrggroupatt1" {
  target_group_arn  = aws_lb_target_group.nlbtrggroup.arn
  port              = 80
  target_id         = aws_instance.provider1.id
}

resource "aws_lb_target_group_attachment" "nlbtrggroupatt2" {
  target_group_arn  = aws_lb_target_group.nlbtrggroup.arn
  port              = 80
  target_id         = aws_instance.provider2.id
}

#--- VPC Endpoint Service in Provider VPC
resource "aws_vpc_endpoint_service" "vpce" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.nlb.arn]
  tags = { 
    Name = format("%s_vpce", var.project_name)
    project_name = var.project_name
  }
}

#-- VPC Endpoint Interface in Consumer VPC
resource "aws_vpc_endpoint" "vpcept" {
  vpc_id            = var.vpc2_id
  service_name      = aws_vpc_endpoint_service.vpce.service_name
  vpc_endpoint_type = "Interface"
  security_group_ids = [var.sgpub1_id]
  subnet_ids          = [var.subpub1_id]
  private_dns_enabled = false
  tags = { 
    Name = format("%s_vpcept", var.project_name)
    project_name = var.project_name
  }
}
