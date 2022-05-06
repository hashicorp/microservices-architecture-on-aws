# Microservices Architecture on AWS

This is the working github repository for the [**"Learning Live with AWS & HashiCorp"**](https://www.youtube.com/playlist?list=PL81sUbsFNc5bYnjraNpivm1XxR3WNM_Kd) series. We'll discuss the foundations of a microservices architecture, the problem space it solves, where service mesh fits into all of this, and then begin from scratch - setting up a Terraform project, creating a Virtual Private Cloud (VPC), and explaining all of the concepts along the way.

This repo will be updated after each episode!

This repo is split into branches, each representing a part in the series:

- [Part 1](https://github.com/hashicorp/microservices-architecture-on-aws/tree/part-1) - Setting up the Terraform project and creating a VPC
- [Part 2](https://github.com/hashicorp/microservices-architecture-on-aws/tree/part-2) - Creating your first containerized microservice on Amazon ECS with Terraform
- [Part 3](https://github.com/hashicorp/microservices-architecture-on-aws/tree/part-3) - Extending your application with private microservices
- [Part 4](https://github.com/hashicorp/microservices-architecture-on-aws/tree/part-4) - Introducing a Service Mesh with Consul
- [Part 5](https://github.com/hashicorp/microservices-architecture-on-aws/tree/part-5) - Setting Up Your Service Mesh Servers

## The Architecture

Our first section of episodes will work towards building out the following architecture:

![Microservices Architecture on AWS Section 1](images/section-1-architecture.png)

The second section of episodes will work towards refactoring the first section's architecture into using a Service Mesh.

## Getting Started

#### Prerequisites

1. Have an [AWS Account](https://aws.amazon.com/).

2. Install [HashiCorp Terraform](https://www.terraform.io/downloads).

3. Have the [AWS CLI Installed](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

4. Create an [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html) with Admin or Power User Permissions.
  - this user will only be used locally

5. [Configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) with the IAM User from Step 4.
  - Terraform will read your credentials via the AWS CLI 
  - [Other Authentication Methods with AWS and Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)

#### Using this Code

1. Clone this repo to an empty directory.

2. Run `terraform plan` to see what resources will be created.

3. Run `terraform apply` to create the infrastructure on AWS!

4. Run `terraform destroy` when you're done to get rid of the infrastructure.

## Questions?  Suggestions?  Comments?

Reach out to either [Jenna Pederson](https://twitter.com/jennapederson) or [J. Cole Morrison](https://twitter.com/JColeMorrison).  Also, feel free to leave any issues you run into on this Github Repo!