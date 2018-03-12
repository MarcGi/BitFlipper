#!/bin/bash
flip() {
temp=${arr[$1]}
  if [ $temp -eq 0 ]
   then
    arr[$1]=1
  elif [ $temp -eq 1 ]
   then
    arr[$1]=0
	else
	echo "Here $1 ${arr[$1]}"
  fi
}
orig='457f81fc688f61b4c98519c549076587'
sha1='k764d0074a4652f5871f01eb6c13732434850fecf'
declare -u orig
orig=$orig
#command="$(echo -n "$modified" | openssl sha1)"
bon=$(echo "obase=2; ibase=16; $orig" | BC_LINE_LENGTH=0 bc )
#echo "$bon"
f1=0
f2=0
f3=0

for (( i=0 ; i < ${#bon}; i++ )) do
	arr[$i]=${bon:i:1}
done

arrcopy=("${arr[@]}")
echo "${#arrcopy[@]}"
echo "${#arr[@]}"
echo "${#arrcopy}"
try=0
for ((f1=0; f1 < ${#arr[@]}; f1++)) do
	flip $f1
	
		for ((f2=f1; f2 < ${#arr[@]}; f2++)) do
		if [[ "$f2" -ne "$f1" ]]; then
			flip $f2
		fi
				for ((f3=f2; f3 < ${#arr[@]}; f3++)) do
				if [[ "$f3" -ne "$f2" ]]; then
					flip $f3
				fi
				try=$(($try+1))
				newarr=("${arr[@]}")
				hext=$(printf '%s'  ${newarr[@]})
			        hex=$(echo "obase=16; ibase=2; $hext" | BC_LINE_LENGTH=0 bc)
				declare -l hextemp
				hextemp=$hex
				command="$(echo -n "$hextemp" | openssl sha1)"
				command=${command:9}
				if [[ $command == $sha1 ]];
				then
					echo "KEY IS: $hex"
					echo "KEY IS: $hex" >> key.txt
					exit
				fi
				echo "$hext $hextemp $command \n $try"
				echo "$hext $hextemp $command \n $try" >> log.txt
				if [[ "$f3" -ne "$f2" ]]; then
					flip $f3
				fi
				done
		if [[ "$f2" -ne "$f1" ]]; then
			flip $f2
		fi
		done
	flip $f1
done
