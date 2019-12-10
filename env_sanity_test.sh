echo "This script should be run on undercloud node"
source ./overcloudrc
curl -O http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
openstack image create --disk-format qcow2 --container-format bare --public --file ./cirros-0.3.5-x86_64-disk.img cirros
openstack flavor create --public m1.extra_tiny --id auto --ram 128 --disk 0 --vcpus 1 --rxtx-factor 1
openstack security group create secgroup
openstack security group rule create secgroup --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
openstack security group rule create --protocol icmp secgroup
neutron net-create public --router:external --provider:network_type flat --provider:physical_network datacentre
neutron subnet-create --name public --enable_dhcp=False --allocation-pool=start=192.168.24.210,end=192.168.24.225 --gateway=192.168.24.1 public 192.168.24.128/25
openstack network create net1
openstack subnet create subnet1 --network net1 --subnet-range 192.0.2.0/24
neutron router-create router1
neutron router-gateway-set router1 public
neutron router-interface-add router1 subnet1
neutron floatingip-create public
netid=$(openstack network show net1 -f value -c id)
floatip=$(openstack floating ip list -f value -c "Floating IP Address"|head -1)
test -f ~/.ssh/id_rsa.pub || ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
nova keypair-add --pub-key ~/.ssh/id_rsa.pub testkey
nova boot --nic net-id=$netid --image cirros --security-groups secgroup --key-name testkey --flavor m1.extra_tiny testvm
sleep 20
openstack server add floating ip testvm $floatip
openstack server list
nova console-log testvm
ping -c 5 $floatip
