#! /bin/bash
sz() {
	remaining=$(($1 - $sz))
	remainingabs=$remaining
	[ "$remaining" -lt 0 ] && remainingabs=$(($remaining * -1))
	if [ "$remainingabs" -gt $((1024**3)) ]; then
		free=$(echo "$remaining/1024/1024/1024" | bc -l)
		mult=G
	elif [ "$remainingabs" -gt $((1024**2)) ]; then
		free=$(echo "$remaining/1024/1024" | bc -l)
		mult=M
	elif [ "$remainingabs" -gt 1024 ]; then
		free=$(echo "$remaining/1024" | bc -l)
		mult=K
	else
		free=$remaining
		mult=b
	fi
	pct="$(echo "$sz/$1*100" | bc -l)"
	if [ "$sz" -le "$1" ]; then
		intval=$(echo "$pct" | cut -d. -f1)
		[ -z "$intval" ] && intval=0
		if [ "$intval" -ge 99 ]; then
			printf "\e[33mOK"
		else
			printf "\e[32mOK"
		fi
	else
		printf "\e[31mko"
	fi
	printf "(%.1f%%,%.1f%s)\e[0m" "$pct" "$free" "$mult"
}


while [ -n "$1" ]
do
    if [ -f "$1" ]; then
	    sz=$(stat -c %s "$1")
    else
        sz=$(du -scb "$1" | awk '/total/ {print $1}')
    fi
	printf "%s: CD:%s DVD+R:%s DVD-R:%s DVD+R-DL:%s BD-R:%s BD-DL:%s BD-TL:%s BD-QL:%s\n" \
		"$1" $(sz 737280000) $(sz 4700372992) $(sz 4707319808) $(sz 8547993600) \
		$(sz $((11826176*2048))) $(sz 50050629632) $(sz 96882130944) $(sz 128001769472)
	shift
done
