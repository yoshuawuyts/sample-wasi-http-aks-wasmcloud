# sample-wasi-http-aks-wasmcloud

Run a `wasi:http` app on AKS + WasmCloud.

## 🚀 Deploy the Infrastructure

1. Login to Azure: `az login`
2. Set subscription ID: `export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)`
3. Run Terraform: `terraform init && terraform apply -auto-approve`

## ☁️ Deploy WasmCloud

1. Connect to the AKS cluster:

   ```
   export RG_NAME="$(terraform output -raw resource_group_name)"
   export AKS_NAME="$(terraform output -raw azure_kubernetes_cluster_name)"
   az aks get-credentials --resource-group $RG_NAME --name $AKS_NAME --overwrite-existing
   ```

2. Setup WasmCloud:
   ```sh
   ./setupWasmCloud.sh
   ```

**More**: [Deploying wasmCloud on Kubernetes](https://wasmcloud.com/docs/deployment/k8s/)

## Deploy the wasm component

1. Apply the manifest:
   ```sh
   kubectl apply -f app.yml
   ```
2. Port forward:
   <!--TODO: replace with ingress-->
   ```sh
   WASMCLOUD_HOST_POD=$(kubectl get pods -o jsonpath="{.items[*].metadata.name}" -l app.kubernetes.io/instance=wasmcloud-host)
   kubectl port-forward pods/$WASMCLOUD_HOST_POD 8080
   ```
3. Test endpoints:
   ```sh
   curl http://localhost:8080
   curl http://localhost:8080/echo -d 'Hello, from WasmCloud!'
   ```

## (Optional) Configure wasm component verification

This section deploys Gatekeeper and Ratify to your Kubernetes cluster for digital signature verifaction of the wasm component which prevents unsigned deployments from running on your clusters.


```sh
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm install gatekeeper/gatekeeper  \
--name-template=gatekeeper \
--namespace gatekeeper-system --create-namespace \
--set enableExternalData=true \
--set validatingWebhookTimeoutSeconds=5 \
--set mutatingWebhookTimeoutSeconds=2 \
--set externaldataProviderResponseCacheTTL=10s


helm repo add ratify https://ratify-project.github.io/ratify
helm install ratify ratify/ratify \
    --atomic \
    --namespace gatekeeper-system \
    --set cosign.enabled=true \
    --set featureFlags.RATIFY_CERT_ROTATION=true

kubectl apply -f https://ratify-project.github.io/ratify/library/default/template.yaml
kubectl apply -f https://ratify-project.github.io/ratify/library/default/samples/constraint.yaml

kubectl apply -f cosign-verifier.yml
```

## See Also

**Wasm Guests app repo**
- [sample-wasi-http-rust](https://github.com/bytecodealliance/sample-wasi-http-rust) - A `wasi:http` example program written in Rust

## License

Apache-2.0 with LLVM Exception
