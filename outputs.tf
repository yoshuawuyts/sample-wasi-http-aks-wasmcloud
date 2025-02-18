output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "azure_kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
