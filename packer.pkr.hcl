
data "amazon-ami" "app" {
  filters = {
    name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "us-east-2"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "app" {
  ami_description = "from {{ .SourceAMI }}"
  ami_name        = "packer_AWS ${local.timestamp}"
  instance_type   = "t2.micro"
  region          = "us-east-2"
  source_ami      = "${data.amazon-ami.app.id}"
  ssh_username    = "ubuntu"
  tags = {
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Extra         = "{{ .BuildRegion }}"
    OS_Version    = "Ubuntu"
    Release       = "Latest"
    Sistema       = "Metal.corp"
    Tipo          = "Homologacao"
  }
}

build {
  sources = ["source.amazon-ebs.app"]

}
