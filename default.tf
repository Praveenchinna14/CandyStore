terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Adjust the version as necessary
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "dev" {
  ami = "ami-0522ab6e1ddcc7055"
  instance_type = "t2.medium"
  key_name = "kumar"
  vpc_security_group_ids = [ "sg-0ade4673820097009" ]
  tags = {
    Name = "dev"
  }
  
provisioner "remote-exec" {
    inline = [
        "sudo apt-get update",
        "sudo apt-get upgrade -y",
        "sudo apt install python3-pip -y",
        "sudo apt install python3-venv -y",
        "sudo apt install python3-virtualenv -y",
        "pip install virtualenv",
        "python3 -m venv /home/ubuntu/kumar",
        ". /home/ubuntu/kumar/bin/activate",
        "git clone https://github.com/Praveenchinna14/CandyStore.git",
        "cd CandyStore",
        "pip install -r requirements.txt",
        "python3 /home/ubuntu/CandyStore/manage.py makemigrations",
        "python3 /home/ubuntu/CandyStore/manage.py migrate",
        "python3 /home/ubuntu/CandyStore/manage.py runserver 0.0.0.0:8000"     
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu"  
      private_key = file("kumar.pem")  
      host     = self.public_ip  
    }
 }
}
