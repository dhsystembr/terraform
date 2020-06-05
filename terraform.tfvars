#
# amazon
#
aws_region = "us-east-1"

aws_vpc = {
        name = "terraform-lab"
        cidr_block = "10.0.0.0/16"
        enable_dns_support = "true"
        enable_dns_hostnames = "true"
}

aws_subnet = {
        pub_cidr_blocks = [ "10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24" ]
        prv_cidr_blocks = [ "10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24" ]

        pub_availability_zones = [ "us-east-1b", "us-east-1a", "us-east-1c" ]
        prv_availability_zones = [ "us-east-1b", "us-east-1a", "us-east-1c" ]
}

aws_instance = {
        instance_type = "t2.nano"
        ami = "ami-f4cc1de2"
        key_name = "terraform"
}

#
# amazon swarm
#
aws_swarm_mgr_instance = {
        count = 1
        instance_type = "t2.small"
        ami = "ami-e13739f6"
        key_name = "terraform"
        name = "swarm-mgr"
}

aws_swarm_wkr_instance = {
        count = 2
        instance_type = "t2.small"
        ami = "ami-e13739f6"
        key_name = "terraform"
        name = "swarm-wkr"
}
