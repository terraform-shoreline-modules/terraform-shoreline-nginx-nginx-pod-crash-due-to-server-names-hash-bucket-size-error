resource "shoreline_notebook" "nginx_pod_crash_due_to_server_names_hash_bucket_size_error" {
  name       = "nginx_pod_crash_due_to_server_names_hash_bucket_size_error"
  data       = file("${path.module}/data/nginx_pod_crash_due_to_server_names_hash_bucket_size_error.json")
  depends_on = [shoreline_action.invoke_update_nginx_config]
}

resource "shoreline_file" "update_nginx_config" {
  name             = "update_nginx_config"
  input_file       = "${path.module}/data/update_nginx_config.sh"
  md5              = filemd5("${path.module}/data/update_nginx_config.sh")
  description      = "Increase the server_names_hash_bucket_size in the nginx configuration. This can be done by modifying the nginx.conf file or the configuration file for the specific pod that is crashing."
  destination_path = "/tmp/update_nginx_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_nginx_config" {
  name        = "invoke_update_nginx_config"
  description = "Increase the server_names_hash_bucket_size in the nginx configuration. This can be done by modifying the nginx.conf file or the configuration file for the specific pod that is crashing."
  command     = "`chmod +x /tmp/update_nginx_config.sh && /tmp/update_nginx_config.sh`"
  params      = ["CONFIGMAP_NAME","NAMESPACE","CONFIG_FILE","BUCKET_SIZE"]
  file_deps   = ["update_nginx_config"]
  enabled     = true
  depends_on  = [shoreline_file.update_nginx_config]
}

