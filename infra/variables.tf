variable "domain_name" {
  type        = string
  default = "ge.org"
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  default = "gedotorg-bucket"
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
}


variable "index_document" {
  description = "The name of the index document"
  default     = "index.html"
}

variable "error_document" {
  description = "The name of the error document"
  default     = "error.html"
}
