#!/bin/bash
# bash needed!
# sorting algorithms demo with graph-like visualization - just 4fun ;)
# (copyleft) crysman 2015


AMEMBERS=12 #how many array members
DELAY=0.1 #s
MINNUM=1 #minimum array member number
MAXNUM=9 #maximum array member number
BARCHAR='\u2503' #| - character to draw bars
TIMEFORMAT="time: %2Rs" #for shell `time` builtin
AVAILABLEALGS=( bubble bubbledec ) #implemented functions

declare -a arr
declare -i swaps; swaps=0
declare -i cmps; cmps=0
declare -i redraws; redraws=0
declare algSelected


function usage {
  echo "usage: `basename $0` <algorithm>" 2>&1
  echo "algorithms: "${AVAILABLEALGS[@]} 2>&1
}


function drawGraph {
  clear
  redraws=$((redraws+1))
  echo $@
  for((ycoord=1;ycoord<=$MAXNUM;ycoord++)); do
    iCounter=0
    for xnum in $@; do
      iCounter=$((iCounter+1))
      if [[ $xnum -ge $ycoord ]]; then
        if [[ $iCounter -eq $i ]]; then
        #                   ^this $i comes from the for cycle in the bubblesort() !!!
          tput setaf 3
          echo -ne "$BARCHAR "
          tput sgr0
        else
          echo -ne "$BARCHAR "
        fi
      else	
        echo -ne "  "
      fi
    done
    echo ""
    #echo -ne "$imax\n"
  done
  echo "swaps: $swaps"
  echo "comparisions: $cmps"
  echo "redraws: $redraws"
}


function arrayInit {
  for((i=0;i<$AMEMBERS;i++)) do
    RND=$((MINNUM+RANDOM%MAXNUM)) #0-9
    arr[$i]=$RND
  done
  #arr=( 8 9 7 5 6 4 3 1 0 2 )
}


function swap {
# swaps a-th element with b-th element in an array
  test $# -ne 2 && {
   echo "ERR: swap() needs 2 args, exitting..." 2>&1
   exit 2
  }
  test $1 -lt $2 && {
   echo "ERR: swap() called with a<b, exitting..." 2>&1
   exit 2
  }
  #echo ${arr[@]}
  tmp=${arr[$1]}
  arr[$1]=${arr[$2]}
  arr[$2]=$tmp
  #echo "swap! ${arr[1]} <-> ${arr[2]}"
  #echo ${arr[@]}
  swaps=$((swaps+1))
  sleep $DELAY
}


function cmp {
# compares a-th with b-th, returns true if b>a
  test $# -ne 2 && {
   echo "ERR: cmp() needs 2 args, exitting..." 2>&1
   exit 2
  }
  test $1 -lt $2 && {
   echo "ERR: cmp() called with a<b, exitting..." 2>&1
   exit 2
  }
  test ${arr[$2]} -gt ${arr[$1]} && {
    cmps=$((cmps+1))
    sleep $DELAY
#    echo "$2(${arr[$2]}) > $1(${arr[$1]})"
    return 0
  }
  cmps=$((cmps+1))
  sleep $DELAY
#  echo "$2(${arr[$2]}) < $1(${arr[$1]})"
  return 1
}


function bubble() {
#dumb simple bubblesort
  sorted= #false
  imax=${#arr[@]}
  while ! test $sorted; do
    sorted=true
    #echo ${arr[@]}
    for ((i=1;i<$imax;i++)); do 
      #echo ${arr[@]}"      | $i"
      drawGraph ${arr[@]}
      cmp $i $(($i-1)) && {
        swap $i $(($i-1))
        sorted= #false
      }
    done
  done
}


function bubbledec() {
#incrementally decreases the array passing cycle
  sorted= #false
  imax=${#arr[@]}
  while ! test $sorted; do
    sorted=true
    #echo ${arr[@]}
    for ((i=1;i<$imax;i++)); do 
      #echo ${arr[@]}"      | $i"
      drawGraph ${arr[@]}
      cmp $i $(($i-1)) && {
        swap $i $(($i-1))
      }
        sorted= #false
    done
    imax=$(($imax-1))    
  done
}


# main() ...

test -z "$1" && {
#no argument passed -> exit
  usage
  exit 1  
}

correctAlg= #false
#do we have a correct argument passed?
for alg in ${AVAILABLEALGS[@]}; do
  test "$alg" == "$1" && {
    correctAlg=true
  }  
done
test $correctAlg || {
  echo "ERR: invalid algorithm selected" 2>&1
  usage
  exit 1
}
algSelected=$1
test $AMEMBERS -gt $((`tput cols`/2)) && {
#what if there is not enough terminal columns available?
  echo "ERR: not enough columns in current terminal window ("$((AMEMBERS*2))" needed)" >&2  
  exit 1
}
clear
arrayInit
echo ${arr[@]}
echo "---------------------------------"
time $algSelected

#drawGraph ${arr[@]}
#echo ${arr[@]}

echo "$algSelected has finished"
