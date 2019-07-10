# Create a VPN Gateway
resource "aws_vpn_gateway" "vpc-vgw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name}-vgw"
  }
}

# Grant the VPC access to the VPN gateway on its main route table
resource "aws_route" "vgw-route" {
  route_table_id         = var.route_table_id
  destination_cidr_block = var.gcp_cidr
  gateway_id             = aws_vpn_gateway.vpc-vgw.id
}

# Create the remote customer gateway profile
resource "aws_customer_gateway" "vpc-cgw" {
  bgp_asn    = var.vpn_bgp_asn
  ip_address = var.vpn_ip_address
  type       = "ipsec.1"
  tags = {
    Name = "${var.name}-cgw"
  }
}

# Create the VPN tunnel to customer gateway
resource "aws_vpn_connection" "vpc-vpn" {
  vpn_gateway_id        = aws_vpn_gateway.vpc-vgw.id
  customer_gateway_id   = aws_customer_gateway.vpc-cgw.id
  type                  = "ipsec.1"
  static_routes_only    = true
  tunnel1_preshared_key = var.preshared_key
  tunnel2_preshared_key = var.preshared_key
  tags = {
    Name = "${var.name}-vpn"
  }
}

# define a static route between a VPN connection and a customer gateway
# create a route to GCP subnet
resource "aws_vpn_connection_route" "gcp_route" {
  destination_cidr_block = "172.31.32.0/22"
  vpn_connection_id      = aws_vpn_connection.vpc-vpn.id
}

