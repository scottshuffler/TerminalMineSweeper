#!/bin/bash
game_status=0
declare -a GRID=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
declare -a LETTERS=(a b c d e f g)
init () {
	clear
	echo ""
	echo "     1 2 3 4 5 6 7 "
	echo "   -----------------"
	echo " a | ? ? ? ? ? ? ? |"
	echo " b | ? ? ? ? ? ? ? |"
	echo " c | ? ? ? ? ? ? ? |"
	echo " d | ? ? ? ? ? ? ? |"
	echo " e | ? ? ? ? ? ? ? |"
	echo " f | ? ? ? ? ? ? ? |"
	echo " g | ? ? ? ? ? ? ? |"
	echo "   -----------------"
	echo ""
	place_bombs
}
draw_board () {
clear
    echo ""
    echo "     1 2 3 4 5 6 7 "
    echo "   -----------------"
    for ((i=0;i<7;i++))do
        printf " %s | " ${LETTERS[i]}
        for ((j=0;j<7;j++))do
            if [ ${GRID[7*$i+$j]} -eq 0 ] || [ ${GRID[7*$i+$j]} -eq 1 ];then
                printf "? "
            else
                printf "%d " ${GRID[7*$i+$j]}
            fi
        done
        printf "| \n"
    done
    echo "   -----------------"
    echo ""
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
get_placement () {
    if [ -z "$1" ];then
        echo 'nothing passed'
        return
    fi
    first_char="$(echo $1 | head -c 1 | awk '{print tolower($0)}')"
    second_char="$(echo $1 | head -c 2 | tail -c 1)"
    echo $first_char
    echo $second_char
    if [ $second_char -lt 8 ] && [ $second_char -gt 0 ]; then
         
        if [ $first_char == 'a' ] ;then
            first_char='-1'
        elif [ $first_char == 'b' ];then
            first_char='6'
        elif [ $first_char == 'c' ];then
            first_char='13'
        elif [ $first_char == 'd' ];then
            first_char='20'
        elif [ $first_char == 'e' ];then
            first_char='27'
        elif [ $first_char == 'f' ];then
            first_char='34'
        elif [ $first_char == 'g' ];then
            first_char='41'
        else
            echo 'Invalid character. Please enter A-G'
            unset first_char
            unset second_char
            return
        fi
    fi
    let second_char+=$first_char
#second_char is set to final grid position.
    echo $second_char


}
recursion () {
    echo ${GRID[*]}
    echo ${#GRID[*]}
    echo ${GRID[$1]}
    if [ ${GRID[$1]} -eq 1 ];then
        echo "get bombed son"
    else
        GRID[$1]=2
        echo "close one there, be careful you lunatic"
    fi
    draw_board
}
init

while [ $game_status -eq 0 ]
do
	echo -n " What is your move? (A1) "
	read  move
    if  [[ "$move" =~ [a-gA-G]{1}[0-7]{1} ]];then
        get_placement "$move"
        echo $second_char
    else
        echo "Invalid command"
    fi
    if [ -z "$second_char" ];then
       echo "Should have entered a correct character"
    else
        recursion "$second_char"
    fi
	#game_status=1
done
