#!/bin/bash


#################################################
#
#Author: Mohd Afsar Hussain
#
#Date: 16 january 2026
#
#Details: listing all aws resources in a txt file called resources
#
##################################################


ENDPOINT="--endpoint-url=http://localhost:4566"
OUTPUT_FILE="$HOME/aws-resource-usage.csv"

echo "Service,Resource_ID,Status,Details" > "$OUTPUT_FILE"
echo "Tracking resources to $OUTPUT_FILE..."

# listing s3 and copy to csv file

aws $ENDPOINT s3 ls | \
while read -r date time name; do
	echo "S3,$name,Connected,Created on: $date $time" >> "$OUTPUT_FILE"
done

# # listing ec2 instances and copy to csv file

aws $ENDPOINT ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' \
    --output text | \
while read -r id state; do
    echo "EC2,$id,$state,Instance" >> "$OUTPUT_FILE"
done



# listing iam users and copy to csv file




aws $ENDPOINT iam list-users \
    --query 'Users[*].[UserName, CreateDate]' \
    --output text | \
while read -r user date; do
    echo "IAM,$user,Active,Created: $date" >> "$OUTPUT_FILE"
done

echo "Done! Report generated."


