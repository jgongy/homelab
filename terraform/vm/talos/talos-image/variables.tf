variable "image" {
    description = "Talos image details"
    type = object({
      version = string
      extensions = list(string)
      platform = string
      architecture = string
    })
}