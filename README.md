# LC_LPS
Measure current log forwarding rates on a log collector.



This script will poll an existing M-series platform (in either mixed or logger mode) for the number of logs per second being received.


Usage: "./lc_lps.sh" - The script will prompt for all additional information.


The script uses SNMP to fetch the LPS OID in the Log Collector MIB. This OID is refreshed every 5 minutes, so the script will sample every 5 minutes. The script will prompt for the number of samples you would like to run as well as the SNMP version you are using (2 or 3). Example numbers for different time intervals:

-------------------------------
1 hour - 12 samples

12 hours - 144 samples

24  hours - 1440 samples

<br>

When selecting SNMP version 3, you will be prompted for both your auth and priv passwords.

If you have any issues, please contact cstancill@paloaltonetworks.com
