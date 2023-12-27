locals {
  studio_enabled   = var.studio == null || var.studio == {} ? false : true
  notebook_enabled = var.notebook_instances == null || var.notebook_instances == [] ? false : true
}
