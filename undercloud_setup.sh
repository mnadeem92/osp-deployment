source ~/.venv_infrared/bin/activate
cd ~/.venv_infrared/infrared
#Create work space for undercloud deployment
infrared workspace create $MAINSERVER
# Cleanup the system
infrared virsh --host-address $MAINSERVER --host-key ~/.ssh/key_osp --cleanup yes
# Prepare the environment
infrared virsh --host-address $YOURLABSERVER --host-key ~/.ssh/key_osp --topology-nodes undercloud:1,controller:1 -e override.controller.cpu=4 -e override.controller.memory=32288 -e override.undercloud.disks.disk1.size=150G --image-url http://download-node-02.eng.bos.redhat.com/brewroot/packages/rhel-guest-image/7.7/415/images/rhel-guest-image-7.7-415.x86_64.qcow2
# Deploy undercloud environment
infrared tripleo-undercloud --version 13 --images-task=rpm --build ga
# Update the instack.env file with physical compute nodes entry
# Launch the introspection of the nodes
infrared tripleo-overcloud --deployment-files virt --version 13 --introspect yes --tag yes --deploy no --post no --containers yes
#Note : After that you can able to access the undercloud node using below credential
#ssh stack@undercloud-0
#Password : stack

