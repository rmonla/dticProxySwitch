#!/bin/sh
clear

######## «® VARIABLES ®» ########



######## «® FUNCIONES ®» ########
ejecutarRUTEOs(){

PROXY_SERVER="192.168.7.1";
PROXY_PUERTO="3128";
INTERFACE="eth0";
RED_INTRANET="192.168.7.0/24";
RED_PUBLICA="192.168.8.0/24"

iptables -F;
iptables -X;
iptables -t nat -F;
iptables -t nat -X;
iptables -t mangle -F;
iptables -t mangle -X;

modprobe ip_conntrack;
modprobe ip_conntrack_ftp;

echo 1 > /proc/sys/net/ipv4/ip_forward;

iptables -P INPUT DROP;
iptables -P OUTPUT ACCEPT;
iptables -A INPUT -i lo -j ACCEPT;
iptables -A OUTPUT -o lo -j ACCEPT;

iptables -A INPUT -i $INTERFACE -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -s $RED_INTRANET -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -s $RED_PUBLICA -m state --state ESTABLISHED,RELATED -j ACCEPT;

iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE;

iptables -A FORWARD -s $RED_INTRANET -j ACCEPT;
iptables -A INPUT -s $RED_INTRANET -j ACCEPT;
iptables -A OUTPUT -s $RED_INTRANET -j ACCEPT;

iptables -A FORWARD -s $RED_PUBLICA -j ACCEPT;
iptables -A INPUT -s $RED_PUBLICA -j ACCEPT;
iptables -A OUTPUT -s $RED_PUBLICA -j ACCEPT;

iptables -t nat -A PREROUTING -i $INTERFACE -p tcp --dport 80 -j REDIRECT --to-port $PROXY_PUERTO;
iptables -t nat -A PREROUTING -s $RED_INTRANET -p tcp --dport 80 -j DNAT --to $PROXY_SERVER:$PROXY_PUERTO;
iptables -t nat -A PREROUTING -s $RED_PUBLICA -p tcp --dport 80 -j DNAT --to $PROXY_SERVER:$PROXY_PUERTO;

iptables -A INPUT -i $INTERFACE -j ACCEPT;
iptables -A OUTPUT -o $INTERFACE  -j ACCEPT;

iptables -A INPUT -j LOG;
iptables -A INPUT -j DROP;


}

getStrGTWAY(){
	local RED IP
	RED="$1"; IP="$2"; 
    
    echo  "
######## «® GATEWAY ®» ########
gateway $RED.$IP
# «® ------------------ ®»

"
}

getStrRED(){
	local ETH RED IP
	ETH="$1"; RED="$2"; IP="$3"
    
    echo  "
######## «® RED $RED ®» ########
allow-hotplug eth$ETH
iface eth$ETH inet static

address $RED.$IP
netmask 255.255.255.0
broadcast $RED.255
network $RED.0
# «® ------------------ ®»

"
}

cargaInterface () {
	local BODY
	BODY="$1";

	cat > interfaces.conf << _INTERFACE
######## «® LOOPBACK ®» ########
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
# «® ------------------ ®»
$BODY
_INTERFACE

}



######## «® MENU ®» ########

while :
do
echo "«® ELEGIR EL TRONCAL DE INTERNET PARA EL PROXY ®»";
echo "";
echo "1. WAN IPT 30Mb A-sincrónico.";
echo "2. WAN IPT 10Mb A-sincrónico.";
echo "3. WAN TECO 60Mb Sincrónico.";
echo "";
echo "4. SALIR";
echo -n "SELECCIONE UNA OPCIÓN [1 - 4] : ";
echo "";
echo "";

read opt
case $opt in

1) ######## «® OPCION 1 ®» ########
clear;

cargaInterface "
$(getStrRED 0 '192.168.8'  9)
$(getStrGTWAY '192.168.8' 86)
$(getStrRED 1 '192.168.7'  1)
$(getStrRED 2 '192.168.20' 1)
" 

echo "--- END OPCION 1 ---";
echo "";;

2) ######## «® OPCION 2 ®» ########
clear;

cargaInterface " 
$(getStrRED 0 '192.168.11' 4)
$(getStrGTWAY '192.168.11' 1)
$(getStrRED 1 '192.168.7'  1)
$(getStrRED 2 '192.168.20' 1)
" 

echo "--- END OPCION 2 ---";
echo "";;

3) ######## «® OPCION 3 ®» ########
clear;

cargaInterface " 
$(getStrRED 0 '190.114.205' 30)
$(getStrGTWAY '190.114.205' 1)
$(getStrRED 1 '192.168.7'  1)
$(getStrRED 2 '192.168.20' 1)
" 

echo "--- END OPCION 3 ---";
echo "";;

4) ######## «® OPCION 4 ®» ########
clear;



echo "--- END OPCION 4 ---";
echo "";
echo "";
exit 1;;

*) ######## «® OPCION OUT ®» ########

echo "$opc no es una opción válida.";
echo "Presiona una tecla para continuar...";
read foo;;
esac
done

