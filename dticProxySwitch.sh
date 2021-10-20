#!/bin/sh
clear

# |||||||||||||||||||| VARIABLES ||||||||||||||||||||



# |||||||||||||||||||| FUNCIONES ||||||||||||||||||||
getStrRED(){
	local RED ETH IP
	RED="$1"; ETH="$2"; IP="$3"
    
    echo  "
# «® RED $RED ®»

allow-hotplug eth$ETH
iface eth$ETH inet static

address $RED.$IP
netmask 255.255.255.0
broadcast $RED.255
network $RED.0
# «® ------------------ ®»
"

    # echo -n "$RED" "$ETH" "$IP" >&2
}

cargaInterface () {

	cat > interfaces.conf << _INTERFACE
# «® ------------------ ®»

source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
# «® ------------------ ®»
$red_8
$red_7
$red_9

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

red_8=$(getStrRED '192.168.8' 0 9)
red_7=$(getStrRED '192.168.7' 1 1)
red_9=$(getStrRED '192.168.9' 1 5)

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

