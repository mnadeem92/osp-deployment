yum install rhosp-director-images rhosp-director-images-ipa -y
mkdir -p /home/stack/images
for i in /usr/share/rhosp-director-images/overcloud-full-latest-13.0.tar /usr/share/rhosp-director-images/ironic-python-agent-latest-13.0.tar; do tar -xvf $i; done
source /home/stack/stackrc 
openstack overcloud image upload --image-path /home/stack/images/
openstack overcloud node import /home/stack/templates/instackenv.json
openstack overcloud node introspect --all-manageable --provide
openstack baremetal node set --property capabilities='profile:control,boot_option:local' controller
openstack baremetal node set --property capabilities='profile:compute,boot_option:local' smicro-5037-05-mm.cfme.lab.eng.rdu2.redhat.com
openstack baremetal node set --property capabilities='profile:compute,boot_option:local' smicro-5037-06-mm.cfme.lab.eng.rdu2.redhat.com
