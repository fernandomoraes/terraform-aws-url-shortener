variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "stack_name" {
  type        = string
  description = "Stack name"
}

variable "model" {
  type        = string
  default     = "Empty"
  description = "Properties section of a mapping template"
}

variable "api_stage_name" {
  type = string
  description = "Api stage name"
}