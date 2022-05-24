/**
 * Copyright 2018 Google LLC
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

module "instance_template" {
  source               = "github.com/terraform-google-modules/terraform-google-vm/modules/instance_template"
  region               = var.region
  project_id           = var.project_id
  name_prefix          = var.name_prefix
  network              = "default"
  service_account      = {
    email  = module.service_account.email
    scopes = var.scopes
  }
  tags                 = ["julia", "mpi"]
  machine_type         = var.machine_type
  disk_size_gb         = 256
  source_image         = var.image
  source_image_project = var.image_project 
}
