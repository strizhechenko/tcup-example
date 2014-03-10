#!/bin/bash

. /etc/init.d/functions


declare -i call_count=0
declare -a results
declare -a outputs

_echo() {
        echo -n $@
}

echo_result() {
        case $1 in
                0 ) 
                        echo_success
                        ;;
                255 )
                        echo_passed
                        ;;
                * )
                        echo_failure
                        ;;
        esac
        echo
}

run() {
        local output="$($@)"
        local result=$?
        [ -z "$output" ] && output="-"
        outputs=( ${outputs[@]} "$output" )
        results=( ${results[@]} $result )
        ((call_count++))
        echo $@
}

print_result() {
        row=0
        for i in ${results[@]}; do
                tput cup $row 30
                echo ${outputs[$row]}
                tput cup $row 60
                echo_result $i
                sleep $((RANDOM%2))
                ((row++))
        done
}

main() {
        clear
        run echo one
        run echo two
        run echo three
        run false
        run echo 123
        run false
        run echo 345
        print_result
}

main $@
