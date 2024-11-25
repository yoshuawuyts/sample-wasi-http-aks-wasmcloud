# sample-wasi-http-aks-wasmcloud

A sample running a `wasi:http` application on AKS + WasmCloud

## Deploy Azure infrastructure with Terraform

1. Login to Azure: `az login`
2. Set subscription ID: `export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)`
3. Run Terraform: `terraform init && terraform apply -auto-approve`

## Deploy wasmCloud platform

1. Connect to the AKS cluster: `az aks get-credentials --resource-group <resource-group> --name <cluster-name>`
2. Run the following commands:
```sh
helm upgrade --install \ wasmcloud-platform \
    --values https://raw.githubusercontent.com/wasmCloud/wasmcloud/main/charts/wasmcloud-platform/values.yaml \
    oci://ghcr.io/wasmcloud/charts/wasmcloud-platform \
    --dependency-update
```
```sh
kubectl rollout status deploy,sts -l app.kubernetes.io/name=nats
kubectl wait --for=condition=available --timeout=600s deploy -l app.kubernetes.io/name=wadm
kubectl wait --for=condition=available --timeout=600s deploy -l app.kubernetes.io/name=wasmcloud-operator
```
```sh
helm upgrade --install \
    wasmcloud-platform \
    --values https://raw.githubusercontent.com/wasmCloud/wasmcloud/main/charts/wasmcloud-platform/values.yaml \
    oci://ghcr.io/wasmcloud/charts/wasmcloud-platform \
    --dependency-update \
    --set "hostConfig.enabled=true"
```

source: [Deploying wasmCloud on Kubernetes](https://wasmcloud.com/docs/deployment/k8s/)

## Deploy the `http-hello-world-rust:0.1.0' wasm component

1. Run the following commands:
```sh
kubectl apply -f https://raw.githubusercontent.com/wasmCloud/wasmcloud-operator/main/examples/quickstart/hello-world-application.yaml
```

## See Also

**Guests**
- [sample-wasi-http-rust](https://github.com/yoshuawuyts/sample-wasi-http-rust) - A `wasi:http` example program written in Rust

## License

Apache-2.0 with LLVM Exception
