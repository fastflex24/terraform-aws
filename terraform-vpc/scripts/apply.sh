#!/bin/bash

# List of resources to taint
resources=(
"aws_vpc.main"
"aws_internet_gateway.igw"
"aws_route_table.public"
"aws_route_table_association.a"
"aws_route_table_association.b"
"aws_subnet.subnet1"
"aws_subnet.subnet2"
"aws_subnet.subnet3"
"aws_subnet.subnet4"
"aws_security_group.sg_public"
"aws_security_group.sg_private"
"aws_instance.ec2_instance"
"aws_autoscaling_group.asg"
"aws_launch_configuration.lc"
"aws_s3_bucket.images"
"aws_s3_bucket_lifecycle_configuration.images_lifecycle"
"aws_s3_bucket.logs"
"aws_s3_bucket_lifecycle_configuration.logs_lifecycle"
"aws_iam_role.asg_role"
"aws_iam_role_policy_attachment.asg_policy"
"aws_iam_instance_profile.asg_instance_profile"
"aws_iam_role.ec2_role"
"aws_iam_role_policy_attachment.ec2_policy"
"aws_iam_instance_profile.ec2_instance_profile"
"aws_lb.alb"
"aws_lb_target_group.tg"
"aws_lb_listener.listener"
"aws_autoscaling_attachment.asg_attachment"
)

# Taint resources
for resource in "${resources[@]}"; do
terraform taint $resource
done

# Apply configuration
terraform apply