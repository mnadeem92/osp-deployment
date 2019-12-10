#!/bin/bash

openstack overcloud deploy \
--timeout 350 \
--templates /usr/share/openstack-tripleo-heat-templates \
--stack overcloud \
--libvirt-type kvm \
--ntp-server clock.redhat.com \
-e /home/stack/templates/nodes_data.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible-external.yaml \
-e /home/stack/templates/ceph-config.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
-e /home/stack/templates/network-environment.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-ip.yaml \
-e /home/stack/templates/enable-tls.yaml \
-e /home/stack/templates/inject-trust-anchor.yaml \
-e /home/stack/templates/containers-prepare-parameter.yaml
