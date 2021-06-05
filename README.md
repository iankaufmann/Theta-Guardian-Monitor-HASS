# Theta-Guardian-Monitor-HASS
Bash script and command line sensor for monitoring your Theta Guardian Node using guardianmonitor.io

### guardianmonitor.io 

guardianmonitor.io lists all Theta Guardian Nodes on their website.  They also offer a URL to obtain a list of nodes that are currently offline.

https://guardianmonitor.io/tables/offlinelist.txt

Their suggested method of using this is to link it up with UptimeRobot.

However, if you prefer to do things yourself (and like having things in Home Assistant), then this will help you get it integrated.

Since it's just a simple .txt file without much structure to it, I needed to create a bash script to process it first.

### Home Assistant

The home assistant package consists of a command_line sensor and a template sensor, as well as an automation for setting up an alert if your node is offline.