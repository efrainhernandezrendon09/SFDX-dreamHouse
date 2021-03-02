#!/bin/bash -x

if [[ $# -eq 0 ]] ; then
 echo ‘you need to pass in a string name for your scratch org’
 exit 1
fi

echo "* Creating new scratch org..."
sfdx force:org:create -a $1 -s -f config/project-scratch-def.json -d 1

echo "* Pushing ARCE project to scratch org..."
sfdx force:source:push -f -u $1

echo "* Assigning permission set to the user..."
sfdx force:user:permset:assign --permsetname dreamhouse -u $1

echo "* Uploading Contacts -> Creating contacts..."
sfdx force:data:bulk:upsert -s Contact -f ./data/contacts.csv -i Id -w 5 -u $1

echo "* Uploading Brokers -> Creating brokers..."
sfdx force:data:bulk:upsert -s Broker__c -f ./data/brokers.csv -i Id -w 5 -u $1

echo "* Uploading Properties -> Creating properties..."
sfdx force:data:bulk:upsert -s Property__c -f ./data/properties.csv -i Id -w 5 -u $1