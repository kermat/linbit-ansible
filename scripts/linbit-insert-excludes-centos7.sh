#!/bin/bash
### Check for Pacemaker/Corosync related excludes in CentOS-Base,
### add them if missing and skip if they're correct

### vars
repofile=/etc/yum.repos.d/CentOS-Base.repo
excludes="pacemaker* corosync* drbd* cluster-glue* resource-agents* libqb* fence-agents* sbd*"
repos=(base updates)
# we need a version of $excludes that has * escaped
r_excludes=$(echo $excludes | sed -r 's/([a-Z0-9])\*/\1\\\*/g')
# set to on or off
debug=off

### debug
if [ $debug == "on" ]; then
    echo "$repofile"
    echo "$excludes"
    echo "$r_excludes"
    for repo in ${repos[*]}; do
        printf "%s\n" $repo
    done
fi

### check for existing repo file
if [ ! -f $repofile ]; then
 if [ $debug == "on" ]; then echo "$repofile is not a regular file"; fi
 exit 1
fi

### check for excludes, and add them if needed
### TODO: it would be better if this iterated through the excludes
###       and checked for each individually (an array of excludes) 
for repo in ${repos[*]}; do
    if $(sed -n "/\[$repo\]/,/\(\[\|^$\)/p" $repofile | grep -q "^exclude="); then
	if [ $debug == "on" ]; then echo "exclude line already exists for [$repo]..."; fi
        if $(sed -n "/\[$repo\]/,/\(\[\|^$\)/p" $repofile | grep -q "^exclude=$r_excludes"); then
            if [ $debug == "on" ]; then echo "and they're correct!"; fi
	else
	    if [ $debug == "on" ]; then echo "and they're incorrect for us :("; fi
	    exit 1
        fi
    else 
	sed -i.bak "s/\[$repo\]/\[$repo\]\nexclude=$excludes/1" $repofile
	if [ $debug == "on" ]; then echo "added appropriate excludes to $repofile"; fi
    fi
done

exit 0
