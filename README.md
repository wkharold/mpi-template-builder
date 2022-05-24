# mpi-template-builder

## Overview
The contents of this repo automates the creation of Julia MPI *instance templates*.
The created templates can then be used to create GCP compute instances via the console or
the command line.

## Usage
Instance template creation requires two steps
1. Create a source image that the template will use
1. Create the template itself

### Source image creation
This step uses Cloud Build to create the source image.

1. Change directories to the *img* directory
```bash
cd img
```

2. Run the `create-buildstep.sh` script to build a version of the Cloud Build community Packer custom build step in your project
```bash
. ./create-buildstep.sh
```

3. Run the `builder-setup.sh` script to create the GCP service accounts and keys necessary to generate a source image using Cloud Build
```bash
. ./builder-setup.sh
```

4. Build the source image using the `build-image.sh` script. The ZONE flag is required: `-z <zone>`. Optionally, you can specify the MACHINE_TYPE to use via the `-m <machine_type>` flag.

`usage build-image.sh -z ZONE [-m MACHINE_TYPE]

```bash
./build-image.sh -z us-central1-a -m c2-standard-16
```

This command will show you the latest source image in your project
```bash
gcloud compute images list --filter="name ~ julia-mpi" --format="value(name)" | sort -r | head -n1
```

### Instance template creation
This step uses Terraform to create an instance template based on your most recent source image
```bash
cd ../tf
```

The `mkvars.sh` script creates a .TFVARS file that contains values for the variables used by the Terraform configs in this directory

`usage mkvars.sh -n NAME_PREFIX -m MACHINE_TYPE`

```bash
terraform apply -var-file $(. ./mkvars -n julia-mpi -m c2-standard-16)
```

After the `terraform apply` completes you can use the console to create GCP compute instances from your new instance template.
