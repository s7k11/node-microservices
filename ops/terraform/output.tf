# file: output.tf

output "ebapp_name" {
  description = "The aws elastic beanstalk application name."
  value       = "${var.BEANSTALK_APP_NAME}"
}

output "ebapp_env" {
  description = "The aws elastic beanstalk application environment name."
  value       = "${aws_elastic_beanstalk_environment.eb_env.name}"
}

output "service_url" {
  description = "URL of the service for a specific environment."
  value       = "${aws_route53_record.service_dns_record.fqdn}"
}
