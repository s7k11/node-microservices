provider "aws" {
  region = "${var.AWS_DEFAULT_REGION}"
}

terraform {
  backend "s3" {}
}

locals {
  iam_database_authentication_enabled = false
  publicly_accessible                 = false
  storage_encrypted                   = false
  final_snapshot_identifier           = "${var.RDS_NAME}-${var.EB_ENVIRONMENT}-final-snapshot-${md5(timestamp())}"
  certificate_domain                  = "*.${replace(var.HOSTED_ZONE, "/[.]$/", "" )}"
}

###################################
# Data sources to get VPC, subnets
###################################
data "aws_vpc" "vpc" {
  tags {
    Environment = "${var.EB_ENVIRONMENT == "dev" ? "development" : var.EB_ENVIRONMENT}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Type = "public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Type = "private"
  }
}

data "aws_subnet_ids" "storage" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Type = "storage"
  }
}

data "aws_security_group" "public" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Type = "public"
  }
}

data "aws_security_group" "private" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Type = "private"
  }
}

data "aws_security_group" "storage" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Type = "storage"
  }
}

#######################################################
# Data sources to get db username and password details
#######################################################
data "aws_ssm_parameter" "dbuser" {
  name = "${var.DB_USER_CONFIG_KEY}"
}

data "aws_ssm_parameter" "dbsecret" {
  name = "${var.DB_PASSWORD_CONFIG_KEY}"
}

###############################
# RDS DB subnet group resource.
###############################
resource "aws_db_subnet_group" "storage" {
  name       = "storage-${var.BEANSTALK_APP_NAME}-${var.EB_ENVIRONMENT}"
  subnet_ids = ["${data.aws_subnet_ids.storage.ids}"]
}

##################
# AWS DB instance
##################
resource "aws_db_instance" "aws_db_instance" {
  identifier = "${var.RDS_NAME}"

  engine            = "${var.ENGINE}"
  engine_version    = "${var.ENGINE_VERSION}"
  instance_class    = "${var.INSTANCE_CLASS}"
  allocated_storage = "${var.ALLOCATED_STORAGE}"
  storage_type      = "${var.STORAGE_TYPE}"
  storage_encrypted = "${local.storage_encrypted}"

  name     = "${var.DB_NAME}"
  username = "${data.aws_ssm_parameter.dbuser.value}"
  password = "${data.aws_ssm_parameter.dbsecret.value}"
  port     = "${var.DB_PORT}"

  iam_database_authentication_enabled = "${local.iam_database_authentication_enabled}"
  vpc_security_group_ids              = ["${data.aws_security_group.storage.id}"]

  multi_az            = "${var.MULTI_AZ}"
  iops                = "${var.IOPS}"
  publicly_accessible = "${local.publicly_accessible}"

  allow_major_version_upgrade = "${var.ALLOW_MAJOR_VERSION_UPGRADES}"
  auto_minor_version_upgrade  = "${var.ALLOW_MINOR_VERSION_UPGRADES}"
  apply_immediately           = "${var.APPLY_IMMEDIATELY}"
  maintenance_window          = "${var.MAINTENANCE_WINDOW}"
  skip_final_snapshot         = "${var.SKIP_FINAL_SNAPSHOT}"
  copy_tags_to_snapshot       = "${var.COPY_TAGS_TO_SNAPSHOT}"
  final_snapshot_identifier   = "${local.final_snapshot_identifier}"
  snapshot_identifier         = "${var.SNAPSHOT_IDENTIFIER}"

  backup_retention_period = "${var.BACKUP_RETENTION_PERIOD}"
  backup_window           = "${var.BACKUP_WINDOW}"
  db_subnet_group_name    = "${aws_db_subnet_group.storage.name}"

  tags = "${merge(var.TAGS, map("Name", format("%s", var.RDS_NAME)))}"

  lifecycle {
    ignore_changes = ["final_snapshot_identifier"]
    ignore_changes = ["snapshot_identifier"]
  }
}

###################################
# Creating EB Application
###################################

data "aws_acm_certificate" "platform" {
  domain      = "${local.certificate_domain}"
  most_recent = true
}

resource "aws_elastic_beanstalk_environment" "eb_env" {
  name         = "${var.BEANSTALK_APP_NAME}-${var.EB_ENVIRONMENT}"
  application  = "${var.BEANSTALK_APP_NAME}"
  cname_prefix = "${var.BEANSTALK_APP_NAME}-${var.EB_ENVIRONMENT}"
  description  = "${var.BEANSTALK_APP_NAME}-${var.EB_ENVIRONMENT}"

  solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.0 running Multi-container Docker 18.03.1-ce (Generic)"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${data.aws_vpc.vpc.id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", data.aws_subnet_ids.private.ids)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", data.aws_subnet_ids.public.ids)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet-facing"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = "${data.aws_security_group.public.id}"
  }

  setting {
    namespace = "aws:elb:listener:80"
    name      = "ListenerEnabled"
    value     = "false"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "SSLCertificateId"
    value     = "${data.aws_acm_certificate.platform.arn}"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "InstancePort"
    value     = "80"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${var.AWS_IAM_INSTANCE_PROFILE}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.AWS_KEY_PAIR_NAME}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.INSTANCE_TYPE}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${data.aws_security_group.private.id}"
  }

  tags {
    Environment = "${var.EB_ENVIRONMENT}"
    Version     = "${var.CIRCLE_TAG}"
  }

  depends_on = ["aws_db_instance.aws_db_instance"]
}

data "aws_route53_zone" "hosted_zone" {
  name = "${var.HOSTED_ZONE}"
}

resource "aws_route53_record" "service_dns_record" {
  zone_id = "${data.aws_route53_zone.hosted_zone.id}"
  type    = "CNAME"
  name    = "${var.BEANSTALK_APP_NAME}-${var.EB_ENVIRONMENT}.${var.HOSTED_ZONE}"
  ttl     = "${var.DNS_RECORD_TTL}"

  records = [
    "${aws_elastic_beanstalk_environment.eb_env.cname}",
  ]
}
