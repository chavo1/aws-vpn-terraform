# This repo contain an example of IPsec VPN Between GCP and AWS

### IPsec VPN Connection
The IPsec VPN tunnels has the following features:
-  IKEv1
-  Pre-shared keys for authentication
-  Route-based VPN
-  Static routing

#### Prerequisite 
- Create an external IP address on GCP and add it as "vpn_ip_address" in your terraform.tfvars file.

