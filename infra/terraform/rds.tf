resource "aws_db_subnet_group" "rds_subnets" {
  name = "${var.project}-${var.env}-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = var.tags
}

resource "aws_db_instance" "app_db" {
  identifier = "${var.project}-${var.env}-db"
  allocated_storage = var.db_allocated_storage
  engine = "postgres"
  engine_version = "14.6"
  instance_class = var.db_instance_class
  name = var.db_name
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az = true
  skip_final_snapshot = true
  tags = merge(var.tags, { Name = "${var.project}-${var.env}-rds" })
}
