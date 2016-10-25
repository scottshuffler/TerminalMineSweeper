#! /bin/bash
game_status=0
declare -a GRID=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
init () {
	clear
	echo ${GRID[*]}
	echo "\n"
	echo "   1 2 3 4 5 6 7 "
	echo "  ---------------"
	echo "a |? ? ? ? ? ? ?|"
	echo "b |? ? ? ? ? ? ?|"
	echo "c |? ? ? ? ? ? ?|"
	echo "d |? ? ? ? ? ? ?|"
	echo "e |? ? ? ? ? ? ?|"
	echo "f |? ? ? ? ? ? ?|"
	echo "g |? ? ? ? ? ? ?|"
	echo "  ---------------"
	echo "\n"
	place_bombs
}

place_bombs () {
	count=0
	declare -a BOMBS
	while [ $count -lt 7 ];
	do
		rand_num=$(( ( RANDOM % 49 )  + 1 ))
		if [ ${#BOMBS[@]} -eq 0 ];then
                	echo "Empty list"
			BOMBS[$count]=$rand_num
			let count=count+1
		else
			echo "Not empty"
			for i in "${BOMBS[@]}"
			do
				if [[ ! ${rand_num} =~ ${BOMBS[@]} ]];then
			       		BOMBS[$count]=$rand_num
		               		let count=count+1
			 		break		
				fi
			done
		fi
		# BOMBS[$count]
		echo ${BOMBS[*]}
		#let count=count+1

	done
}

init

while [ $game_status -eq 0 ]
do 
	echo -n " What is your move? (A1) "
	read  move
	echo $move
	game_status=1
done
