#!/bin/bash
game_status=0

#COLORS
NC='\033[0m'
BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
PURPLE='\033[0;35m'       # Purple
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White


declare -a GRID=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
declare -a VISIBLE=("f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f" "f")

declare -a LETTERS=(a b c d e f g)
declare -i board_size=7
declare -i left_top_corner=0
declare -i right_top_corner=$board_size-1
declare -i left_bottom_corner=$right_top_corner*$board_size
declare -i right_bottom_corner=$left_bottom_corner+$board_size-1

init () {
    clear
    echo ""
    printf "${RED}     1 2 3 4 5 6 7 ${NC}\n"
    printf "${GREEN}   -----------------${NC}\n"
    for ((i=0;i<$board_size;i++))do
        printf "${RED} %s${NC} ${GREEN}|${NC} " ${LETTERS[i]}
        for ((j=0;j<$board_size;j++))do
                printf "? "
        done
        printf "${GREEN}|${NC} \n"
    done
    printf "${GREEN}   -----------------${NC}"
    echo ""
    place_bombs
}
draw_board () {
    clear
    echo ""
    printf "${RED}     1 2 3 4 5 6 7 ${NC}\n"
    printf "${GREEN}   -----------------${NC}\n"
    for ((i=0;i<$board_size;i++))do
        printf "${RED} %s${NC} ${GREEN}|${NC} " ${LETTERS[i]}
        for ((j=0;j<$board_size;j++))do
            item=${GRID[7*$i+$j]}
            let "place=7*$i+$j"
            if [ ${VISIBLE[$place]} == "t" ];then
                printf "${YELLOW}%d${NC} " $item
            else
                printf "? "
            fi
            # printf "${YELLOW}%d${NC} " $item
            # if [ $item -eq -1 ];then
            #     # printf "? "
            #     printf "B "
            # else
            #     printf "${YELLOW}%d${NC} " $item
            # fi
        done
        printf "${GREEN}|${NC} \n"
    done
    printf "${GREEN}   -----------------${NC}"
    echo ""
}
place_bombs () {
	count=0
	declare -a BOMBS
	while [ $count -lt 7 ];
	do
		rand_num=$(( ( RANDOM % 48 )  + 1 ))

        if [ $count -eq 0 ];then
            GRID[$rand_num]=-1
            let "count++"
        else
            if [ ${GRID[$rand_num]} -ne -1 ];then
                GRID[$rand_num]=-1
                let "count++"
            fi
        fi
	done
    calculate_board
}
calculate_board () {
    count=0
    let "upper_edge_bound=0"
    let "lower_edge_bound=$board_size*$board_size-1"

    for ((i=0;i<$board_size;i++))do
        let "left_edge=i*7"
        let "right_edge=left_edge+6"

        for ((j=0;j<$board_size;j++))do
            item=${GRID[7*$i+$j]}
            let "index=7*$i+$j"

            if [ $item -eq -1 ];then
                let "left=$index-1"
                let "right=$index+1"
                let "up=$index-7"
                let "down=$index+7"

                let "up_left_edge=$left_edge-7"
                let "up_right_edge=$right_edge-7"
                let "down_left_edge=$left_edge+7"
                let "down_right_edge=$right_edge+7"

                let "left_top_diag=$up-1"
                let "right_top_diag=$up+1"
                let "left_bottom_diag=$down-1"
                let "right_bottom_diag=$down+1"

                # Left checks
                if [ $left -ge $left_edge ];then
                    if [ ${GRID[$left]} -ne -1 ];then
                        (( GRID[$left]++ ))
                    fi
                fi
                #Right checks
                if [ $right -le $right_edge ];then
                    if [ ${GRID[$right]} -ne -1 ];then
                        (( GRID[$right]++ ))
                    fi
                fi
                # Up checks
                if [ $up -ge $upper_edge_bound ];then
                    if [ ${GRID[$up]} -ne -1 ];then
                        (( GRID[$up]++ ))
                    fi 
                fi
                #Down checks
                if [ $down -le $lower_edge_bound ];then
                    if [ ${GRID[$down]} -ne -1 ];then
                        (( GRID[$down]++ ))
                    fi
                fi
                #Down Left Diag check
                if [ $left_bottom_diag -ge $down_left_edge ] && [ $left_bottom_diag -le $lower_edge_bound ];then
                    if [ ${GRID[$left_bottom_diag]} -ne -1 ];then
                        (( GRID[$left_bottom_diag]++ ))
                    fi
                fi
                #Down Right Diag check
                if [ $right_bottom_diag -le $down_right_edge ] && [ $right_bottom_diag -le $lower_edge_bound ];then
                    if [ ${GRID[$right_bottom_diag]} -ne -1 ];then
                        (( GRID[$right_bottom_diag]++ ))
                    fi
                fi
                #Top Left Diag check
                if [ $left_top_diag -ge $up_left_edge ] && [ $left_top_diag -ge $upper_edge_bound ];then
                    if [ ${GRID[$left_top_diag]} -ne -1 ];then
                        (( GRID[$left_top_diag]++ ))
                    fi
                fi
                #Top Right Diag check 
                if [ $right_top_diag -le $up_right_edge ] && [ $right_top_diag -ge $upper_edge_bound ];then
                    if [ ${GRID[$right_top_diag]} -ne -1 ];then
                        (( GRID[$right_top_diag]++ ))
                    fi
                fi
              fi
        done
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
reveal_zeros () {

    if [ ${GRID[$1]} -eq 0 ] && [ $1 -ge 0 ] && [ $1 -le 48 ] && [ ${VISIBLE[$1]} != "t" ];then
        echo $1
        VISIBLE[$1]="t"
        reveal_zeros $(( $1 - 1 ))
        reveal_zeros $(( $1 + 1 ))
        reveal_zeros $(( $1 + 7 ))
        reveal_zeros $(( $1 - 7 ))
        reveal_zeros $(( $1 - 6 ))
        reveal_zeros $(( $1 - 8 ))
        reveal_zeros $(( $1 + 6 ))
        reveal_zeros $(( $1 + 8 ))
        echo $1
    else
        return
    fi
}



reveal_selection () {
    if [ ${VISIBLE[$1]} == "f" ];then
        if [ ${GRID[$1]} -eq -1 ];then
            echo "get bombed son"
            game_status=2
        else
            #GRID[$1]=2
            reveal_zeros $1
            echo "close one there, be careful you lunatic"
        fi
        VISIBLE[$1]="t"
        draw_board
    else
        echo "Please enter a different selection"
    fi
}
init
#draw_board
while [ $game_status -eq 0 ]
do
	echo -n " What is your move? (A1) "
	read  move
    if  [[ "$move" =~ [a-gA-G]{1}[0-7]{1} ]];then
        get_placement "$move"
        echo $second_char
        reveal_selection "$second_char"
    else
        echo "Invalid command"
    fi
    #if [ -z "$second_char" ];then
    #   echo "Should have entered a correct character"
    #else
        #fi
	#game_status=1
done

if [ $game_status -eq 2 ];then
    echo "You lost"
else
    echo "You won"
fi
