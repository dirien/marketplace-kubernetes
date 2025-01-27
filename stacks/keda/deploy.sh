#!/bin/sh

set -e

################################################################################
# repo
################################################################################
helm repo add kedacore https://kedacore.github.io/charts
helm repo update > /dev/null

################################################################################
# chart
################################################################################
STACK="keda"
CHART="kedacore/keda"
CHART_VERSION="2.3.2"
NAMESPACE="keda"

if [ -z "${MP_KUBERNETES}" ]; then
  # use local version of values.yml
  ROOT_DIR=$(git rev-parse --show-toplevel)
  values="$ROOT_DIR/stacks/keda/values.yml"
else
  # use github hosted master version of values.yml
  values="https://raw.githubusercontent.com/digitalocean/marketplace-kubernetes/master/stacks/keda/values.yml"
fi

helm upgrade "$STACK" "$CHART" \
  --atomic \
  --create-namespace \
  --install \
  --namespace "$NAMESPACE" \
  --values "$values" \
  --version "$CHART_VERSION"
