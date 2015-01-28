# ac-hostname-change
Acquia Cloud Hostname Mover

Move domains between Acquia Cloud subscriptions with Drush

Requires: 
 - drush
 - ac-api credentials (https://docs.acquia.com/cloud/drush) 
 - drush site aliases installed locally (drush acquia-update is your friend)
 - you must be a team member on both subs
 - you must have permission in both teams to use cloudapi

To Do
list environments for source?
list environments for destination?
 
Arguments 
 - 1st argument source site group
 - 2nd argument destination site group

./ac-domain-change.sh @source @destination
