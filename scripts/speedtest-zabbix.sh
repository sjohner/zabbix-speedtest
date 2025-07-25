# Create logfile
touch $LOG_FILE
chown zabbix:zabbix $LOG_FILE
chmod 640 $LOG_FILE
echo | tee -a $LOG_FILE
echo "$(date +%F-%T)" | tee -a $LOG_FILE

# Set ID of server you want to use for the speed test
ID=23969

# Gather data
echo "Running Speedtest"
json_data=$(/usr/bin/speedtest -s $ID -f json)

# Extract values using jq and eval
SRV_NAME=$(echo "$json_data" | jq -r '.server.host')
DL=$(echo "$json_data" | jq -r '.download.bandwidth')
UP=$(echo "$json_data" | jq -r '.upload.bandwidth')
JITTER=$(echo "$json_data" | jq -r '.ping.jitter')
LATENCY=$(echo "$json_data" | jq -r '.ping.latency')
ISP=$(echo "$json_data" | jq -r '.isp')
SRV_CITY=$(echo "$json_data" | jq -r '.server.location')
WAN_IP=$(echo "$json_data" | jq -r '.interface.externalIp')

# Print some results
echo "HOST: $SRV_NAME, DOWN: $DL, UP: $UP, JITTER: $JITTER, LATENCY: $LATENCY, ISP: $ISP, SERVER CITY: $SRV_CITY, WAN IP: $WAN_IP" | tee -a $LOG_FILE

# Summarize Data for Zabbix
 echo "-" speedtest.download $DL >> $ZABBIX_DATA 
 echo "-" speedtest.upload $UP >> $ZABBIX_DATA 
 echo "-" speedtest.wan.ip $WAN_IP >> $ZABBIX_DATA 
 echo "-" speedtest.ping.jitter $JITTER >> $ZABBIX_DATA
 echo "-" speedtest.ping.latency $LATENCY >> $ZABBIX_DATA
 echo "-" speedtest.srv.name $SRV_NAME >> $ZABBIX_DATA
 echo "-" speedtest.srv.city $SRV_CITY >> $ZABBIX_DATA
 echo "-" speedtest.isp $ISP >> $ZABBIX_DATA

# Send data to Zabbix
echo "Sending Data to Zabbix"
/usr/bin/zabbix_sender --config /etc/zabbix/zabbix_agent2.conf -i $ZABBIX_DATA \
        | tee -a $LOG_FILE

# Clean data
rm $ZABBIX_DATA
