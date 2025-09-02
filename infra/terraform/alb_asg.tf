resource "aws_lb" "app_alb" {
  name               = "${var.project}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]
  tags = merge(var.tags, { Name = "${var.project}-${var.env}-alb" })
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.project}-${var.env}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path                = "/health"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-${var.env}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags = var.tags
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project}-${var.env}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_launch_template" "app_lt" {
  name_prefix = "${var.project}-${var.env}-lt-"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  iam_instance_profile { name = aws_iam_instance_profile.ec2_profile.name }
  user_data = base64encode(templatefile("${path.module}/user_data.tpl", {
    app_port = 8080,
    db_host = aws_db_instance.app_db.address,
    db_user = var.db_username,
    db_pass = var.db_password,
    db_name = var.db_name
  }))
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, { Name = "${var.project}-${var.env}-app-instance" })
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter { name = "name", values = ["amzn2-ami-hvm-*-x86_64-gp2"] }
}

resource "aws_autoscaling_group" "app_asg" {
  name = "${var.project}-${var.env}-asg"
  desired_capacity = var.asg_desired
  min_size = var.asg_min
  max_size = var.asg_max
  launch_template {
    id = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns = [aws_lb_target_group.app_tg.arn]
  tags = [
    { key = "Name", value = "${var.project}-${var.env}-app-asg", propagate_at_launch = true }
  ]
  lifecycle {
    create_before_destroy = true
  }
}
