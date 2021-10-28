variable "vpc_id" {
  type = string
  default = ""
  description = "VPC que sera usada no ambiente"
}

variable "name_subnets" {
  type = string
  default = ""
  description = "Nesse campo precisaremos fazer um filtro das suas subnets, nesse casoo faremos de todas que são publicas"
}

variable "ami" {
  type = string
  default = ""
  description = "Imagem que será usada na instalacao - OBS: Deve ser uma distribuicao Linux"
}

variable "ec2Type_proxy" {
  type = string
  default = ""
  description = "Tipo de EC2 que será usada na instalacao do proxy"
}

variable "ec2Type_master" {
  type = string
  default = ""
  description = "Tipo de EC2 que será usada na instalacao dos masters"
}

variable "ec2Type_workers" {
  type = string
  default = ""
  description = "Tipo de EC2 que será usada na instalacao dos workers"
}

variable "key_name" {
  type = string
  default = ""
  description = "Chave de confianca para acesso via ssh"
}

variable "project" {
  type = string
  default = ""
  description = "Nome do projeto"
}
