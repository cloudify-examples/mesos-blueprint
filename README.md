## Apache Mesos Example Blueprint

### Mesos Base Image Creation

The Mesos blueprint requires the input of a pre-built Mesos image. If you are using AWS, you can use a Mesos AMI.

If you need to create a Mesos Image, a local mode blueprint is provided for creating a Mesos image in the `util/image.yaml` file. The example is for Openstack. Clone the repo to a system that has access to the target Openstack cloud, and has a Cloudify context.  Edit the `util/imports/openstack/blueprint.yaml` file, and fill in the default values for:

* image : This should be an existing Ubuntu 14.04 image.
* flavor : This should be a flavor at least 1x2x20.  More CPU will make the build faster.
* ssh_keyname: The key to be used for accessing the server.
* ssh_keyfile: The private key file corresponding to `ssh_keyname`.
* network_name: The existing network that the server will attach to.
* subnet_name: The existing subnet in the network to attach to.
* external_network_name: The network that the public IP will be created on.

Then in the `dsl_definition`, fill in the Openstack credentials:

* username: Your Openstack user name.
* password: Your Openstack password.
* tenant_name: Your Openstack tenant name.
* auth_url: Your Openstack Keystone URL.

Once the defaults are filled in, run the `create-image.sh` script.  It simply runs a `cfy local init` followed by an execution of install.  This will produce an image configured with Mesos and Docker.  The process takes a long time.  When complete, create a snapshot from the image, and copy the ID of the snapshot.  Then stand up the Mesos cluster:

### Mesos Cluster Creation

#### AWS

* Edit the `inputs/aws.yaml.example` file inputs defaults as follows:
 * vpc_id : The VPC where your manager controller is.
 * vpc_cidr_block : The CIDR of that VPC.
 * public_subnet_id: The subnet of the Mesos master.
 * public_subnet_cidr: That subnet's CIDR.
 * private_subnet_id: The subnet of the Mesos slave(s).
 * private_subnet_cidr: That subnet's CIDR.
 * ec2_region_name: The AWS region.
 * ec2_region_endpoint: The AWS API region endpoint.
 * availability_zone: The AWS  region availability zone.
 * ami: the AWS flavor id.  All Mesos nodes will use this.
 * instance_type : the AWS AMI instance type.
* Install: ```cfy install aws-blueprint.yaml -i inputs/aws.yaml.example -b mesos```


#### Openstack

* Edit the `imports/openstack/blueprint.yaml` file inputs defaults as follows:
 * image : the image ID from the image creation above.
 * flavor : the Openstack flavor id.  All Mesos nodes will use this.  It will need to have at least as much disk as the image.
 * agent_user : the ssh user to log into the instances (default= `ubuntu`)
* Upload the blueprint to your Cloudify manager.
* Create a deployment and run the install workflow.

This will create the Mesos cluster.  The master node is assigned a public ip.  You can see it by running `cfy deployments outputs -d <your-deployment-id>`.

The cluster is configured for auto-healing on the slave nodes.  Kill a slave node using the Openstack UI or API, and the deployment will heal itself after a minute.


#### Autoscaling

To see autoscaling in action:
* get the IP address of the Mesos slave.
* ssh to the Cloudify manager: `cfy ssh`
* ssh to the Mesos slave: `sudo ssh -i /root/.ssh/agent_key.pem ubuntu@<slave-ip>`
* run the following command to generate load: `dd if=/dev/zero of=/dev/null &; dd if=/dev/zero of=/dev/null`.
* Then go to the Cloudify UI deployments tab.  See the `scale` workflow begin and grow the cluster.
* To kill the load generation, hit `<ctrl-c>` followed by `fg` and `<ctrl-c>` again.

In a few minutes, the cluster will scale down to it's original size (one worker) due to the scale down policy in the blueprint.


#### Uninstalling

To tear down the cluster, run `cfy uninstall mesos -p ignore_failure=true`
