variable "vpc_id" {}
variable "private_subnets" {}
variable "target_group_arn" {}

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = []
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "nginx-template"
  image_id      = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"

  user_data = base64encode(<<EOF
#!/bin/bash
yum install nginx -y
systemctl start nginx
systemctl enable nginx
echo "Hello from $(hostname)" > /usr/share/nginx/html/index.html
EOF
  )
}

resource "aws_autoscaling_group" "asg" {
  min_size         = 1
  desired_capacity = 2
  max_size         = 5
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}
