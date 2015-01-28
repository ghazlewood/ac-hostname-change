#!/bin/bash
#
# Move domains between Acquia Cloud subscriptions with Drush
# 
#
# Requires: drush, ac-api creds and site aliases
#  - you must be a team member on both subs
#  - you must have permission in both teams to use cloudapi

# To Do
# list environments for source?
# list environments for destination?
#  
# Arguments 
#  - 1st argument source site group
#  - 2nd argument destination site group
#
# ./ac-domain-change.sh @source @destination

SOURCE=$1
DESTINATION=$2

# for each environment in source
for env in dev test prod; do
	echo "Starting on move of hostnames from $SOURCE.$env to $DESTINATION.$env";
	#  list hostnames in source
	HOSTS=$(drush $SOURCE.$env ac-domain-list)
  #   for each hostname in source env
  while read -r host; do
  	hostname=${host:10}; # removes " name   :"
  	if [[ $hostname != *"acquia-sites.com"* && $hostname != *"elb.amazonaws.com"* ]]; then
  		# remove hostname from source
  		echo -e "\tRemoving $hostname from $SOURCE.$env";
  		remtaskid=$(drush $SOURCE.$env ac-domain-delete $hostname); 
  		echo $remtaskid
  		# add hostname to destination
  		echo -e "\tAdding $hostname to $DESTINATION.$env";
  		addtaskid=$(drush $DESTINATION.$env ac-domain-add $hostname);
  		echo $addtaskid; 
	  fi
  done <<< "$HOSTS"
  # list hostnames now on destination
  NEWHOSTS=$(drush $DESTINATION.$env ac-domain-list)
  echo "Finished moving hostnames from $SOURCE.$env to $DESTINATION.$env";
  echo -e "\tHostnames: "
  #   for each hostname in destination env
  while read -r host; do
  	hostname=${host:10}; # removes " name   :"
  	if [[ $hostname != *"acquia-sites.com"* && $hostname != *"elb.amazonaws.com"* ]]; then
  		echo -e "\t$hostname";
	  fi
  done <<< "$NEWHOSTS"
  echo -e "\n";
done
echo "Done."