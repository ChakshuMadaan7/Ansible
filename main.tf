provider "aws" {
  region  = "us-east-2"
  version = "~> 2.0"
}

resource "aws_key_pair" "demo" {
  key_name   = "Madaanterra"
  public_key = "${file("/home/ec2-user/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "well" {
  ami             = "ami-0e38b48473ea57778"
  instance_type   = "t2.micro"
 #security_groups = ["default"]
  key_name        = "Madaanterra"

  provisioner "local-exec" {
    command = "touch /home/ec2-user/terra/f3"
  }
  tags = {
    Name = "Trial"
  }

  #user_data = "${file("home/ec2-user/script.sh")}"
  provisioner "file" {
    source      = "/home/ec2-user/script.sh"
    destination = "/home/ec2-user/script.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
      host        = "${self.private_ip}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ec2-user/terra",
      "mv /home/ec2-user/script.sh /home/ec2-user/terra/",
      "chmod +x /home/ec2-user/terra/script.sh",
      "sudo sh /home/ec2-user/terra/script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("/home/ec2-user/.ssh/id_rsa")}"
      host        = "${self.private_ip}"
    }
  }
}
