#! /bin/bash

VERSION=$1
APP_NAME=icecream
VERSION_LABEL=$APP_NAME-$VERSION
DOCKERRUN_FILE=$VERSION_LABEL-Dockerrun.aws.json
EB_BUCKET=nick-docker-test
EB_KEY=$APP_NAME/$DOCKERRUN_FILE

# transform template
sed "s/<TAG>/$VERSION/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE

# copy transformed file to s3
aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$EB_KEY

# create application version
aws elasticbeanstalk create-application-version --application-name nick-docker-test --version-label $VERSION_LABEL --source-bundle S3Bucket=$EB_BUCKET,S3Key=$EB_KEY

# deploy new version
aws elasticbeanstalk update-environment --environment-name ndt-env-3 --version-label $VERSION_LABEL