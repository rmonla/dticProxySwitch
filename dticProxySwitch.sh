#!/bin/sh
clear

######## «® VARIABLES ®» ########



######## «® FUNCIONES ®» ########
getStrGTWAY(){
	local RED IP
	RED="$1"; IP="$2"; 
    
    echo  "
######## «® GATEWAY ®» ########
gateway $RED.$IP
# «® ------------------ ®»

"

    # echo -n "$RED" "$ETH" "$IP" >&2
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

    # echo -n "$RED" "$ETH" "$IP" >&2
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

