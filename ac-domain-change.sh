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
SOURCE=$1
DESTINATION=$2

# for each environment in source
for env in dev test prod; do
	echo "Starting on move of hostnames from $SOURCE.$env to $DESTINATION.$env";
	#  list hostnames in source
	echo "Starting on $SOURCE.$env hostnames";
	HOSTS=$(drush $SOURCE.$env ac-domain-list)
  #   for each hostname in source env
  while read -r host; do
  	hostname=${host:10}; # removes " name   :"
  	if [[ $hostname != *"acquia-sites.com"* ]]; then
  		# remove hostname from source
  		echo "Removing $hostname from $SOURCE.$env";
  		#drush $SOURCE.$env ac-domain-delete $hostname; 

  		# add hostname to destination
  		echo "Adding $hostname to $DESTINATION.$env";
  		#drush $SOURCE.$env ac-domain-add $hostname; 
	  fi
  done <<< "$HOSTS"
  NEWHOSTS=$(drush $DESTINATION.$env ac-domain-list)
  echo "Finished moving hostnames from $SOURCE.$env to $DESTINATION.$env";
  echo "Hostnames: "
  #   for each hostname in destination env
  while read -r host; do
  	hostname=${host:10}; # removes " name   :"
  	if [[ $hostname != *"acquia-sites.com"* ]]; then
  		echo "\t$hostname";
	  fi
  done <<< "$NEWHOSTS"
  echo "\n";
done
echo "done."