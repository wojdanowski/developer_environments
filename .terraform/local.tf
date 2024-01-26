locals {
  internal_cidr_blocks = concat(
    [aws_vpc.my_vpc.cidr_block]
  )
  vpc_cidr   = "10.0.0.0/16"
  account_id = aws_vpc.my_vpc.owner_id
}
