resource "oci_core_boot_volume" "core_boot_volumes" {
  for_each = var.core_boot_volumes

  availability_domain           = each.value.availability_domain
  compartment_id                = each.value.compartment_id
  backup_policy_id              = each.value.backup_policy_id
  boot_volume_replicas_deletion = each.value.boot_volume_replicas_deletion
  cluster_placement_group_id    = each.value.cluster_placement_group_id
  defined_tags                  = each.value.defined_tags
  display_name                  = each.value.display_name
  freeform_tags                 = each.value.freeform_tags
  is_auto_tune_enabled          = each.value.is_auto_tune_enabled
  kms_key_id                    = each.value.kms_key_id
  size_in_gbs                   = each.value.size_in_gbs
  vpus_per_gb                   = each.value.vpus_per_gb
  xrc_kms_key_id                = each.value.xrc_kms_key_id

  source_details {
    change_block_size_in_bytes = each.value.source_details.change_block_size_in_bytes
    first_backup_id            = each.value.source_details.first_backup_id
    id                         = each.value.source_details.id
    second_backup_id           = each.value.source_details.second_backup_id
    type                       = each.value.source_details.type
  }

  dynamic "autotune_policies" {
    for_each = each.value.autotune_policies != null ? each.value.autotune_policies : []
    content {
      autotune_type   = autotune_policies.value.autotune_type
      max_vpus_per_gb = autotune_policies.value.max_vpus_per_gb
    }
  }

  dynamic "boot_volume_replicas" {
    for_each = each.value.boot_volume_replicas != null ? each.value.boot_volume_replicas : []
    content {
      availability_domain = boot_volume_replicas.value.availability_domain
      display_name        = boot_volume_replicas.value.display_name
      xrr_kms_key_id      = boot_volume_replicas.value.xrr_kms_key_id
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

