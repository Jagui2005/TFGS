resource "aws_vpc" "red-principal" {
    cidr_block = "10.0.0.0/24"
    enable_dns_hostnames = true #preguntar porque poner esto
}

resource "aws_subnet" "red_publica" {
    vpc_id = aws_vpc.red-principal.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.red-principal.id
}

resource "aws_route_table" "rutas" {
    vpc_id = aws_vpc.red-principal.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "link" {
    subnet_id = aws_subnet.red_publica.id
    route_table_id = aws_route_table.rutas.id
}

resource "aws_security_group" "grupo_de_seguridad" {
    name = "grupo de seguridad"
    vpc_id = aws_vpc.red-principal.id

    ingress { 
        from_port = 0 
        to_port = 0 
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"] # abro todos los puertos para las pruebas, intentar acotar mas adelante
        }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] # abro todos los puertos para las pruebas, intentar acotar mas adelante
        }
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = [ "137112412989" ]
    filter {
      name = "name" #es una columna especifica que se llama name
      values = [ "al2023-ami-kernel-6.1-x86_64" ]
    }
}

data "aws_ami" "amazon_windows" {
    most_recent = true
    owners = [ 801119661308 ]
    filter {
      name = "name"
      values = ["Windows_Server-2022-English-Full-Base-*"]
    }
}

data "aws_ami" "Ubuntu_server" {
    most_recent = true  
    owners = [ "099720109477" ]
    filter {
      name = "name"
      values = [ "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" ]
    }
}

