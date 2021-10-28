locals {
    vpc_id   = "vpc-0735473c0650139ff"
    subnet   = "*treiname*" ### Nesse campo precisaremos fazer um filtro das suas subnets, nesse casoo faremos de todas que contém priv no nome.
}

data "aws_subnet_ids" "main" {
vpc_id = var.vpc_id
    filter {
        name = "tag:Name"
        values = [var.name_subnets]
    }
}

resource "aws_instance" "k8s_proxy" {
  ami           = var.ami
  instance_type = var.ec2Type_proxy
  subnet_id     = element(tolist(data.aws_subnet_ids.main.ids[*]), count.index)
  associate_public_ip_address = true
  key_name      = var.key_name
  count         = 1
  root_block_device {
    encrypted = true
  }
  tags = {
    Name = format("%s-%s-%d", var.project, "k8s_haproxy", count.index +1)
    project = var.project
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers.id]
}

resource "aws_instance" "k8s_masters" {
  ami           = var.ami
  subnet_id     = element(tolist(data.aws_subnet_ids.main.ids[*]), count.index)
  instance_type = var.ec2Type_master
  associate_public_ip_address = true
  key_name      = var.key_name
  count         = 3
    root_block_device {
    encrypted = true
  }
  tags = {
    Name = format("%s-%s-%d", var.project, "k8s_master-", count.index +1)
    Project = var.project
  }
  vpc_security_group_ids = [aws_security_group.acessos_master.id]
  depends_on = [
    aws_instance.k8s_workers,
  ]
}

resource "aws_instance" "k8s_workers" {
  ami           = var.ami
  subnet_id     = element(tolist(data.aws_subnet_ids.main.ids[*]), count.index)
  instance_type = var.ec2Type_workers
  associate_public_ip_address = true
  key_name      = var.key_name
  count         = 3
  root_block_device {
    encrypted = true
  }

  tags = {
    Name = format("%s-%s-%d", var.project, "k8s_workers-", count.index +1)
    Project = var.project
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers.id]
}


resource "aws_security_group" "acessos_master" {
  name        = "k8s-acessos_master_team4"
  description = "Acessos maquina master"
  vpc_id      = data.aws_subnet_ids.main.id

  ingress = [
    {
      description      = "SSH para VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = ["10.0.1.0/24"]
      description      = "Libera acesso k8s_masters"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = true
      to_port          = 0
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Port range kubernetes"
      from_port        = 30000
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 32767
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

}


resource "aws_security_group" "acessos_workers" {
  name        = "k8s-workers_team4"
  vpc_id      = data.aws_subnet_ids.main.id
  description = "acessos inbound traffic"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = ["10.0.1.0/24"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 65535
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Port range kubernetes"
      from_port        = 30000
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = true
      to_port          = 32767
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

}
