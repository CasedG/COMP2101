#!/bin/bash
#
# this script generates a report of the files on the system that have the setuid permission bit turned on
# it is for the lab1 exercise
# it uses the find command to find files of the right type and with the right permissions, and an error redirect to
# /dev/null so we do not get errors for inaccessible directories and files
# the identified files are sorted by their owner

# Task 1 for the exercise is to modify it to also display the 12 largest regular files in the system, sorted by their sizes
# The listing should
#    only have the file name, owner, and size of the 12 largest files
#    show the size in human friendly format
#    be displayed after the listing of setuid files
#   should have its own title, similar to how the setuid files listing has a title
# use the find command to generate the list of files with their sizes, with an error redirect to /dev/null
# use cut or awk to display only the output desired

echo "Setuid files:"
echo "============="
find / -type f -executable -perm -4000 -ls 2>/dev/null | sort -k 5
echo ""
#professors sort command will not work with his find command (sorts by the fifth field, yes, 
#but it does not organize the numbers, and when you try to use the -n option, it fails to organize it
#prof only gave me 2 out 3 marks for this despite using the files as indicated with his command so be cautious/speak up

echo "Setuid files: largest files by owner and size"
echo "============="
find / -type f -executable -perm -4000 -exec ls -lh {} + 2>/dev/null | sort -k 5 -hr | head -n 12 |awk '{print $3, $5, $9}'
# not too sure how to approach this other than adding the exec command so that ls is executed on every line/file found with the human readable option
echo ""
# for the task, add
# commands to display a title
# commands to make a list of the 12 biggest files
# sort/format whatever to display the list properly
#
#how to make the prof's command work with sort 
find / -type f -executable -perm 4000 -ls 2>/dev/null |awk '{print$6,$7,$11}' | sort -k2nr | head -n 12
# so remove all the xtra shit first with awk so you have only what you need to work with
#sort by the second field using n and r options (to sort by numbers and to do it in reverse order)
#so taht you can then use the head command (or use tail ifyou didn't specify -r with sort) 
