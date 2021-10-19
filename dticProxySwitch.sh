#!/bin/sh
clear

# |||||||||||||||||||| VARIABLES ||||||||||||||||||||

red_8="

# «® RED 192.168.8.0 ®»

allow-hotplug eth0
iface eth0 inet static

address 192.168.8.9
netmask 255.255.255.0
broadcast 192.168.8.255
network 192.168.8.0

gateway 192.168.8.86

# «® ------------------ ®»
";
red_7="

# «® RED 192.168.7.0 ®»

allow-hotplug eth1
iface eth1 inet static

address 192.168.7.1
netmask 255.255.255.0
broadcast 192.168.7.255
network 192.168.7.0

# «® ------------------ ®»
";

# |||||||||||||||||||| FUNCIONES ||||||||||||||||||||

cargaInterface () {
	cat >interfaces.conf << _INTERFACE
# «® ------------------ ®»

source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback

# «® ------------------ ®»
$red_8
$red_7

_INTERFACE

}



# |||||||||||||||||||| MENU ||||||||||||||||||||

while :
do
echo "«® ELEGIR EL TRONCAL DE INTERNET PARA EL PROXY ®»";
echo "";
echo "1. WAN IPT 30Mb Asincrónico.";
echo "2. WAN IPT 10Mb Asincrónico.";
echo "3. WAN TECO 60Mb Sincrónico.";
echo "";
echo "4. SALIR";
echo -n "SELECCIONE UNA OPCIÓN [1 - 4] : ";
echo "";
echo "";

read opt
case $opt in

1) # |||||||||||||||||||| OPCION 1 ||||||||||||||||||||
clear;
echo "";

cargaInterface

echo "####### END OPCION 1 #######";
echo "";;

2) # |||||||||||||||||||| OPCION 2 ||||||||||||||||||||
clear;
echo "";


echo "#######  END OPCION 2 #######";
echo "";;

3) # |||||||||||||||||||| OPCION 3 ||||||||||||||||||||
clear;
echo "";


echo "####### END OPCION 3 #######";
echo "";;

4) # |||||||||||||||||||| OPCION 4 ||||||||||||||||||||
clear;
echo "";



echo "####### END OPCION 4 #######";
echo "";
echo "";
exit 1;;

*) # |||||||||||||||||||| OPCION OUT ||||||||||||||||||||

echo "$opc no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;;
esac
done

