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

module "service_account" {
  source       = "github.com/terraform-google-modules/terraform-google-service-accounts"
  project_id   = var.project_id
  prefix       = var.name_prefix
  names        = ["juliampi"]
  display_name = "Julia MPI node service account"
  description  = "Service Account for Julia MPI node"
}

resource "google_project_iam_member" "julia_mpi_service_account" {
  project      = var.project_id
  role         = "roles/editor"
  member       = "serviceAccount:${module.service_account.email}"
}
