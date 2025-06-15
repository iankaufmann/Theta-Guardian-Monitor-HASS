#!/bin/bash

##########################################################
## Config
##########################################################

# Enter your guardian node address
guardian_node_address=""
guardian_node_address_lower="$(echo ${guardian_node_address} | tr '[:upper:]' '[:lower:]')"

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
            line_lower="$(echo ${line} | tr '[:upper:]' '[:lower:]')"
            offline_nodes+=("${line_lower}")
        fi  

    done <<< "$data"

    ##########################################################
    ## Parse And Convert Date
    ##########################################################

    # These will hold the parts of the date and time
    date_time_array=()
    time_array=()

    # Split the last update date string into parts on comma
    date_time_string_split="$(echo "${list_update_date}" | tr "," "\n")"

    # Load the parts into the date/time array
    for part in $date_time_string_split
    do
        date_time_array+=("${part}")
    done

    # Pop off the first array element (It's the weekday and we don't need it)
    date_time_array=("${date_time_array[@]:1}")

    # Convert the month name into it's numeric version
    case "${date_time_array[0]}" in
        January) month="1" ;;
        February) month="2" ;;
        March) month="3" ;;
        April) month="4" ;;
        May) month="5" ;;
        June) month="6" ;;
        July) month="7" ;;
        August) month="8" ;;
        September) month="9" ;;
        October) month="10" ;;
        November) month="11" ;;
        December) month="12" ;;
    esac

    # Store date parts and format them 
    year=`printf "%04d\n" ${date_time_array[2]}`
    month=`printf "%02d\n" ${month}`
    day=`printf "%02d\n" $(expr ${date_time_array[1]} + 0)`

    # Split the time string into parts on colon
    time_string_split="$(echo "${date_time_array[3]}" | tr ":" "\n")"

    # Load the parts into the time array
    for part in $time_string_split
    do
        time_array+=("${part}")
    done

    # Store time parts and format them
    hour=`printf "%02d\n" ${time_array[0]}`
    minute=`printf "%02d\n" ${time_array[1]}`
    second=`printf "%02d\n" ${time_array[2]}`
    ampm="${date_time_array[4]}"

    # If the time is AM and the hour is 12, set hour to zero
    if [ "${ampm}" == "AM" ] && [ "${hour}" == "12" ]; then  
        hour="00"
    fi

    # Build time string
    time_string="${hour}:${minute}:${second}"

    # Build date/time string in Y-m-d H:M:S format
    date_time_string="${year}-${month}-${day} ${time_string}" 

    # Convert date/time to unix timestamp
    date_in_seconds=`date --utc --date="${date_time_string}" +"%s"`

    # If the time is PM and the hour is not 12, add 12 hours
    if [ "${ampm}" == "PM" ] && [ "${hour}" != "12" ]; then 
        date_in_seconds=`expr ${date_in_seconds} + 43200`
    fi

    # Store final date/time format as Y-m-dTH:M:SZ UTC
    list_update_date=`date --utc -d @${date_in_seconds} +"%Y-%m-%dT%H:%M:%SZ"`

fi

##########################################################
## Check Array For Guardian Node Address
##########################################################

status="Online"

if [[ ${offline_nodes[@]} =~ ${guardian_node_address_lower} ]]; then
    status="Offline"
fi 

# Output JSON for Home Assistant
echo '{\"status\": \"'${status}'\", \"last_update\": \"'${list_update_date}'\"}' 