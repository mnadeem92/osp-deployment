sudo yum install -y git gcc libffi-devel openssl-devel python-virtualenv libselinux-python redhat-rpm-config
# prepare virtual Environment
virtualenv ~/.venv_infrared
source ~/.venv_infrared/bin/activate
pip install --upgrade pip
pip install --upgrade setuptools
cd ~/.venv_infrared
git clone https://github.com/redhat-openstack/infrared.git
cd infrared
pip install .
echo ". $(pwd)/etc/bash_completion.d/infrared" >> ${VIRTUAL_ENV}/bin/activate
ssh-keygen -f ~/.ssh/key_osp
ssh-copy-id -i ~/.ssh/key_osp.pub root@$BASESERVER

