data "local_file" "authorized_keys" {
  filename = pathexpand("~/.ssh/remote_ssh_authorized_keys")
}

locals {
  # Split the content by newlines
  authorized_keys_lines = split("\n", data.local_file.authorized_keys.content)

  # Filter out empty lines and comments (lines starting with #)
  # Then trim whitespace from each key
  ssh_keys = [
    for line in local.authorized_keys_lines : trimspace(line)
    if line != "" && !startswith(trimspace(line), "#")
  ]
}

output "parsed_ssh_keys" {
  value = local.ssh_keys
  description = "List of parsed SSH public keys."
}

