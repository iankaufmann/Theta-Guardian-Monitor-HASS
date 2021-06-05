#!/bin/bash

##########################################################
## Config
##########################################################

# Enter your guardian node address
guardian_node_address=""

# Hold list of offline nodes
offline_nodes=()

# Hold list update date
list_update_date="false"

##########################################################
## Get Data From Guardian Monitor
##########################################################

# Make sure guardian node address is configured
if [ "${guardian_node_address}" != "" ]; then 

    data="$(wget -qO- "https://guardianmonitor.io/tables/offlinelist.txt")"

    while IFS= read -r line; do

        # Trim whitespace
        line="$(echo -n "${line}" | xargs)"

        # Store the first non-blank line as the list update date
        if [ "${line}" != "" ] && [ "${list_update_date}" == "false" ]; then 
            list_update_date="${line}"
        fi 

        # Store any line that begins with "0x" as an address
        if [ "${line:0:2}" == "0x" ]; then 
            offline_nodes=("${line}")
        fi  

    done <<< "$data"

    ##########################################################
    ## Parse And Convert Date
    ##########################################################

    # This will hold the parts of the date
    date_array=()

    # Split the date string into parts on comma
    date_string_split="$(echo "${list_update_date}" | tr "," "\n")"

    # Load the parts into the date array
    for part in $date_string_split
    do
        date_array+=("${part}")
    done

    # Pop off the first array element (Weekday)
    date_array=("${date_array[@]:1}")

    # Convert the month name into it's numeric version
    case "${date_array[0]}" in
        January) month="01" ;;
        February) month="02" ;;
        March) month="03" ;;
        April) month="04" ;;
        May) month="05" ;;
        June) month="06" ;;
        July) month="07" ;;
        August) month="08" ;;
        September) month="09" ;;
        October) month="10" ;;
        November) month="11" ;;
        December) month="12" ;;
    esac

    # Build date string in Y-m-d H:M:S format
    date_string="${date_array[2]}-${month}-${date_array[1]} ${date_array[3]}" 

    # Convert date to unix timestamp
    date_in_seconds=`date --utc --date="${date_string}" +"%s"`

    # If the time is PM, add 12 hours
    if [ "${date_array[4]}" == "PM" ]; then 
        date_in_seconds=`expr ${date_in_seconds} + 43200`
    fi

    # Store final date format as Y-m-dTH:M:SZ UTC
    list_update_date=`date --utc -d @${date_in_seconds} +"%Y-%m-%dT%H:%M:%SZ"`

fi

##########################################################
## Check Array For Guardian Node Address
##########################################################

status="Online"

if [[ " ${offline_nodes[@]} " =~ " ${guardian_node_address} " ]]; then
    status="Offline"
fi 

# Output JSON for Home Assistant
echo '{\"status\": \"'${status}'\", \"last_update\": \"'${list_update_date}'\"}' 