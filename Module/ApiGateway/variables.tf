variable "api_id" {
  type        = string
  description = "The ID of the associated REST API"
}

variable "resource_id" {
  type        = string
  description = "The API resource ID"
}

variable "http_path" {
  type = string
  description = "Http path"
  default = null
}

variable "http_method" {
  type        = string
  description = "The HTTP method (`GET`, `POST`, `PUT`, `DELETE`, `HEAD`, `OPTIONS`, `ANY`) when calling the associated resource."
}

variable "integration_http_method" {
  type        = string
  default     = null
  description = "The integration HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONs, ANY, PATCH) specifying how API Gateway will interact with the back end. Required if type is AWS, AWS_PROXY, HTTP or HTTP_PROXY. Not all methods are compatible with all AWS integrations. e.g. Lambda function can only be invoked via POST."
}

variable "type" {
  type        = string
  description = "The integration input's type. Valid values are `HTTP` (for HTTP backends), `MOCK` (not calling any real backend), `AWS` (for AWS services), `AWS_PROXY` (for Lambda proxy integration) and `HTTP_PROXY` (for HTTP proxy integration). An `HTTP` or `HTTP_PROXY` integration with a connection_type of `VPC_LINK` is referred to as a private integration and uses a VpcLink to connect API Gateway to a network load balancer of a VPC"
}

variable "uri" {
  type        = string
  default     = null
  description = "The input's URI. Required if type is `AWS`, `AWS_PROXY`, `HTTP` or `HTTP_PROXY`. For `HTTP` integrations, the URI must be a fully formed, encoded HTTP(S) URL according to the RFC-3986 specification . For AWS integrations, the URI should be of the form `arn:aws:apigateway:{region}:{subdomain.service|service}:{path|action}/{service_api}`. region, subdomain and service are used to determine the right endpoint. e.g. `arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:012345678901:function:my-func/invocations`"
}

variable "credentials" {
  type        = string
  default     = null
  description = "The credentials required for the integration."
}

variable "request_validator_id" {
  type        = string
  description = "Request Validator Id"
  default     = null
}

variable "authorization" {
  type        = string
  default     = "NONE"
  description = "The type of authorization used for the method (NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS)"
}

variable "method_request_parameters" {
  type        = map(any)
  default     = {}
  description = "(Optional) A map of request parameters (from the path, query string and headers) that should be passed to the integration. The boolean value indicates whether the parameter is required (true) or optional (false). "
}

variable "model" {
  type        = string
  default     = "Empty"
  description = "Properties section of a mapping template"
}

variable "integration_request_parameters" {
  type    = map(any)
  default = {}
}

variable "request_templates" {
  type    = map(any)
  default = {}
}

variable "responses" {
  type    = list(any)
  default = []
}