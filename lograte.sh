#!/bin/bash

# Initialize COUNTER - used to keep track of how many samples we have.
#COUNTER=0
# Used to total all samples.
running_total=0
# Used to store the calculated average log rate.
avg_lps=0
# Used to store the current sample value.
curr_sample=0

function get_samplesv2(){
	echo "Enter the SNMP read string: "
	read snmp_read

	COUNTER=0
	while [ $COUNTER -lt $1 ]; do
		snmpget -v 2c -c $snmp_read $lc_IP .1.3.6.1.4.1.25461.2.3.30.1.1.0 >> lps.sample
		COUNTER=$[$COUNTER +1]
		sleep 10
	done
}

function get_samplesv3(){
	echo "Username: "
	read snmp_user

	echo "Auth Password: "
	read snmp_auth

	echo "Priv Password: "
	read snmp_priv

	COUNTER=0
	while [ $COUNTER -lt $1 ]; do
		snmpget -v3 -Pu -a SHA -A $snmp_auth -l authPriv -u $snmp_user -x AES -X $snmp_priv $lc_IP .1.3.6.1.4.1.25461.2.3.30.1.1.0 >> lps.sample
		COUNTER=$[$COUNTER +1]
		sleep 10
	done
}



#Get firewall IP, read string, and number of samples
echo "Enter IP address of the log collector. This can be an M-series in mixed mode or a dedicated log collector: "
read lc_IP

echo "Enter number of samples. Samples are taken every 10 seconds. For example, a 1 hour sample is 3600/10, or 360 samples: "
read num_of_samples

echo "Enter SNMP version (2 or 3): "
read snmp_version


if [ $snmp_version -eq 2 ]
then
	get_samplesv2 $num_of_samples
elif [ $snmp_version -eq 3 ]; then
	get_samplesv3 $num_of_samples
else
	echo "Please choose either 2 or 3 for SNMP version."
	exit 1
fi






Samples="lps.sample"
while read -r line
do
	curr_sample=${line:54}
	running_total=$[$running_total+$curr_sample]
done < "$Samples"


avg_lps=$[$running_total/$num_of_samples]

echo "The average log rate for this sample period is "
echo $avg_lps
