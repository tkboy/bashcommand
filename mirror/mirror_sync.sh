#!/bin/bash

DIR=("")
REP=()
GIT=()

CT=${#DIR[@]}
while [ 0 -lt $CT ];
do
	FLE=${DIR[0]}
	SUB=`ls -d ${FLE}*/`
	DIR=(${DIR[@]:1})
	for file in $SUB;
	do
		if [ -d "${file}.repo/" ]; then
			REP=("${REP[@]}" "$file")
		elif [ -f "${file}config" ]; then
			tmp=${file%?}
			GIT=("${GIT[@]}" "$tmp")
		else
			DIR=("${DIR[@]}" "$file")
		fi
	done
	CT=${#DIR[@]}
done

function tkboy_sync()
{
    valid=0
    if [ "$#" = 0 ]; then
        valid=1
    elif [ "$#" = 1 ]; then
        if [ "$1" = "all" ]; then
            _tkboy_sync_all_git
            _tkboy_sync_all_repo
        elif [ "$1" = "git" ]; then
            _tkboy_sync_all_git
        elif [ "$1" = "repo" ]; then
            _tkboy_sync_all_git
        elif [ "$1" = "ls" ]; then
            _tkboy_sync_ls_all_git
            _tkboy_sync_ls_all_repo
        else
            valid=1
        fi
    elif [ "$#" = 2 ]; then
        if [ "$1" = "ls" ]; then
            if [ "$2" = "g" ]; then
                _tkboy_sync_ls_all_git
            elif [ "$2" = "r" ]; then
                _tkboy_sync_ls_all_repo
            elif [ "$2" = "vg" -o "$2" = "gv" ]; then
                _tkboy_sync_ls_all_git_v
            elif [ "$2" = "vr" -o "$2" = "rv" ]; then
                _tkboy_sync_ls_all_repo_v
            elif [ "$2" = "v" -o "$2" = "vrg" -o "$2" = "rgv" -o "$2" = "rvg" -o "$2" = "gvr" -o "$2" = "grv" -o "$2" = "grv" ]; then
                _tkboy_sync_ls_all_git_v
                _tkboy_sync_ls_all_repo_v
            elif [ "$2" = "gr" -o "$2" = "rg" ]; then
                _tkboy_sync_ls_all_git
                _tkboy_sync_ls_all_repo
            else
                valid=1
            fi
        elif [ "$1" = "git" ]; then
            _tkboy_sync_git $2
        elif [ "$1" = "repo" ]; then
            _tkboy_sync_git $2
        else
            valid=1
        fi
    else
        valid=1
    fi

    #echo "param count: $#"
    #echo "param 0: $0"
    #echo "param 1: $1"
    #echo "param 2: $2"
    #echo "param 3: $3"

    if [ $valid -eq 1 ]; then
        echo "Usage: "
        echo "    tkboy_sync all"
        echo "    tkboy_sync git  [URL]"
        echo "    tkboy_sync repo [URL]"
        echo "    tkboy_sync ls   [g|r|v]"
        echo ""
    fi
}

function _tkboy_sync_git()
{
    valid=0
    if [ -f "${@}config" ]; then
        valid=1
    elif [ -f "${@}/config" ]; then
        valid=1
    fi

    if [ $valid = 1 ]; then
        echo -ne "\E[32;49m\033[1m"
        echo -e "GIT fetch: $@"
        echo -ne "\033[0m"
        echo -ne "\E[36;49m\033[2m"
        git --git-dir=$@ remote -v
        echo -ne "\033[0m"
        git --git-dir=$@ fetch
        echo
    else
        echo -ne "\E[31;49m\033[2m"
        echo -e "error: No git URL: $@"
        echo -ne "\033[0m"
    fi
}

function _tkboy_sync_repo()
{
    valid=0
    if [ -d "${@}.repo/" ]; then
        valid=1
    elif [ -d "${@}/.repo/" ]; then
        valid=1
    fi

    if [ $valid = 1 ]; then
        echo -ne "\E[32;49m\033[1m"
        echo -e "REPO sync: $@"
        echo -ne "\033[0m"
        cd $@
        repo sync
        cd -
        echo
    else
        echo -ne "\E[31;49m\033[2m"
        echo -e "error: No repo URL: $@"
        echo -ne "\033[0m"
    fi
}

function _tkboy_sync_all_git()
{
    for git in ${GIT[@]};
    do
        _tkboy_sync_git $git
    done
}

function _tkboy_sync_all_repo()
{
    for rep in ${REP[@]};
    do
        _tkboy_sync_repo $rep
    done
}

function _tkboy_sync_ls_all_git()
{
    for git in ${GIT[@]};
    do
        echo -ne "\E[32;49m\033[1m"
        echo -e "GIT: $git"
        echo -ne "\033[0m"
    done
}

function _tkboy_sync_ls_all_repo()
{
    for rep in ${REP[@]};
    do
        echo -ne "\E[32;49m\033[1m"
        echo -e "REPO: $rep"
        echo -ne "\033[0m"
    done
}

function _tkboy_sync_ls_all_git_v()
{
    for git in ${GIT[@]};
    do
        echo -ne "\E[32;49m\033[1m"
        echo -e "GIT: $git"
        echo -ne "\033[0m"
        git --git-dir=$git remote -v
    done
}

function _tkboy_sync_ls_all_repo_v()
{
    for rep in ${REP[@]};
    do
        echo -ne "\E[32;49m\033[1m"
        echo -e "REPO: $rep"
        echo -ne "\033[0m"
    done
}

function _tkboy_sync()
{
    local cur prev opts 
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #echo
    #echo "COMP_CWORD = $COMP_CWORD"
    #echo "COMP_WORDS = ${COMP_WORDS[@]}"
    #echo "cur        = $cur"
    #echo "prev       = $prev"
    
    
    if [ $COMP_CWORD = 1 ]; then
        SYNC_MENU_CHOICES=( "ls" "all" "git" "repo" )
        COMPREPLY=( $(compgen -W "${SYNC_MENU_CHOICES[*]}" -- ${cur}) )
    elif [ $COMP_CWORD = 2 ]; then
        if [ $prev = "ls" ]; then
            SYNC_MENU_CHOICES=( "g" "v" "r" "gv" "vg" "rv" "vr" "gr" "vgr" "gvr" "grv" "rg" "vrg" "rvg" "rgv"  )
            COMPREPLY=( $(compgen -W "${SYNC_MENU_CHOICES[*]}" -- ${cur}) )
        elif [ $prev = "git" ]; then
            COMPREPLY=( $(compgen -W "${GIT[*]}" -- ${cur}) )
        elif [ $prev = "repo" ]; then
            COMPREPLY=( $(compgen -W "${REP[*]}" -- ${cur}) )
        else
            COMPREPLY=()
        fi
    else
        COMPREPLY=()
    fi
    return 0
}

complete -F _tkboy_sync "tkboy_sync"





