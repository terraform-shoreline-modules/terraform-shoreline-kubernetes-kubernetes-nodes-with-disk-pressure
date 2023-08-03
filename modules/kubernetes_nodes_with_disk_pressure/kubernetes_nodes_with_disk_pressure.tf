resource "shoreline_notebook" "kubernetes_nodes_with_disk_pressure" {
  name       = "kubernetes_nodes_with_disk_pressure"
  data       = file("${path.module}/data/kubernetes_nodes_with_disk_pressure.json")
  depends_on = []
}

