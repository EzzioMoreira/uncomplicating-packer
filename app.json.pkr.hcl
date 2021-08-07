
variable "ami_name" {
  type = string
  default = "APP_FOOD"
  description = "Ami name"
}

variable "region" {
  type    = string
  default = "us-east-2"
  description = "The name AWS availability zone"
}

variable "type" {
  type      = string
  default   = "${env("TYPE")}"
  sensitive = true
  description = "System environment variable"
}

variable "instance_typ" {
  type    = string
  default = "t2.micro"
  description = "Type instace ec2"
}

data "amazon-ami" "APP_FOOD" {
  filters = {
    name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "${var.region}"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "APP_FOOD" {
  ami_description = "from {{ .SourceAMI }}"
  ami_name        = "${var.ami_name} ${var.type} ${local.timestamp}"
  instance_type   = "${var.instance_typ}"
  region          = "${var.region}"
  source_ami      = "${data.amazon-ami.APP_FOOD.id}"
  ssh_username    = "ubuntu"
  tags = {
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Extra         = "<no value>"
    OS_Version    = "Ubuntu"
    Release       = "Latest"
    Name          = "${var.ami_name}"
    Sistema       = "Metal.Corp"
    Environment   = "Homologa"
  }
}

build {
  sources = ["source.amazon-ebs.APP_FOOD"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "ansible_python_interpreter=/usr/bin/python3"]
    playbook_file    = "./playbook.yml"
    user             = "ubuntu"
  }

provisioner "shell" {
      inline = [
        "echo provisioning all the things",
        "echo the value of 'corporation' is 'Metal.Corp'",
      ]
      pause_before = "10s"
  }
}
