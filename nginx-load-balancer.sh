#!/bin/bash
cont_count=$1
echo "creating $cont_count containers.."
sleep 2;

# Remvoe the old docker  if exist

sudo docker run --name www.petclinic -itd -p 7060:8080 abc-img /bin/bash
sudo docker exec www.petclinic /root/apache-tomcat-7.0.104/bin/startup.sh
sleep 10;
curl http://192.168.205.10:7060/petclinic
sleep 10;
sudo docker commit www.petclinic base-war-image

dockerList=`sudo docker ps -a -q  --format "table {{.Names}}" | grep -i "petclinic\|nginx_load_balancder" `

if [ -z "$dockerList" ] ; then
        echo "String null"
else
sudo docker ps -a -q  --format "table {{.Names}}" | grep -i "petclinic\|nginx_load_balancder"  | xargs  sudo  docker rm -f
fi



script="upstream loadbalance { \n least_conn; \n "
script2=""
echo "$script"
servername_ip=`ifconfig eth1 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
for i in `seq $cont_count`
do
	echo "=============================="
        echo "Creating www.petclinic$i container.."
        sleep 1
        sudo docker run --name www.petclinic$i -itd -p 706$i:8080 base-war-image /bin/bash
        sudo docker exec www.petclinic$i /root/apache-tomcat-7.0.104/bin/startup.sh
        echo "www.petclinic$i container has been created!"
        #sudo docker restart www.petclinic$i 
        
	echo "=============================="
       

        script2="$script2 \n server $servername_ip:706$i;\n "
done

script3="$script $script2  \n } \n server { \n location / { \n proxy_pass http://loadbalance;  \n } \n }"
cd  nginx
rm  -f nginx.conf
echo $script3 >nginx.conf
docker build -t load-balance-nginx .
docker run --name nginx_load_balancder -p 8080:80 -d load-balance-nginx


