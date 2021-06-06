# Theta-Guardian-Monitor-HASS
Bash script and command line sensor for monitoring your Theta Guardian Node using guardianmonitor.io

### guardianmonitor.io 

guardianmonitor.io lists all Theta Guardian Nodes on their website.  They also offer a URL to obtain a list of nodes that are currently offline.

https://guardianmonitor.io/tables/offlinelist.txt

Their suggested method of using this is to link it up with UptimeRobot.

However, if you prefer to do things yourself (and like having things in Home Assistant), then this will help you get it integrated.

### Bash Script

Since the offline list just a simple .txt file without much structure to it, I needed to create a bash script to process it first.  This is what the Home Assistant command_line sensor will read from.

I could have probably just greped the output of curl to look for the node address as a 1 liner, but I wanted the sensor to also tell me the last update time that is published in the first line of the list.  It uses a non-standard date format for some reason so I had to write something that would parse it into a sane format that Home Assistant would understand and display properly.  

This may be over-engineered but it also leaves the door open for maybe doing more with it in the future.

To install, copy the `bash_scripts` folder to your `/config` directory and edit the `guardian_node_address` variable.

### Home Assistant Package

The home assistant package consists of a command_line sensor and a template sensor, as well as an automation for setting up an alert if your node is offline.

To install, copy the `theta.yaml` file to your `/config/packages` directory and add your `notify` platform of choice to the alert automation.

If you don't have packages configured, look here:
https://www.home-assistant.io/docs/configuration/packages/

### Screenshot

<img width="480" alt="Theta-Guardian-Monitor-HASS" src="https://user-images.githubusercontent.com/1100001/120906583-54451a00-c620-11eb-8bbf-18618cf33314.png">
