# 2026-01-01 04:40:28 by RouterOS 7.20
# system id = OA/om1kJLtD
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
/port
set 0 name=serial0
/ip address
add address=172.16.0.4/24 interface=*3 network=172.16.0.0
/ip dhcp-client
# Interface not active
add interface=*2
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,1.1.1.1
/ip firewall nat
# no interface
add action=masquerade chain=srcnat out-interface=*2