variable "stage" {
  description = "(Required) The stage you want to deploy your function"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.stage)
    error_message = "The stage name must be \"dev\", \"staging\" or \"prod\"."
  }   
}