# Task10
Assignments on Azure
1. Create a Resource Group (using portal)
2. Create a vnet/subnet inside the resource group (using portal)
3. Create a virtual machine OS: Ubuntu Focal (using portal). Explore Availability sets/zones.
4. Setup a Flask app inside the VM which prints the hostname of the VM
5. Create an SP with Contributor access on the subscription.
6. Create a VM in the same resource group, vnet, subnet using terraform using the SP in step 5 and setup the flask app in the second VM as well
7. Add an NSG rule to allow inbound traffic only on ssh port and the port on which the flask app is running (using portal)
8. Create a load balancer, to balance between the 2 VMs (flask app), so that it prints the hostnames of both the VMs in round robin.
9. Shut down one of the machines and check how the load balancer works.
10. Add a 10G data disk to the machine, and create a mount point to redirect the flask app logs to the mount point. Explore disk redundancy options.
11. Resize the VMs (via portal and terraform resp.)
12. Destroy all the resources. Delete the SP and extra users added if any.
