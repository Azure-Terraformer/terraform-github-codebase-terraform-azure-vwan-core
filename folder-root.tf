locals {
  root_folder_files = [
    "main.tf",
    "dns.tf",
    "dns-resolver.tf",
    "dns-zones.tf",
    "network.tf",
    "variables.tf",
    "versions.tf"
  ]
}

resource "github_repository_file" "root_folder" {

  count = length(local.root_folder_files)

  repository          = var.repository
  branch              = var.branch
  file                = "${var.path}/${local.root_folder_files[count.index]}"
  content             = file("${path.module}/files/${local.root_folder_files[count.index]}.t4")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true

}

resource "github_repository_file" "terraform_tfvars" {

  repository = var.repository
  branch     = var.branch
  file       = "${var.path}/terraform.tfvars"
  content = templatefile("${path.module}/files/terraform.tfvars.t4",
    {
      primary_location   = var.primary_location
      base_address_space = var.base_address_space
      vpn_address_space  = var.vpn_address_space
      dns_address_space  = var.dns_address_space
    }
  )
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true

}
