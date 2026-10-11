variable "core_boot_volumes" {
  description = <<EOT
Map of core_boot_volumes, attributes below
Required:
    - availability_domain
    - compartment_id
    - source_details (block):
        - change_block_size_in_bytes (optional)
        - first_backup_id (optional)
        - id (optional)
        - second_backup_id (optional)
        - type (required)
Optional:
    - backup_policy_id
    - boot_volume_replicas_deletion
    - cluster_placement_group_id
    - defined_tags
    - display_name
    - freeform_tags
    - is_auto_tune_enabled
    - kms_key_id
    - size_in_gbs
    - vpus_per_gb
    - xrc_kms_key_id
    - autotune_policies (block):
        - autotune_type (required)
        - max_vpus_per_gb (optional)
    - boot_volume_replicas (block):
        - availability_domain (required)
        - display_name (optional)
        - xrr_kms_key_id (optional)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    availability_domain           = string
    compartment_id                = string
    backup_policy_id              = optional(string)
    boot_volume_replicas_deletion = optional(bool)
    cluster_placement_group_id    = optional(string)
    defined_tags                  = optional(map(string))
    display_name                  = optional(string)
    freeform_tags                 = optional(map(string))
    is_auto_tune_enabled          = optional(bool)
    kms_key_id                    = optional(string)
    size_in_gbs                   = optional(string)
    vpus_per_gb                   = optional(string)
    xrc_kms_key_id                = optional(string)
    source_details = object({
      change_block_size_in_bytes = optional(string)
      first_backup_id            = optional(string)
      id                         = optional(string)
      second_backup_id           = optional(string)
      type                       = string
    })
    autotune_policies = optional(list(object({
      autotune_type   = string
      max_vpus_per_gb = optional(string)
    })))
    boot_volume_replicas = optional(list(object({
      availability_domain = string
      display_name        = optional(string)
      xrr_kms_key_id      = optional(string)
    })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.core_boot_volumes : (
        contains([for v in ["bootVolume", "bootVolumeBackup", "bootVolumeBackupDelta", "bootVolumeReplica"] : lower(v)], lower(v.source_details.type))
      )
    ])
    error_message = "must be one of: \"bootVolume\", \"bootVolumeBackup\", \"bootVolumeBackupDelta\", \"bootVolumeReplica\""
  }
  validation {
    condition = alltrue([
      for k, v in var.core_boot_volumes : (
        v.autotune_policies == null || alltrue([for item in v.autotune_policies : (contains([for v in ["DETACHED_VOLUME", "PERFORMANCE_BASED"] : lower(v)], lower(item.autotune_type)))])
      )
    ])
    error_message = "must be one of: \"DETACHED_VOLUME\", \"PERFORMANCE_BASED\""
  }
  # Note: 4 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

