variable "api_id" {
  type        = string
  description = "The ID of the associated REST API"
}

variable "resource_id" {
  type        = string
  description = "The API resource ID"
}

variable "http_method" {
  type        = string
  description = "The HTTP method (`GET`, `POST`, `PUT`, `DELETE`, `HEAD`, `OPTIONS`, `ANY`) when calling the associated resource."
}

variable "http_path" {
  type = string
  description = "Http path"
  default = null
}

variable "authorization" {
  type        = string
  default     = "NONE"
  description = "The type of authorization used for the method (NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS)"
}

variable "integration_request_parameters" {
  type    = map(any)
  default = {}
}

variable "method_request_parameters" {
  type        = map(any)
  default     = {}
  description = "(Optional) A map of request parameters (from the path, query string and headers) that should be passed to the integration. The boolean value indicates whether the parameter is required (true) or optional (false). "
}

variable "request_templates" {
  type    = map(any)
  default = {}
}

variable "responses" {
  type    = list(any)
  default = []
}

variable "table_arn" {
  type = string
  description = "Dynamodb table arn"
}

variable "dynamodb_action" {
  type = string
  description = "Dynamodb action"
}

variable "stack_name" {
    type = string
    description = "Stack name"
}