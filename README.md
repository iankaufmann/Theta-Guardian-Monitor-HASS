# Theta-Guardian-Monitor-HASS
Bash script and command line sensor for monitoring your Theta Guardian Node using guardianmonitor.io

### guardianmonitor.io 

guardianmonitor.io lists all Theta Guardian Nodes on their website.  They also offer a URL to obtain a list of nodes that are currently offline.

https://guardianmonitor.io/tables/offlinelist.txt

Their suggested method of using this is to link it up with UptimeRobot.

However, if you prefer to do things yourself (and like having things in Home Assistant), then this will help you get it integrated.

### Bash Script

Since it's just a simple .txt file without much structure to it, I needed to create a bash script to process it first.  This is what the Home Assistant command_line sensor will read from.

To install it, copy the `bash_scripts` folder to your `/config` directory.

### Home Assistant Package

The home assistant package consists of a command_line sensor and a template sensor, as well as an automation for setting up an alert if your node is offline.

To install it, copy the `theta.yaml` file to your `/config/packages` directory.

If you don't have packages configured, look here:
https://www.home-assistant.io/docs/configuration/packages/

### Screenshot

<img width="480" alt="Theta-Guardian-Monitor-HASS" src="https://user-images.githubusercontent.com/1100001/120906583-54451a00-c620-11eb-8bbf-18618cf33314.png">
