#!/bin/bash
gcloud auth revoke --all

while [[ -z "$(gcloud config get-value core/account)" ]]; 
do echo "waiting login" && sleep 2; 
done

while [[ -z "$(gcloud config get-value project)" ]]; 
do echo "waiting project" && sleep 2; 
done

export PROJECT_ID=$(gcloud info --format='value(config.project)')
gsutil mb gs://$PROJECT_ID

# touch sample.txt
gsutil cp sample.txt gs://$PROJECT_ID


export LASTUSER=$(gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format='table(bindings.members)' --filter="bindings.members:user:student*" |& tail -1)


gcloud projects remove-iam-policy-binding $PROJECT_ID --member="$LASTUSER" --role='roles/viewer'

gcloud projects add-iam-policy-binding $PROJECT_ID --member="$LASTUSER" --role='roles/storage.objectViewer'