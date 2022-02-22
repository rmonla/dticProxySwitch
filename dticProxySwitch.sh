#!/bin/sh
clear

######## «® VARIABLES ®» ########



######## «® FUNCIONES ®» ########
ejecutarRUTEOs(){

PROXY_SERVER="10.0.10.1";
PROXY_PUERTO="3128";
INTERFACE="eth0";
RED_INTRANET="10.0.10.0/24";
RED_PUBLICA="192.168.8.0/24"

# PROXY_SERVER="192.168.7.1";
# PROXY_PUERTO="3128";
# INTERFACE="eth0";
# RED_INTRANET="192.168.7.0/24";
# RED_PUBLICA="192.168.8.0/24"

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

# |||||||||||||||||||| Habilitacion de Accesos ||||||||||||||||||||

# (Red 7) Facebook

iptables -I FORWARD -p tcp --dport 80 -m string --string 'facebook.com' --algo bm --to 65535 -j DROP;
iptables -I FORWARD -p tcp --dport 443 -m string --string 'facebook.com' --algo bm --to 65535 -j DROP;
#iptables -I FORWARD -p tcp --dport 80 -m string --string cienradios.com --algo bm --to 65535 -j DROP;
#iptables -I FORWARD -p tcp --dport 443 -m string --string cienradios.com --algo bm --to 65535 -j DROP;
#iptables -I FORWARD -p tcp --dport 80 -m string --string ar.cienradios.com --algo bm --to 65535 -j DROP;
#iptables -I FORWARD -p tcp --dport 443 -m string --string ar.cienradios.com --algo bm --to 65535 -j DROP;
iptables -I FORWARD -p tcp --dport 80 -m string --string 'youtube.com' --algo bm --to 65535 -j DROP;
iptables -I FORWARD -p tcp --dport 443 -m string --string 'youtube.com' --algo bm --to 65535 -j DROP;

# ||||||||||||||||||| Habilitación de Accesos ||||||||||||||||||

#UTNLaRioja-Dedicada
iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.120 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.120 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#Biblioteca
iptables -I FORWARD -p tcp --dport 443 -s  10.0.10.56 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables  -I FORWARD -p tcp --dport 443 -s 10.0.10.56 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#Araceli
iptables -I FORWARD -p tcp --dport 443 -s  10.0.10.45 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;

#Henry
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.61 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.61 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#RRHH
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.43 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;

#Silvia
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.55 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.55 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#dcalderon
iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.117 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.117 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#Colegio Eduardo
iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.116 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.116 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#mlopez
iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.78 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;

#rmonla
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.7 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.7 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.77 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.77 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.7 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;

#rmonlaMobile
iptables -I FORWARD -p tcp --dport 443 -s 192.168.7.101 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;

#IleanaBandera
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.52 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.52 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#rcaniza
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.76 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.76 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#wkrupp
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.44 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.44 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#cgatica
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.68 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.68 -m string --string 'facebook.com' --algo bm --to 65535 -j ACCEPT;

#vstewart
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.81 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;

#jpoli
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.103 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;

#DSotomayor
iptables -I FORWARD -p tcp --dport 443 -s 10.0.10.41 -m string --string 'youtube.com' --algo bm --to 65535 -j ACCEPT;



# |||||||||||||||||||| Negación de Accesos ||||||||||||||||||||

# (Red 8) Facebook

iptables -A FORWARD -i eth1 -s 192.168.8.0/24 -m string --algo bm --string "facebook.com" -j REJECT;
iptables -A FORWARD -i eth1 -d 192.168.8.0/24 -m string --algo bm --string "facebook.com" -j REJECT;

# (Red 10) Facebook

iptables -A FORWARD -i eth1 -s 192.168.10.0/24 -m string --algo bm --string "facebook.com" -j REJECT;
iptables -A FORWARD -i eth1 -d 192.168.10.0/24 -m string --algo bm --string "facebook.com" -j REJECT;

# |||||||||||||||||||| Aislamiento de Redes ||||||||||||||||||||

# (Red 7)

iptables -I FORWARD -s 192.168.7.0/24 -d 192.168.8.0/24 -j DROP;
iptables -I FORWARD -s 192.168.7.0/24 -d 192.168.9.0/24 -j DROP;
iptables -I FORWARD -s 192.168.7.0/24 -d 192.168.10.0/24 -j DROP;

# (Red 8)

iptables -I FORWARD -s 192.168.8.0/24 -d 192.168.7.0/24 -j DROP;
iptables -I FORWARD -s 192.168.8.0/24 -d 192.168.9.0/24 -j DROP;
iptables -I FORWARD -s 192.168.8.0/24 -d 192.168.10.0/24 -j DROP;

# (Red 9)

iptables -I FORWARD -s 192.168.9.0/24 -d 192.168.7.0/24 -j ACCEPT;
iptables -I FORWARD -s 192.168.9.0/24 -d 192.168.8.0/24 -j ACCEPT;
iptables -I FORWARD -s 192.168.9.0/24 -d 192.168.10.0/24 -j ACCEPT;

# (Red 10)

iptables -I FORWARD -s 192.168.10.0/24 -d 192.168.7.0/24 -j DROP;
iptables -I FORWARD -s 192.168.10.0/24 -d 192.168.8.0/24 -j DROP;
iptables -I FORWARD -s 192.168.10.0/24 -d 192.168.10.0/24 -j DROP;

service networking restart;

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

getStrGTWAY(){
	local RED IP
	RED="$1"; IP="$2"; 
    
    echo  "
######## «® GATEWAY ®» ########
gateway $RED.$IP
# «® ------------------ ®»

"
}

cargaInterface () {
	local BODY
	BODY="$1";

	# cat > interfaces.conf << _INTERFACE
	
	cat > /etc/network/interface << _INTERFACE
######## «® LOOPBACK ®» ########
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
# «® ------------------ ®»
$BODY
_INTERFACE

}

salePor8_89(){

	cargaInterface "
	$(getStrRED 0 '192.168.8'  9)
	$(getStrGTWAY '192.168.8' 89)
	
	$(getStrRED 1 '192.168.7'  1)
	$(getStrRED 2 '10.0.10' 1)
	
	" 
	ejecutarRUTEOs
}

salePor8_87(){

	cargaInterface "
	$(getStrRED 0 '192.168.8'  9)
	$(getStrGTWAY '192.168.8' 87)

	$(getStrRED 1 '192.168.7'  1)
	$(getStrRED 2 '10.0.10' 1)
	
	" 
	ejecutarRUTEOs
}


######## «® MENU ®» ########

while :
do
echo "«® ELEGIR EL TRONCAL DE INTERNET PARA EL PROXY ®»";
echo "";
echo "1. salePor8_89";
echo "2. salePor8_87";
echo "3. WAN TECO 60Mb Sincrónico.";
echo "";
echo "9. SALIR";
echo -n "SELECCIONE UNA OPCIÓN [1 - 4] : ";
echo "";
echo "";

read opt
case $opt in

1) ######## «® OPCION 1 ®» ########
clear;

salePor8_89

echo "--- END OPCION 1 ---";
echo "";;

2) ######## «® OPCION 2 ®» ########
clear;

salePor8_87

echo "--- END OPCION 2 ---";
echo "";;

3) ######## «® OPCION 3 ®» ########
clear;

salePor8_89

echo "--- END OPCION 3 ---";
echo "";;

9) ######## «® OPCION 4 ®» ########
clear;



echo "--- END OPCION 9 ---";
echo "";
echo "";
exit 1;;

*) ######## «® OPCION OUT ®» ########

echo "$opc no es una opción válida.";
echo "Presiona una tecla para continuar...";
read foo;;
esac
done

