/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "image" {
  description = "Source disk image to use for instance creation"
  type        = string
}

variable "image_project" {
  description = "GCP project the source disk image used for instance creation belongs to"
  type        = string
}

variable "machine_type" {
  description = "Type of Compute Engine instance to create"
  type        = string
  default     = "c2-standard-60"
}

variable "name_prefix" {
  description = "The base name for the GCP instance_template being created"
  type        = string
}

variable "num_instances" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "scopes" {
  description = "OAuth scopes for the instance service account"
  type        = set(string)
  default     = [ "cloud-platform" ]
}
