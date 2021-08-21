#!/bin/bash

#    themis privacy guard library - themis
#    Copyright (C) 2021  lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

__tpg-dep-check() {
    [[ $(command -v bc) ]] || { echo "${FUNCNAME} says: i requirus 'bc' to work" ; tpg_requirus="false";}
    [[ $(command -v sha256sum) ]] || { echo "${FUNCNAME} says: i requirus 'sha256sum' to work" ; tpg_requirus="false";}
    [[ -f /etc/machine-id ]] || { echo "${FUNCNAME} says: i requirus the file '/etc/machine-id' to work" ; tpg_requirus="false";}

    if [[ ${tpg_requirus} = "false" ]] ; then
        echo "Some required file(s) and dependencies not found! End of ${FUNCNAME} with return status 1"
        return 1
    fi
}

__get-priv-key() {
    __tpg-dep-check || return 1
    case ${1} in
        [pP][rR][iI][nN][tT]|[pP])
            cat /etc/machine-id | tr -d "[a-zA-Z]"
        ;;
        [wW][rR][iI][tT][eE]|[wW])
            [[ -d ${2} ]] && tpg_write_dir="${2}" || tpg_write_dir="${PWD}" 
            cat /etc/machine-id | tr -d "[a-zA-Z]" > ${tpg_write_dir}/${HOSTNAME}.priv
        ;;
    esac
}

__get-pub-key() {
    __tpg-dep-check || return 1
    case ${1} in
        [pP][rR][iI][nN][tT]|[pP])
            cat /etc/machine-id | tr -d "[a-zA-Z]" | sha256sum | awk '{print $1}' | tr -d "[a-zA-Z]"
        ;;
        [wW][rR][iI][tT][eE]|[wW])
            [[ -d ${2} ]] && tpg_write_dir="${2}" || tpg_write_dir="${PWD}"
            cat /etc/machine-id | tr -d "[a-zA-Z]" | sha256sum | awk '{print $1}' | tr -d "[a-zA-Z]" > ${tpg_write_dir}/${HOSTNAME}.pub
        ;;
    esac
}

tpg-sign-file() {
    __tpg-dep-check || return 1
    if [[ ${#} -gt 0 ]] ; then
        for _tpgX in $(seq 1 ${#}) ; do
            if [[ -f ${@:_tpgX:1} ]] ; then
                if [[ ! $(cat "${@:_tpgX:1}" | tail -n 1 | grep '#tpg-key:') ]] ; then
                    echo -e "\n#tpg-key:  $(echo "$(__get-pub-key p) + $(sha256sum ${@:_tpgX:1} | awk '{print $1}' | tr -d '[a-zA-Z]')" | bc) `sha256sum ${@:_tpgX:1} | awk '{print $1}' | tr -d '[a-zA-Z]'`" >> ${@:_tpgX:1}
                else
                    read -p "The ${@:_tpgX:1} file is already signed by another person. Do you want to re-sign it? (y/N)" am_i_want_to_resign_it
                    case ${am_i_want_to_resign_it} in
                        [yY][eE][sS]|[yY])
                            echo -e "\n#tpg-key:  $(echo "$(__get-pub-key p) + $(sha256sum ${@:_tpgX:1} | awk '{print $1}' | tr -d '[a-zA-Z]')" | bc) `sha256sum ${@:_tpgX:1} | awk '{print $1}' | tr -d '[a-zA-Z]'`" >> ${@:_tpgX:1}
                        ;;
                        *)
                            :
                        ;;
                    esac
                fi
            else
                echo "${FUNCNAME} says: i cant find the '${@:_tpgX:1}' file"
                __sign_file="false"
            fi
        done
    else
        echo "insufficient argument"
        __sign_file="false"
    fi
    if [[ ${__sign_file} = "false" ]] ; then
        return 1
    fi
}

tpg-check-file() {
    if [[ ${#} -gt 1 ]] ; then
        if [[ ${1} =~ ^[0-9]+$ ]] ; then
            for _tpgX in $(seq 2 ${#}) ; do
                if [[ $(cat "${@:_tpgX:1}" 2> /dev/null | tail -n 1 | grep '#tpg-key:') ]] ; then
                    if [[ $(cat "${@:_tpgX:1}" 2> /dev/null | tail -n 1 | grep '#tpg-key:' | awk '{print $2}') = $(echo "${1} + $(cat ${@:_tpgX:1} | tail -n 1 | grep '#tpg-key:' | awk '{print $3}')" | bc) ]] ; then
                        echo "${@:_tpgX:1} has signed"
                    else
                        echo "not signed"
                        __check_file="false"
                    fi
                else
                    echo "${FUNCNAME} says: the '${@:_tpgX:1}' file isn't signed yet"
                    __check_file="false"
                fi
            done
        else
            echo "${FUNCNAME} says: i don't know that pub key. Is that pub key? (${1})"
            __check_file="false"
        fi
    else
        echo "insufficient argument"
        __check_file="false"
    fi
    if [[ ${__cehck_file} = "false" ]] ; then
        return 1
    fi
}
