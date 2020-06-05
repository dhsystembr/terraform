module "amazon-vn" {
    source = "./amazon/virtual-network"

    aws_region      = "${var.aws_region}"
    aws_vpc         = "${var.aws_vpc}"
    aws_subnet      = "${var.aws_subnet}"
    aws_instance    = "${var.aws_instance}"
}

module "amazon-swarm" {
    source = "./amazon/swarm-stack"

    aws_vpc = {
        id      = "${module.amazon-vn.vpc_id}"
        name    = "${module.amazon-vn.vpc_name}"
    }

    aws_subnet = {
        cidr_blocks = "${module.amazon-vn.pub_subnet_cidr_blocks}"
        ids         = "${module.amazon-vn.pub_subnet_ids}"
    }

    aws_security_group = {
        internal    = "${module.amazon-vn.internal_security_group_id}"
    }

    aws_swarm_mgr_instance = {
        count           = "${var.aws_swarm_mgr_instance["count"]}"
        instance_type   = "${var.aws_swarm_mgr_instance["instance_type"]}"
        ami             = "${var.aws_swarm_mgr_instance["ami"]}"
        key_name        = "${var.aws_swarm_mgr_instance["key_name"]}"
        name            = "${var.aws_swarm_mgr_instance["name"]}"
    }

    aws_swarm_wkr_instance = {
        count           = "${var.aws_swarm_wkr_instance["count"]}"
        instance_type   = "${var.aws_swarm_wkr_instance["instance_type"]}"
        ami             = "${var.aws_swarm_wkr_instance["ami"]}"
        key_name        = "${var.aws_swarm_wkr_instance["key_name"]}"
        name            = "${var.aws_swarm_wkr_instance["name"]}"
    }
}

data "template_file" "inventory" {
    template = "${file("templates/inventory.tpl")}"

    vars {
        aws_swarm_managers  = "${join("\n", formatlist("%15s ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform.pem", module.amazon-swarm.aws_swarm_mgr_public_ips))}"
        aws_swarm_workers   = "${join("\n", formatlist("%15s ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform.pem", module.amazon-swarm.aws_swarm_wkr_public_ips))}"
    }

    depends_on = [
        "module.amazon-swarm",
    ]
}

resource "local_file" "inventory" {
    content     = "${data.template_file.inventory.rendered}"
    filename    = "ansible/hosts"
}

