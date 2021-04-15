# file: variables.tf

variable "BEANSTALK_APP_NAME" {
  description = "The application name which we are deploying in  AWS Elastic Beanstalk."
  type        = "string"
}

variable "AWS_KEY_PAIR_NAME" {
  description = "Use this SSH key pair to access Beanstalk EC2 instances."
  type        = "string"
}

variable "EB_ENVIRONMENT" {
  description = "Unique name for the deployment environment. Used in the application URL."
  type        = "string"
}

variable "AWS_IAM_INSTANCE_PROFILE" {
  description = "An instance profile is an IAM role that is applied to instances launched in your Elastic Beanstalk environment."
  type        = "string"
}

variable "CIRCLE_TAG" {
  description = "The Circle Tag is a default Circle CI environment variable used to get the tag number."
  type        = "string"
}

variable "HOSTED_ZONE" {
  type        = "string"
  description = "Name of the hosted zone to incorporate Route53 URL for the service"
}

variable "DNS_RECORD_TTL" {
  type        = "string"
  description = "TTL used in Route53 for the service"
  default     = 300
}

variable "INSTANCE_TYPE" {
  description = "Amazon EC2 provides a wide selection of instance types optimized to fit different use cases. Instance types comprise varying combinations of CPU, memory, storage, and networking capacity and give you the flexibility to choose the appropriate mix of resources for your applications."
  type        = "string"
  default     = "t2.small"
}

variable "DB_USER_CONFIG_KEY" {
  description = "This key is the refrernce value of database username stored in parameter store."
  type        = "string"
}

variable "DB_PASSWORD_CONFIG_KEY" {
  description = "This key is the refrernce value of database secret key stored in parameter store."
  type        = "string"
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS region. This variable overrides the default region of the in-use profile, if set"
  type        = "string"
}

variable "RDS_NAME" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier."
  type        = "string"
}

variable "DB_NAME" {
  description = "The DB name to create. If omitted, no database is created initially."
  type        = "string"
}

variable "DB_PORT" {
  default     = "5432"
  description = "The port on which the DB accepts connections"
  type        = "string"
}

variable "ALLOCATED_STORAGE" {
  description = "The allocated storage in gigabytes"
  type        = "string"
  default     = "20"
}

variable "STORAGE_TYPE" {
  type        = "string"
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  default     = "gp2"
}

variable "ENGINE" {
  type        = "string"
  description = "The database engine to use"
  default     = "postgres"
}

variable "ENGINE_VERSION" {
  type        = "string"
  description = "The engine version to use"
  default     = "9.6.6"
}

variable "INSTANCE_CLASS" {
  type        = "string"
  description = "The instance type of the RDS instance"
  default     = "db.t2.micro"
}

variable "IOPS" {
  type        = "string"
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  default     = 0
}

variable "ALLOW_MAJOR_VERSION_UPGRADES" {
  type        = "string"
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  default     = false
}

variable "ALLOW_MINOR_VERSION_UPGRADES" {
  type        = "string"
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = true
}

variable "APPLY_IMMEDIATELY" {
  type        = "string"
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = true
}

variable "MAINTENANCE_WINDOW" {
  type        = "string"
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  default     = "Fri:16:30-Fri:17:00"
}

variable "SKIP_FINAL_SNAPSHOT" {
  type        = "string"
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  default     = false
}

variable "COPY_TAGS_TO_SNAPSHOT" {
  type        = "string"
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  default     = true
}

variable "BACKUP_RETENTION_PERIOD" {
  type        = "string"
  description = "The days to retain backups for"
  default     = 7
}

variable "BACKUP_WINDOW" {
  type        = "string"
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  default     = "16:00-16:30"
}

variable "TAGS" {
  type        = "map"
  description = "A mapping of tags to assign to all resources"
  default     = {}
}

variable "SNAPSHOT_IDENTIFIER" {
  type        = "string"
  description = "Specifies whether or not to create this database from a snapshot"
  default     = ""
}

variable "MULTI_AZ" {
  type        = "string"
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
}
