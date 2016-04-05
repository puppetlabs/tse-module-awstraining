AWS Informational Session 101

Slide Content:
- [U-Penn CS AWS Slidses](http://www.cis.upenn.edu/~nets212/slides/05-CloudBasics.ppt)
- [AWS Lifecycle Blog/PDF](https://puppetlabs.com/blog/making-life-puppet-and-aws-or-other-cloud-services-easier)

References/Modules:
- [Puppet Labs AWS Module](https://github.com/puppetlabs/puppetlabs-aws)
- [TSE AWSEnv](https://github.com/puppetlabs/tse-module-awsenv)
- [ec2tags modules](https://github.com/mrzarquon/puppet-ec2tags)
- [certsigner](https://github.com/mrzarquon/mrzarquon-certsigner)
- [autosign](https://github.com/danieldreier/puppet-autosign)

Guide:

This is meant to provide an introduction to some concepts and examples to go along with a presentation about introductory use of the PuppetLabs/AWS module and basic AWS concepts.

Availability Zones:
AWS divides their datacenters into two or more availability zones. These are physically separate compute/network resources inside the same datacenter - there is a chance that all of your machines deployed in a single availability zone could end up on the same physical hypervisor - by spreading your infrastructure across availability zones it protects against an availability zone wide outage (ie, network routing going bad, hypervisors going offline, etc). It does not protect against the entire datacenter going offline. It is considered best practice to scale multinode applications across availability zones to provide uptime in case of single zone failures. The PuppetLabs/AWS module requires we provide specific AVZ's for each instance we provide, so it is best to either manually keep changing the AVZ or use an iterator to rotate them. See this [example](https://github.com/puppetlabs/puppetlabs-aws/blob/master/examples/distribute-across-az/init.pp)

What is a VPC?
It stands for "Virtual Private Cloud" - it is best thought of a logically separate unit of virtual resources. Anything inside a VPC is isolated from other VPCs and the internet at large. One configures an internet gateway and routing policies to allow machines inside a VPC to talk to each other, and also to connect to the larger network or other VPCs. This repository assumes the VPC has already established with DNS and DHCP configured (by default these services are not enabled for a VPC). Prior to VPCs there was "classic" which meant just your instances were in a general pool of resources, you could setup security groups to control access to it, but things like internal hostnames and ip addresses would be inconsistent between reboots. VPC's isolation allows for you to have multiple different VPCs with identical routes, ip addresses, hostnames internally to them.

VPCs can do some interesting things such as:
 - Attach to other VPCs through routing, including VPCs of other AWS user accounts
 - Configured to use DirectConnect or VPNs to act as a "just there" set of resources inside a company network: many users have VPCs with no outbound internet access themselves, instead routing through on premise firewalls and policy servers.
 - Be templatized and stood up programmatically, via CloudFormations templates (all json all the time), or our puppetlabs/aws module

What is a VPC Subnet?
It is a general subnet, just like any other, it is associated with a VPC and an AVZ. When defining an ec2_instance you need to ensure that the AVZ and subnet name exist in the same environment, otherwise the AWS API gives back nondeterminate error messages.

Security Groups:
Network access rules by ports / services, you can use them to control access between servers. You always need to assign one security group to a server, you can however assign more as needed, and change security groups after you've launched the instance. They can be dynamic and rules based (so you use one security group to refer to another - ie, all nodes in the agent security can talk to the all nodes in the master group). Most people make them too open (like ours).

Hostnames in AWS:
Inside a VPC, an instances hostname renames the same even through reboots. This is an option to enable DHCP hostnames in the VPC, by default it is off. I always turn it on. You can also enable public hostnames, which allows for the instance to connect to the internet (ie for yum), and be accessed from the internet. Public hostnames can change between reboots, if you need something sticky, you can setup route53 dns or other services to point to the public IP of the server (which will also change). Inside puppet you can safely use the internal hostname for registering agents (inside the same vpc) and installing PE, but if you are starting to design a "management VPC" that itself is just attached to other VPCs, then you'd want to investigate using route53 dns or similar to provide a single domain resolution to point to your puppetmaster (dns_alt_names, etc).

Applications in AWS:
This is a gross simplification, but generally designing and deploying applications in AWS should be built with the concept that something will fail and things should be scalable. Rightsizing compute for AWS can be difficult, but can save a significant amount of resources: if an app can be distributed across N+1 servers, and scale in high load events, one can only be paying for the number of compute instances needed to serve the current customer load vs needing to pay for servers to handle the peak loads.

A common architecture would be something like a route53 dns entry pointing to an elastic loadbalancer which is the edge of a VPC - inside the VPC contains multiple web instances, possibly RDS (database appliance as a service) backend, and autoscale groups (groups of machines which aren't addressed individually but instead are the infamous 'cattle' - if machines start showing high load, more are provisioned until load goes down to acceptable levels, if machines become non responsive, they are destroyed and replaced). Trusted autosigning and zero hands on intervention and automation are all essential for Puppet to work in these environments.
