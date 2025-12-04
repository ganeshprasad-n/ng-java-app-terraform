variable "asg_name" {
  description = "ASG name for alarm dimensions"
  type        = string
}

variable "scale_out_adjustment" {
  description = "Instances to scale out"
  type        = number
  default     = 2
}

variable "scale_in_adjustment" {
  description = "Instances to scale in"
  type        = number
  default     = -1
}

variable "cpu_high_threshold" {
  description = "CPU % for scale out"
  type        = number
  default     = 70
}

variable "cpu_low_threshold" {
  description = "CPU % for scale in"
  type        = number
  default     = 30
}