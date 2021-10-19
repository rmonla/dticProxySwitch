
fecha=$(date "+%d-%m-%y") 

[ -f /var/log/conectividad/$fecha.log ] && echo "Found" || touch /var/log/conectividad/$fecha.log

echo "      " >> /var/log/conectividad/$fecha.log

date >> /var/log/conectividad/$fecha.log

echo "      " >> /var/log/conectividad/$fecha.log

speedtest-cli >> /var/log/conectividad/$fecha.log

echo "      " >> /var/log/conectividad/$fecha.log

[ -f /var/log/peticiones/$fecha.log ] && echo "Found" || touch /var/log/peticiones/$fecha.log

echo "      " >> /var/log/peticiones/$fecha.log

date >> /var/log/peticiones/$fecha.log

echo "      " >> /var/log/peticiones/$fecha.log

vnstat -i eth1 -tr >> /var/log/peticiones/$fecha.log

echo "      " >> /var/log/peticiones/$fecha.log

vnstat -i eth2 -tr >> /var/log/peticiones/$fecha.log

echo "      " >> /var/log/peticiones/$fecha.log

