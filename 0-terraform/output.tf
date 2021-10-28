output "k8s-masters" {
  value = module.moduleK8s.k8s-masters
}

output "k8s-workers" {
  value = module.moduleK8s.output-k8s_workers
}

output "k8s-proxy" {
  value = module.moduleK8s.output-k8s_proxy
}
