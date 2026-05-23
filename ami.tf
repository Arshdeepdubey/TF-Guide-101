data "aws_ami" "ubuntu" {
  most_recent = true

  # Canonical (Ubuntu) official AWS account ID
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


# Together, the resource type and resource name form a unique resource address for the resource in your configuration. 
# The resource address for your EC2 instance is aws_instance.app_server. 
# You can refer to a resource in other parts of your configuration by its resource address.
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
