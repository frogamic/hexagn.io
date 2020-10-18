#! /usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

DOMAIN_NAME="hexagn.io"
STACK="hexagn-io"
REGION="us-east-1"

HOSTED_ZONE_ID="$(aws route53 list-hosted-zones-by-name --dns-name "$DOMAIN_NAME" --query 'HostedZones[0].Id' --output text)"
HOSTED_ZONE_ID="${HOSTED_ZONE_ID##*/}"

echo "Deploying CloudFront stack for ${DOMAIN_NAME}"
aws cloudformation deploy \
	--region "$REGION" \
	--stack-name "$STACK" \
	--template-file static-site.yml \
	--parameter-overrides  \
		"HostedZoneId=${HOSTED_ZONE_ID}" \
		"DomainName=${DOMAIN_NAME}"
