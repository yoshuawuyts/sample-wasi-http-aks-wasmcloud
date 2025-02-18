helm upgrade --install \
    wasmcloud-platform \
    --values wasmCloudValues.yml \
    oci://ghcr.io/wasmcloud/charts/wasmcloud-platform \
    --dependency-update

kubectl wait --for=condition=available --timeout=600s deploy -l app.kubernetes.io/name=wasmcloud-operator

helm upgrade --install \
    wasmcloud-platform \
    --values wasmCloudValues.yml \
    oci://ghcr.io/wasmcloud/charts/wasmcloud-platform \
    --dependency-update \
    --set "hostConfig.enabled=true"
