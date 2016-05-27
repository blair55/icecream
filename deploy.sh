#! /bin/bash

VERSION=$1
APP_NAME=icecream
VERSION_LABEL=$APP_NAME-$VERSION
DOCKERRUN_FILE=$VERSION_LABEL-Dockerrun.aws.json
AWS_REGION=eu-west-1
AWS_BUCKET=nick-docker-test
AWS_KEY=$APP_NAME/$DOCKERRUN_FILE

# transform template
sed "s/<TAG>/$VERSION/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE

# copy transformed file to s3
aws --region $AWS_REGION s3 cp $DOCKERRUN_FILE s3://$AWS_BUCKET/$AWS_KEY

# create application version
aws --region $AWS_REGION elasticbeanstalk create-application-version --application-name nick-docker-test --version-label $VERSION_LABEL --source-bundle S3Bucket=$AWS_BUCKET,S3Key=$AWS_KEY

# deploy new version
aws --region $AWS_REGION elasticbeanstalk update-environment --environment-name ndt-env-3 --version-label $VERSION_LABEL
