# citrixadc-autoscale-aws
Citrix ADC Autoscale AWS

# Before using
## Adding Azure Pipeline Extensions
Install the following:
* [AWS Tools for Microsoft Visual Studio Team Services](https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.aws-vsts-tools)
* [Terraform](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks)

## Create an AWS connection
Go to Project Settings > Service connections > New service connection > AWS > Name will be used as `awsCredentials` in variable group

## Accept AWS marketplace terms & conditions
Accept the terms & conditions for the following AMIs:
* [Citrix ADM External Agent AMI](https://aws.amazon.com/marketplace/pp?sku=d0xijb8bvlwe2al6o67tm468d)
* [Citrix ADC Advanced - 10Mbps AMI (pay-as-you-go)](https://aws.amazon.com/marketplace/pp?sku=9gwd6wx07zoi4fa1hrw9r2j03)
* [LAMP Certified by Bitnami](https://aws.amazon.com/marketplace/pp?sku=c1jifmii8vw5xd0npsnf9eza9)

## Required variables in the "aws-variables" group:
| Name | Example Value | Secret Value? | Description |
|---|---|---|---|
| awsCredentials | `aws-connection` | No | Needed to connect to AWS from Azure Pipelines. |
| citrixExternalId | `1111111-1111-1111-1111-111111111111` | Yes | Your unique ID from Citrix. [Prerequisites for Citrix ADM](https://docs.citrix.com/en-us/citrix-application-delivery-management-service/hybrid-multi-cloud-deployments/autoscale-for-aws/autoscale-for-aws-configuration.html#prerequisites-for-citrix-adm) |
| commonName | `adcautoscale` | No | A name that will be used in the deployment. Lower case without special characters. |
| deployPublicSshKey | `ssh-rsa <base64> user@computer` | Yes | Public SSH Key. |
| environment | `development` | No | Name of the environment. |
| environmentShort | `dev` | No | Short name of the environment. |
| externalDnsZone | `xenit.se` | No | DNS Zone which is going to be used by ADM Service. |
| externalManagementIp | `1.2.3.4/32` | Yes | Public IP to allow management from. |
| region | `eu-central-1` | No | Name of the AWS region. |
| regionShort | `euc1` | No | Short name of the AWS region. |
| tfVersion | `0.12.6` | No | Version of terraform to use. |

# Setting up
## Run the terraform
### Manual (powershell)
```
$ENV:AWS_DEFAULT_REGION = "<region>"
$ENV:AWS_ACCESS_KEY_ID = "<accessKey>"
$ENV:AWS_SECRET_ACCESS_KEY = "<secretKey>"
$ENV:TF_VAR_citrixExternalId = "<citrixExternalId>"
$ENV:TF_VAR_deployPublicSshKey = "<publicSshKey>"
$ENV:TF_VAR_externalManagementIp = "<externalManagementIp>"
$ENV:TF_VAR_externalDnsZone = "<externalDnsZone>"

cd terraform

terraform init -backend-config "bucket=<bucketName>" -backend-config "key=<stateName>.tfstate" 

terraform plan
terraform validate
terraform apply
```

Note: Change `$ENV:` to `export ` if using bash.


### Azure DevOps
The recommended way of running it, since all the configuration required is included. Create the variable group and add the azure-pipelines.yml.

## DNS Configuration
Point your nameservers to the route 53 dns zone created.

## Configure Citrix ADM Agent
Full documentation can be found here: [Install Citrix ADM agent on AWS
](https://docs.citrix.com/en-us/citrix-application-delivery-management-service/getting-started/install-agent-on-aws.html)

### Logging on to Citrix ADM Agent
SSH to the eip of the Bastion using the private ssh key and username `core`. Then SSH to the Citrix ADM Agent instance using `nsrecover` as the username and `Instance ID` of the instance as the password. (right now, the public key isn't working with this AMI).

### Configuring Citrix ADM Service connection
When logged on to the ADM Agent, run `deployment_type.py` to configure it: (you get the service url and activation code during the "Get Started" setup in ADM Service)
```
------------------------------------------------------------------------------------------------------------------------
Citrix ADM Agent Registration with Citrix ADM Service. This menu allows you to specify a cloud url and obtain an instance ID for your device.
------------------------------------------------------------------------------------------------------------------------
    Enter Service URL: <serviceUrl>
    Enter Activation Code : <activationCode>
----------------------------------------------------------------------------
Agent registration successful.
----------------------------------------------------------------------------
Restarting Agent Deamon. Please wait for a few minutes . . . . . .
Stopping Agent
Reinitializing monit daemon
Reinitializing monit daemon
Stopping nsulfd
Stopped nsulfd
Stopped Agent
Reinitializing monit daemon
rm: /var/run/agent_upgrade.pid: No such file or directory
Reinitializing monit daemon
rm: /var/run/agent_monitor.pid: No such file or directory
Reinitializing monit daemon
Reinitializing monit daemon
Cloud Agent
Starting Agent
agent upgrade daemon is already running.
agent monitor daemon is already running.
Starting nsulfd
kern.ipc.shmall: 8519680 -> 8519680
kern.ipc.shmmax: 134217728 -> 134217728
net.inet.tcp.fast_finwait2_recycle: 1 -> 1
kern.ipc.maxsockbuf: 16777216 -> 16777216
Started nsulfd
Started Agent
```

### ADM Service configuration
* Go to Networks > Agents
* Select the Agend and then press attach site
* Choose your AWS site deployed with terraform
* Follow the guide [Create autoscale groups](https://docs.citrix.com/en-us/citrix-application-delivery-management-service/hybrid-multi-cloud-deployments/autoscale-for-aws/autoscale-for-aws-configuration.html#create-autoscale-groups)
* When choosing security groups and subnets: client = outside, server = inside
