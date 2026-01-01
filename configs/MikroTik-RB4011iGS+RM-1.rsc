# 2026-01-01 04:51:19 by RouterOS 7.20
# system id = WPt7hnWTOxF
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no name=ether9
set [ find default-name=ether2 ] disable-running-check=no name=ether10
set [ find default-name=ether3 ] disable-running-check=no name=ether11
set [ find default-name=ether4 ] disable-running-check=no name=ether12
set [ find default-name=ether5 ] disable-running-check=no name=ether13
set [ find default-name=ether6 ] disable-running-check=no name=ether14
set [ find default-name=ether7 ] disable-running-check=no name=ether15
set [ find default-name=ether8 ] disable-running-check=no name=ether16
/ip pool
add name=pool_vlan20 ranges=172.16.1.2-172.16.1.254
/port
set 0 name=serial0
/queue type
add kind=pcq name=pcq-download pcq-classifier=dst-address pcq-rate=140k
add kind=pcq name=pcq-upload pcq-classifier=src-address pcq-rate=46k
/queue simple
add max-limit=560k/186k name="bandwith manajemen" queue=pcq-download/pcq-upload target=172.16.1.0/24
/interface vlan
add interface=*2 name=vlan10-manajemen vlan-id=10
add interface=*2 name=vlan20-users vlan-id=20
/ip address
add address=172.16.0.1/24 interface=vlan10-manajemen network=172.16.0.0
add address=172.16.1.1/24 interface=vlan20-users network=172.16.1.0
/ip dhcp-client
# Interface not active
add interface=*2
/ip dhcp-server
# Interface not running
add address-pool=pool_vlan20 interface=vlan20-users name=dhcp_vlan20
/ip dhcp-server network
add address=172.16.1.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=172.16.1.1
/ip firewall filter
add action=accept chain=forward connection-state=established,related
add action=accept chain=forward dst-address=172.16.1.0/24 src-address=172.16.0.0/24
add action=accept chain=forward dst-address=172.16.0.0/24 src-address=172.16.1.0/24
/ip firewall nat
# no interface
add action=masquerade chain=srcnat out-interface=vlan10-manajemen
/ip route
add dst-address=0.0.0.0/0 gateway=192.168.122.1
add dst-address=0.0.0.0/0 gateway=172.16.0.4