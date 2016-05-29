#! /bin/bash

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION

export VERSION=$1
export APP_NAME=$APP_NAME
export VERSION_LABEL=$APP_NAME-$VERSION
export DOCKERRUN_FILE=$VERSION_LABEL-Dockerrun.aws.json
export DOCKERRUN_AWS_BUCKET=elasticbeanstalk-docker-deploys-2
export DOCKERRUN_AWS_KEY=$APP_NAME/$DOCKERRUN_FILE


printenv


# transform aws docker run template
sed -e "s/<APP_NAME>/$APP_NAME/" -e "s/<VERSION>/$VERSION/" -e "s/<EXPOSED_PORT>/$EXPOSED_PORT/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE

# copy transformed aws docker run file to s3
cmd1 = "aws s3 cp $DOCKERRUN_FILE s3://$DOCKERRUN_AWS_BUCKET/$DOCKERRUN_AWS_KEY"
$cmd1 #aws s3 cp $DOCKERRUN_FILE s3://$DOCKERRUN_AWS_BUCKET/$DOCKERRUN_AWS_KEY

# create eb application version
aws elasticbeanstalk create-application-version --application-name nick-docker-test --version-label $VERSION_LABEL --source-bundle S3Bucket=$DOCKERRUN_AWS_BUCKET,S3Key=$DOCKERRUN_AWS_KEY

# deploy new version
aws elasticbeanstalk update-environment --environment-name ndt2-env-3 --version-label $VERSION_LABEL
