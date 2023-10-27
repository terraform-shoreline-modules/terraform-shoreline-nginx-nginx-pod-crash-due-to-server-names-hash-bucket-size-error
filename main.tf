terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "nginx_pod_crash_due_to_server_names_hash_bucket_size_error" {
  source    = "./modules/nginx_pod_crash_due_to_server_names_hash_bucket_size_error"

  providers = {
    shoreline = shoreline
  }
}