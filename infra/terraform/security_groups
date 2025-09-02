resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.env}-alb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "HTTP"
    from_port = 80; to_port = 80; protocol = "tcp"; cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port = 443; to_port = 443; protocol = "tcp"; cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.project}-${var.env}-alb-sg" })
}

resource "aws_security_group" "ec2_sg" {
  name = "${var.project}-${var.env}-ec2-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 8080; to_port = 8080; protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description = "App traffic from ALB"
  }
  egress {
    from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.project}-${var.env}-ec2-sg" })
}

resource "aws_security_group" "bastion_sg" {
  name = "${var.project}-${var.env}-bastion-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 22; to_port = 22; protocol = "tcp"
    cidr_blocks = [var.bastion_allowed_cidr]
    description = "SSH from admin IP"
  }
  egress {
    from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.project}-${var.env}-bastion-sg" })
}

resource "aws_security_group_rule" "bastion_to_ec2" {
  type = "ingress"
  from_port = 22; to_port = 22; protocol = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
  description = "Allow SSH from bastion"
}

resource "aws_security_group" "rds_sg" {
  name = "${var.project}-${var.env}-rds-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 5432; to_port = 5432; protocol = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
    description = "Postgres access from app instances"
  }
  egress {
    from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.project}-${var.env}-rds-sg" })
}
