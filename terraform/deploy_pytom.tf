resource "null_resource" "execute_python_script" {
  # This resource doesn't do anything by itself, but it's used to trigger the local-exec provisioner

  # You can use triggers to force the local-exec provisioner to run when specific inputs change
  triggers = {
    script_trigger = timestamp()
  }

  provisioner "local-exec" {
    command = "python3 ./script.py"
  }
  depends_on = [aws_route53_zone.arcstone_zone,null_resource.apply_manifest, module.eks]
}
