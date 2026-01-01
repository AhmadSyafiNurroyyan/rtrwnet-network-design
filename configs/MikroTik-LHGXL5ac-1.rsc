# 2026-01-01 04:47:27 by RouterOS 7.20
# system id = V/awnNcWnED
#
/interface bridge
add name=bridge-ptp
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
/interface bridge port
add bridge=bridge-ptp interface=*2
add bridge=bridge-ptp interface=*3
/ip address
add address=172.16.0.3/24 interface=bridge-ptp network=172.16.0.0
/ip dhcp-client
# Interface not active
add interface=*2
/ip route
add dst-address=0.0.0.0/0 gateway=172.16.0.1