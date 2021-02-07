#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

echo "Please enter a number"
read firstnum
echo "Please enter a second number"
read secondnum
echo "Please enter a third number"
read thirdnum

sum=$((firstnum + secondnum + thirdnum))
product=$((firstnum * thirdnum * secondnum))
#dividend=$((firstnum / secondnum))
#fpdividend=$(awk "BEGIN{printf \"%.2f\", $firstnum/$secondnum}")
#$firstnum divided by $secondnum is $dividend
#  - More precisely, it is $fpdividend

cat <<EOF
$firstnum plus $secondnum plus $thirdnum is $sum

$firstnum multiplied by $secondnum then multipled by $thirdnum is $product

EOF
