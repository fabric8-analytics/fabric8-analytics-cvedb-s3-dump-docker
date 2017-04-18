#!/bin/bash -ex

bucket=${DEPLOYMENT_PREFIX}-bayesian-core-owasp-dep-check
cvedb=/tmp/cvedb/dc.h2.db.zip

endpoint_arg="${S3_ENDPOINT_URL:+--endpoint-url ${S3_ENDPOINT_URL}}"

aws ${endpoint_arg} s3 ls | grep ${bucket} || aws ${endpoint_arg} --region us-east-1 s3 mb s3://${bucket}
aws ${endpoint_arg} s3 cp ${cvedb} s3://${bucket}

