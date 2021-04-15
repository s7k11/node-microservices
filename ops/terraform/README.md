
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ALLOCATED_STORAGE | The allocated storage in gigabytes | string | `20` | no |
| ALLOW_MAJOR_VERSION_UPGRADES | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible | string | `false` | no |
| ALLOW_MINOR_VERSION_UPGRADES | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | string | `true` | no |
| APPLY_IMMEDIATELY | Specifies whether any database modifications are applied immediately, or during the next maintenance window | string | `true` | no |
| AWS_DEFAULT_REGION | AWS region. This variable overrides the default region of the in-use profile, if set | string | - | yes |
| AWS_IAM_INSTANCE_PROFILE | An instance profile is an IAM role that is applied to instances launched in your Elastic Beanstalk environment. | string | - | yes |
| AWS_KEY_PAIR_NAME | Use this SSH key pair to access Beanstalk EC2 instances. | string | - | yes |
| BACKUP_RETENTION_PERIOD | The days to retain backups for | string | `7` | no |
| BACKUP_WINDOW | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window | string | `16:00-16:30` | no |
| BEANSTALK_APP_NAME | The application name which we are deploying in  AWS Elastic Beanstalk. | string | - | yes |
| CIRCLE_TAG | The Circle Tag is a default Circle CI environment variable used to get the tag number. | string | - | yes |
| COPY_TAGS_TO_SNAPSHOT | On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified) | string | `true` | no |
| DB_NAME | The DB name to create. If omitted, no database is created initially. | string | - | yes |
| DB_PASSWORD_CONFIG_KEY | This key is the refrernce value of database secret key stored in parameter store. | string | - | yes |
| DB_PORT | The port on which the DB accepts connections | string | `5432` | no |
| DB_USER_CONFIG_KEY | This key is the refrernce value of database username stored in parameter store. | string | - | yes |
| DNS_RECORD_TTL | TTL used in Route53 for the service | string | `300` | no |
| EB_ENVIRONMENT | Unique name for the deployment environment. Used in the application URL. | string | - | yes |
| ENGINE | The database engine to use | string | `postgres` | no |
| ENGINE_VERSION | The engine version to use | string | `9.6.6` | no |
| HOSTED_ZONE | Name of the hosted zone to incorporate Route53 URL for the service | string | - | yes |
| INSTANCE_CLASS | The instance type of the RDS instance | string | `db.t2.micro` | no |
| INSTANCE_TYPE | Amazon EC2 provides a wide selection of instance types optimized to fit different use cases. Instance types comprise varying combinations of CPU, memory, storage, and networking capacity and give you the flexibility to choose the appropriate mix of resources for your applications. | string | `t2.small` | no |
| IOPS | The amount of provisioned IOPS. Setting this implies a storage_type of 'io1' | string | `0` | no |
| MAINTENANCE_WINDOW | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00' | string | `Fri:16:30-Fri:17:00` | no |
| MULTI_AZ | Specifies if the RDS instance is multi-AZ | string | `false` | no |
| RDS_NAME | The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier. | string | - | yes |
| SKIP_FINAL_SNAPSHOT | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier | string | `false` | no |
| SNAPSHOT_IDENTIFIER | Specifies whether or not to create this database from a snapshot | string | `` | no |
| STORAGE_TYPE | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'. | string | `gp2` | no |
| TAGS | A mapping of tags to assign to all resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| ebapp_env | The aws elastic beanstalk application environment name. |
| ebapp_name | The aws elastic beanstalk application name. |
| service_url | URL of the service for a specific environment. |

