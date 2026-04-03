variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}
