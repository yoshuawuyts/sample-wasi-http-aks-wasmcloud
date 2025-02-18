# sample-wasi-http-aks-wasmcloud

Run a `wasi:http' app on AKS + WasmCloud.

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

## See Also

**Guests**

- [sample-wasi-http-rust](https://github.com/yoshuawuyts/sample-wasi-http-rust) - A `wasi:http` example program written in Rust

## License

Apache-2.0 with LLVM Exception
