#!/bin/bash
if [ -f ./LATEST_AMI_ID.txt ] ;then
    echo "Backing up latest AMI file..."
    mv LATEST_AMI_ID.txt LATEST_AMI_ID.txt.back
fi

echo "Validating and building Packer image. This may take a few minutes..."
packer validate config.json
val_and_build_out=$(packer build config.json | tee /dev/tty)

echo -n "Did the Packer image build successfully? [N|y]"
read success_response

if [ $success_response != "{$success_response#[Yy]}" ] ;then

    if [ -f ./LATEST_AMI_ID.txt.back ] ;then
        echo -n "Would you like to delete the previous AMI and snapshot? [N|y]"
        read delete_response

        if [ $delete_response != "{$delete_response#[Yy]}" ] ;then
            snapshot_id=$(aws ec2 describe-images --image-ids `cat LATEST_AMI_ID.txt.back` | jq '.Images[0].BlockDeviceMappings[0].Ebs.SnapshotId' | tr -d '"')
            echo $snapshot_id
            aws ec2 deregister-image --image-id `cat LATEST_AMI_ID.txt.back`
            aws ec2 delete-snapshot --snapshot-id $snapshot_id
            echo "AMI and snapshot deleted"
        rm LATEST_AMI_ID.txt.back
        echo "Backup removed"
        fi

    fi

    echo $val_and_build_out | awk -F ": " '{print $(NF)}' > LATEST_AMI_ID.txt

else

    if [ -f ./LATEST_AMI_ID.txt.back ] ;then
        mv LATEST_AMI_ID.txt.back LATEST_AMI_ID.txt
        echo "Backup replaced"
    fi

fi