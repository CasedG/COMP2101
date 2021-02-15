#!/bin/bash
#
# this script displays some host identification information for a simple Linux machine
#
# Sample output:
#   Hostname        : hostname
#   LAN Address     : 192.168.2.2
#   LAN Hostname    : host-name-from-hosts-file
#   External IP     : 1.2.3.4
#   External Name   : some.name.from.our.isp

# Task 1: Clean up this script by moving the commands that generate the output to separate lines
#         that put each command's output into variables. Once you have that done, Use those variables
#         in the output section at the end of the script. If the commands included in this script
#         don't make sense to you, feel free to create your own commands to find your ip addresses,
#         host names, etc.
#
# For example
#   In the part of the script that prints the report, the commands to generate the data are mixed in with the literal text output
#   To separate it and make it easier to read, we should take those commands and put them before the output generation, in their own section that generates the data and saves it in variables
#   Then we can just use those variables in our output section and it will be easier to read, understand, extend and debug
#
#   So a line in the output that looks like
#
#       echo "label: $(cmd1 $(cmd2)|cmd3)"
#
#   could be rewitten like this
#
#       # Data Collection/Generation Section
#       dataforcmd1=$(cmd2)
#       outputofcmd1=$(cmd1 $dataforcmd1|cmd3)
#
#       # Output Formatting/Delivery Section
#       echo "label: $outputofcmd1"
#
#   Your variable names should be sensible names that describe what is in them
#   Taking complex commands and splitting them into separate simpler pieces makes them easier to read, understand, debug, and extend or modify

# Task 2: Add variables for the default router's name and IP address.
#         Add a name for the router's IP address to your /etc/hosts file.
#         The router's name and address must be obtained by dynamically
#         finding the router IP address from the route table, and looking
#         up the router's hostname using its IP address, not by just
#         printing out literal text.
# sample of desired output:
#   Router Address  : 192.168.2.1
#   Router Hostname : router-name-from-hosts-file

# we use the hostname command to get our system name
# the LAN name is looked up using the LAN address in case it is different from the system name
# finding external information relies on curl being installed and relies on live internet connection
# awk is used to extract only the data we want displayed from the commands which produce extra data
# to find out what the ugly commands here are doing, try running them in smaller, simpler pieces
# e.g. These are 2 of the ugly lines
#
#   External IP     : $(curl -s icanhazip.com)
#   External Name   : $(getent hosts $(curl -s icanhazip.com) | awk '{print $2}')
#
#    to figure out what it is doing, try the command pipeline in the innermost parentheses separately in a terminal window
#
#   curl -s icanhazip.com
#
#    and you would find it gives you your external ip address, so rewrite it to generate and save the data in a variable
#    then use the variable in any command that needs that data
#
#   myExternalIP=$(curl -s icanhazip.com)
#
#    then use the variable in any command that needs that data (that had that command pipeline in parentheses)
#
#   myExternalName=$(getent hosts $myExternalIP | awk '{print $2}')
#
#    this makes the command to generate your external name much easier to read and understand
#    now you can use the variables you just created in your output section later in the script
#
#   External IP     : $myExternalIP
#   External Name   : $myExternalName
#
#
#
#
# I first tried these commands in bash to see what they do
# then I was able to determine what parts of the code would do
# I was able to deduce that the interface name is found using "ip a | awk '/: e/{gsub(/:/,"");print $2}')'"

hostName=$(hostname)
interfaceName=$(ip a | awk '/: e/{gsub(/:/,""); print $2}' | awk 'NR==1')
#I'll substitute the interfaceName into those areas that replace the expression
#added 'awk NR==1' to help fix issue on production server with the script producing two en values: ens33 and ens34

lanAddress=$(ip a s $interfaceName |awk '/inet /{gsub(/\/.*/,"");print $2}')
#I can then use lanAddress to substitute a part of the code for LAN hostname
lanHostNameAndIp=$(getent hosts $lanAddress)
#
#
lanHostName=$( echo $lanHostNameAndIp |awk '{print $2}')
#I was having trouble with lanHostName until I added echo in front of lanHostNameAndIp which i guess allows awk to work with it
#
externalIP=$(curl -s icanhazip.com)
externalName=$(getent hosts $externalIP | awk '{print $2}')
#
cat <<EOF
Hostname        : $hostName
LAN Address     : $lanAddress
LAN Hostname    : $lanHostName
External IP     : $externalIP
External Name   : $externalName
EOF

#TASK two
routerName=$(route|awk '/default/ {print $2}')
routerIP=$(ip r | awk '/via/ {print $3}')
cat << EOF
Router address  : $routerIP
Router name     : $routerName
EOF

#user would need 'route' installed on their computer
#if they don't, they could use getent hosts and then search by name if they know the IP address:

routerIP=$(ip r | awk '/via/ {print $3}')
#once you have the IP, you can use that to filter results from getent hosts
routerName=$(getent hosts | awk '/'$routerIP'/ {print $2}')
#to explain, I'm telling awk to begin at the router's Ip address, and then print the second column from that line
cat << EOF
Router Address : $routerIP
Router Name    : $routerName
EOF
