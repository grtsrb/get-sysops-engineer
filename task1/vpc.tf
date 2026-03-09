
# =======================VPC=====================
resource "aws_vpc" "get_case_study_task1_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# =======================SUBNETS=====================
resource "aws_subnet" "get_case_study_task1_database_subnet" {
  vpc_id   = aws_vpc.get_case_study_task1_vpc.id
  for_each = var.get_case_study_task1_database_subnet_list

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
}

resource "aws_subnet" "get_case_study_task1_public_subnet" {
  vpc_id   = aws_vpc.get_case_study_task1_vpc.id
  for_each = var.get_case_study_task1_public_subnet_list

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
}

# =======================IGW=====================
resource "aws_internet_gateway" "get_case_study_task1_igw" {
  vpc_id = aws_vpc.get_case_study_task1_vpc.id
}
# =======================ROUTE TABLE=====================
resource "aws_route_table" "get_case_study_task1_igw_route_table" {
  vpc_id = aws_vpc.get_case_study_task1_vpc.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.get_case_study_task1_igw.id
  }
}

resource "aws_route_table" "get_case_study_task1_db_route_table" {
  vpc_id = aws_vpc.get_case_study_task1_vpc.id
}

resource "aws_route_table_association" "get_case_study_task1_public_subnet_rt_association" {
  for_each       = aws_subnet.get_case_study_task1_public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.get_case_study_task1_igw_route_table.id
}

resource "aws_route_table_association" "get_case_study_task1_db_subnet_rt_association" {
  for_each       = aws_subnet.get_case_study_task1_database_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.get_case_study_task1_db_route_table.id
}
