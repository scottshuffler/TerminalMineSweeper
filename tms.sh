#! /bin/bash
game_status=0
declare -a GRID=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
init () {
	clear
	echo ""
	echo "    1 2 3 4 5 6 7 "
	echo "   ---------------"
	echo " a |? ? ? ? ? ? ?|"
	echo " b |? ? ? ? ? ? ?|"
	echo " c |? ? ? ? ? ? ?|"
	echo " d |? ? ? ? ? ? ?|"
	echo " e |? ? ? ? ? ? ?|"
	echo " f |? ? ? ? ? ? ?|"
	echo " g |? ? ? ? ? ? ?|"
	echo "   ---------------"
	echo ""
	place_bombs
}

place_bombs () {
	count=0
	declare -a BOMBS
	while [ $count -lt 7 ];
	do
		rand_num=$(( ( RANDOM % 48 )  + 1 ))

        if [ $count -eq 0 ];then
            GRID[$rand_num]=1
            let "count++"
        else
            if [ ${GRID[$rand_num]} -ne 1 ];then
                GRID[$rand_num]=1
                let "count++"
            fi
        fi
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
