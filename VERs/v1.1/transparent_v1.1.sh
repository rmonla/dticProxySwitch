#!/bin/bash
clear
while :
do
echo "ELEGIR EL TRONCAL DE INTERNET PARA EL PROXY"
echo "1. WAN IP PARA TODOS 30MB"
echo "2. WAN IP PARA TODOS 10M Dedicados Fibra Óptica"
echo "3. WAN TELECOM RECTORADO 60M Dedicados Fibra Óptica(190)"
echo "4. SALIR"
echo -n "SELECCIONE UNA OPCIÓN [1 - 4] : "
read opcion
case $opcion in

1)


SQUID_SERVER="192.168.7.1";
INTERNET="eth0";
LOCAL="192.168.7.0/24";
REC="192.168.8.0/24"
SQUID_PORT="3128";

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

iptables -A INPUT -i $INTERNET -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -s $LOCAL -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -s $REC -m state --state ESTABLISHED,RELATED -j ACCEPT;

iptables -t nat -A POSTROUTING -o $INTERNET -j MASQUERADE;

iptables -A FORWARD -s $LOCAL -j ACCEPT;
iptables -A INPUT -s $LOCAL -j ACCEPT;
iptables -A OUTPUT -s $LOCAL -j ACCEPT;
iptables -A FORWARD -s $REC -j ACCEPT;
iptables -A INPUT -s $REC -j ACCEPT;
iptables -A OUTPUT -s $REC -j ACCEPT;

iptables -t nat -A PREROUTING -s $LOCAL -p tcp --dport 80 -j DNAT --to $SQUID_SERVER:$SQUID_PORT;
iptables -t nat -A PREROUTING -s $REC -p tcp --dport 80 -j DNAT --to $SQUID_SERVER:$SQUID_PORT;
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 80 -j REDIRECT --to-port $SQUID_PORT;

iptables -A INPUT -i $INTERNET -j ACCEPT;
iptables -A OUTPUT -o $INTERNET  -j ACCEPT;

iptables -A INPUT -j LOG;
iptables -A INPUT -j DROP;

# |||||||||||||||||||| Habilitacion de Accesos ||||||||||||||||||||

# (Red 7) Facebook

iptables -A FORWARD -i eth1 -s 192.168.7.60 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.60 -m string --algo bm --string "facebook.com" -j ACCEPT;

# Jorge Gracia (DITIC)

iptables -A FORWARD -i eth1 -s 192.168.7.69 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.69 -m string --algo bm --string "facebook.com" -j ACCEPT;

# Roberto Caniza (DITIC)

iptables -A FORWARD -i eth1 -s 192.168.7.67 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.67 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth1 -s 192.168.7.59 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.59 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth1 -s 192.168.7.66 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.66 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth1 -s 192.168.7.35 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.35 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth1 -s 192.168.7.117 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.117 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth1 -s 192.168.7.116 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.116 -m string --algo bm --string "facebook.com" -j ACCEPT;

# |||||||||||||||||||| Negación de Accesos ||||||||||||||||||||

# (Red 7) Facebook

iptables -A FORWARD -i eth1 -s 192.168.7.0/24 -m string --algo bm --string "facebook.com" -j REJECT;
iptables -A FORWARD -i eth1 -d 192.168.7.0/24 -m string --algo bm --string "facebook.com" -j REJECT;

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

echo "¡Listo!";;



2)


SQUID_SERVER="192.168.7.1";
INTERNET="eth0";
LOCAL="192.168.7.0/24";
REC="192.168.11.0/24"
SQUID_PORT="3128";

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

iptables -A INPUT -i $INTERNET -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -s $LOCAL -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -s $REC -m state --state ESTABLISHED,RELATED -j ACCEPT;

iptables -t nat -A POSTROUTING -o $INTERNET -j MASQUERADE;

iptables -A FORWARD -s $LOCAL -j ACCEPT;
iptables -A INPUT -s $LOCAL -j ACCEPT;
iptables -A OUTPUT -s $LOCAL -j ACCEPT;
iptables -A FORWARD -s $REC -j ACCEPT;
iptables -A INPUT -s $REC -j ACCEPT;
iptables -A OUTPUT -s $REC -j ACCEPT;

iptables -t nat -A PREROUTING -s $LOCAL -p tcp --dport 80 -j DNAT --to $SQUID_SERVER:$SQUID_PORT;
iptables -t nat -A PREROUTING -s $REC -p tcp --dport 80 -j DNAT --to $SQUID_SERVER:$SQUID_PORT;
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 80 -j REDIRECT --to-port $SQUID_PORT;

iptables -A INPUT -i $INTERNET -j ACCEPT;
iptables -A OUTPUT -o $INTERNET  -j ACCEPT;

iptables -A INPUT -j LOG;
iptables -A INPUT -j DROP;

# |||||||||||||||||||| Negación de Accesos ||||||||||||||||||||

iptables -A FORWARD -i eth0 -s 192.168.7.0/24 -m string --algo bm --string "facebook.com" -j REJECT;
iptables -A FORWARD -i eth0 -d 192.168.7.0/24 -m string --algo bm --string "facebook.com" -j REJECT;

iptables -A FORWARD -i eth0 -s 192.168.7.0/24 -m string --algo bm --string "es-la.facebook.com" -j REJECT;
iptables -A FORWARD -i eth0 -d 192.168.7.0/24 -m string --algo bm --string "es-la.facebook.com" -j REJECT;

# |||||||||||||||||||| Habilitacion de Accesos ||||||||||||||||||||

# (Red 7) Facebook

iptables -A FORWARD -i eth0 -s 192.168.7.69 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.69 -m string --algo bm --string "facebook.com" -j ACCEPT;

# Roberto Caniza (DITIC)

iptables -A FORWARD -i eth0 -s 192.168.7.67 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.67 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.59 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.59 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.66 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.66 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.35 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.35 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.117 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.117 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.116 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.116 -m string --algo bm --string "facebook.com" -j ACCEPT;


# |||||||||||||||||||| Aislamiento de Redes ||||||||||||||||||||

# (Red 7)

iptables -I FORWARD -s 192.168.7.0/24 -d 192.168.8.0/24 -j DROP;
iptables -I FORWARD -s 192.168.7.0/24 -d 192.168.9.0/24 -j DROP;
iptables -I FORWARD -s 192.168.7.0/24 -d 192.168.10.0/24 -j DROP;

service networking restart;

echo "¡Listo!";;


3)


SQUID_SERVER="192.168.7.1";
INTERNET="eth0";
LOCAL="192.168.7.0/24";
REC="190.114.205.0/24"
SQUID_PORT="3128";

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

iptables -A INPUT -i $INTERNET -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -s $LOCAL -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A INPUT -s $REC -m state --state ESTABLISHED,RELATED -j ACCEPT;

iptables -t nat -A POSTROUTING -o $INTERNET -j MASQUERADE;

iptables -A FORWARD -s $LOCAL -j ACCEPT;
iptables -A INPUT -s $LOCAL -j ACCEPT;
iptables -A OUTPUT -s $LOCAL -j ACCEPT;
iptables -A FORWARD -s $REC -j ACCEPT;
iptables -A INPUT -s $REC -j ACCEPT;
iptables -A OUTPUT -s $REC -j ACCEPT;

iptables -t nat -A PREROUTING -s $LOCAL -p tcp --dport 80 -j DNAT --to $SQUID_SERVER:$SQUID_PORT;
iptables -t nat -A PREROUTING -s $REC -p tcp --dport 80 -j DNAT --to $SQUID_SERVER:$SQUID_PORT;
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 80 -j REDIRECT --to-port $SQUID_PORT;

iptables -A INPUT -i $INTERNET -j ACCEPT;
iptables -A OUTPUT -o $INTERNET  -j ACCEPT;

iptables -A INPUT -j LOG;
iptables -A INPUT -j DROP;

# |||||||||||||||||||| Habilitacion de Accesos ||||||||||||||||||||

# (Red 7) Facebook

iptables -A FORWARD -i eth0 -s 192.168.7.60 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.60 -m string --algo bm --string "facebook.com" -j ACCEPT;

# Jorge Gracia (DITIC)

iptables -A FORWARD -i eth1 -s 192.168.7.69 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth1 -d 192.168.7.69 -m string --algo bm --string "facebook.com" -j ACCEPT;

# Roberto Caniza (DITIC)

iptables -A FORWARD -i eth0 -s 192.168.7.67 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.67 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.59 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.59 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.66 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.66 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.35 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.35 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.117 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth -d 192.168.7.117 -m string --algo bm --string "facebook.com" -j ACCEPT;

iptables -A FORWARD -i eth0 -s 192.168.7.116 -m string --algo bm --string "facebook.com" -j ACCEPT;
iptables -A FORWARD -i eth0 -d 192.168.7.116 -m string --algo bm --string "facebook.com" -j ACCEPT;

# |||||||||||||||||||| Negación de Accesos ||||||||||||||||||||

# (Red 7) Facebook

iptables -A FORWARD -i eth0 -s 192.168.7.0/24 -m string --algo bm --string "facebook.com" -j REJECT;
iptables -A FORWARD -i eth0 -d 192.168.7.0/24 -m string --algo bm --string "facebook.com" -j REJECT;

# (Red 8) Facebook

iptables -A FORWARD -i eth0 -s 192.168.8.0/24 -m string --algo bm --string "facebook.com" -j REJECT;
iptables -A FORWARD -i eth0 -d 192.168.8.0/24 -m string --algo bm --string "facebook.com" -j REJECT;

# (Red 10) Facebook

iptables -A FORWARD -i eth0 -s 192.168.10.0/24 -m string --algo bm --string "facebook.com" -j REJECT;
iptables -A FORWARD -i eth0 -d 192.168.10.0/24 -m string --algo bm --string "facebook.com" -j REJECT;

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

echo "¡Listo!";;



4) clear;
exit 1;;

*) echo "$opc no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;;
esac
done

