#!/bin/bash

echo
echo "This Bash script will generate Bitcoin address and privatekey using given seed"
echo
read -p "Give enough long seed to be secure (at least 12 digits)? " seed

RANDOM=$seed
#17
start=$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
#1
round=$RANDOM

check=$(ku $start 2>&1)
error=$(echo $check | grep -c "can't")
if [ $error -gt 0 ]
then
    #16
    start=$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
fi

echo "Please wait some time...generating BTC address and privatekey..."
echo
echo "0%  5%  10%  15%  20%  25%  30%  35%  40%  45%  50%  55%  60%  65%  70%  75%  80%  85%  90%  95%  100%"

mod_div=$(echo $round / 100 | BC_LINE_LENGTH=1000 bc)

for x in $(eval echo "{1..$round}")
do
  #15
  add=$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM
  start=$(echo $start + $add | BC_LINE_LENGTH=1000 bc)
  modulo=$(( $x % $mod_div ))
  if [ $modulo -eq 0 ]
  then
      printf "="
      check=$(ku $start 2>&1)
      error=$(echo $check | grep -c "can't")
      if [ $error -gt 0 ]
      then
          div=$(echo $start / 10 | BC_LINE_LENGTH=1000 bc)
          start=$(echo $start - $div | BC_LINE_LENGTH=1000 bc)
      fi
  fi
done

printf "\n"
echo
echo "Compressed privatekey and address:"
ku $start -W
ku $start -a
echo
echo "Uncompressed privatekey and address:"
ku $start -Wu
ku $start -au

size=${#seed}
if [ "$size" -lt 12 ]
then
    echo
    echo "******************************************************************************"
    echo "***   WARNING: You seed is too SHORT AND VERY UNSECURE!                    ***"
    echo "***            Seed recommended lenght should be at least 12 digits long   ***"
    echo "***            You have been warned!                                       ***"
    echo "******************************************************************************"
fi

echo
echo "NOTE: If you forget your privatekey, you could recover it by using same given seed"
echo "THIS IS YOUR SEED: $seed   KEEP IT SAFE PLACE"!
echo "DO NOT SHARE YOUR PRIVATEKEY OR SEED TO ANYONE"
echo
echo "TERMS OF USE: I will not be responsible or liable, directly or indirectly,"
echo "in any way for any loss or damage by using this software"
