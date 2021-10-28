output "k8s-masters" {
  value = [
    for key, item in aws_instance.k8s_masters :
      "k8s-master${key+1} - ${item.private_ip} - ${item.public_dns} "
  ]
}

output "output-k8s_workers" {
  value = [
    for key, item in aws_instance.k8s_workers :
    "k8s-workers${key+1} - ${item.private_ip} - ${item.public_dns} "
  ]
}

output "output-k8s_proxy" {
  value = [
    for key, item in aws_instance.k8s_proxy :
    "k8s-proxy - ${item.private_ip} - ${item.public_dns} "
  ]
}

