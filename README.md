# Mongo + AWS via Ansible
This example is explained in the following [post](https://www.jduv.me/devops/2016/10/19/ansible-stacks-2/). Give it a read, feel free to copy this code and modify to your hearts content, just do us a favor and give us a little internet love. Make sure you read all of this before you get started.

To make this example work, create the file ```vars/credentials.yml``` and drop your aws credentials in. 

_credentials.yml_

```
access_key_id: <insert here>
secret_access_key: <insert here>
```

Next create another file in the root called ```vault-password.txt``` and dump a decently strong password on the first line of the file. Next, from the root directory run the following command:

```
ansible-vault encrypt vars/credentials.yml --vault-password-file=vault-password.txt
```

**Note: Never, ever, ever, ever check an unencrypted credentials file into any repository. I am not responsible for your AWS bill if you choose to do this.**

Finally, create a key pair in AWS for the new boxes and drop it into the keys directory. Modify the ```config.yml``` to reflect your key names:

```
---
# SSH configuration
ec2_ssh_user: ec2-user
ssh_key_name: <your key name>
ssh_key_path: keys/<your key name>.pem

# Miscellaneous
application: MongoExample

# global variables
mongo_subnets_to_azs: []
```

Remember to ```chmod 400``` your key file or ansible will fail to connect to the boxes you spin up.

To install a test mongo set into a new VPC in the ```us-east-1``` region run the following command:

```
./install-mongo-in us-east-1 development
```

Feel free to tweak the ```mongodb_us-east-1_default_install.yml``` to your hearts content to modify the deployment.