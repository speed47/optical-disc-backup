#! /bin/sh
mb=$(du -smc "$@" | awk '/total/ { print $1 }')

do_it() {
	onedisc=$1
	echo ">>> Optical disc size is $onedisc MiB"

	current=$((mb / onedisc))
	[ "$current" = 0 ] && current=1
	while :
	do
	    sparespace=$(( (current * onedisc) - mb ))
	    spareperdisc=$((sparespace / current))
	    sparepercent=$((spareperdisc * 100 / onedisc))
	    red=$((spareperdisc * 100 / (onedisc - spareperdisc)))
	    usedondisc=$((onedisc - spareperdisc))
	    echo "Putting $mb MiB total data on $current discs with $sparespace MiB total spare (per disc: $usedondisc MiB used, $spareperdisc MiB spare, $sparepercent% space for parity), $red% redundancy"
	    [ "$sparepercent" -ge 10 ] && break
	    current=$((current+1))
	done
	echo
}

do_it 4480
do_it $((11826144*2048/1024/1024))
do_it $((12219392*2048/1024/1024))
