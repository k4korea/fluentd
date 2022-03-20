ns="ns1.cyberciti.biz ns2.cyberciti.biz ns3.cyberciti.biz"
#To split $ns variable (string) into array, use the following IFS syntax:

OIFS="$IFS"
IFS=' '
read -a dnsservers <<< "${ns}"
IFS="$OIFS"
#OR use one liner as follows:

IFS=' ' read -a dnsservers <<< "${ns}"
#To display values stored in an array, enter:

echo ${dnsservers[0]}
echo ${dnsservers[@]}
