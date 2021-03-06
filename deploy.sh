#! /bin/bash

export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export AWS_DEFAULT_REGION=eu-west-1

APP_NAME=$3
VERSION=$4
EXPOSED_PORT=$5

VERSION_LABEL=$APP_NAME-$VERSION
DOCKERRUN_FILE=$VERSION_LABEL-Dockerrun.aws.json
DOCKERRUN_AWS_BUCKET=elasticbeanstalk-docker-deploys
DOCKERRUN_AWS_KEY=$APP_NAME/$DOCKERRUN_FILE

# transform aws docker run template
sed -e "s/<APP_NAME>/$APP_NAME/" -e "s/<VERSION>/$VERSION/" -e "s/<EXPOSED_PORT>/$EXPOSED_PORT/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE

# copy transformed aws docker run file to s3
aws s3 cp $DOCKERRUN_FILE s3://$DOCKERRUN_AWS_BUCKET/$DOCKERRUN_AWS_KEY

# create eb application version
aws elasticbeanstalk create-application-version --application-name nick-docker-test --version-label $VERSION_LABEL --source-bundle S3Bucket=$DOCKERRUN_AWS_BUCKET,S3Key=$DOCKERRUN_AWS_KEY

# deploy new version
aws elasticbeanstalk update-environment --environment-name ndt-env-3 --version-label $VERSION_LABEL
