## Docker Installation [[Docker without Sudo Tutorial](https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md)]
```bash
sudo apt-get update
sudo apt-get install docker.io

sudo groupadd docker
sudo gpasswd -a $USER docker # Log out, then log back in via SSH
sudo service docker restart
```


## Docker Compose Installation
Go to [this link](https://github.com/docker/compose/releases) and look for docker-compose-linux-x86_64, then copy its URL link.
```bash
mkdir bin
cd bin
wget https://github.com/docker/compose/releases/download/v2.26.1/docker-compose-linux-x86_64 -O docker-compose    # -O specifies the output filename
chmod +x docker-compose

cd
nano .bashrc  # add export PATH="${HOME}/bin:${PATH}" at the bottom
source .bashrc
```


## Terraform Installation
Download the Terraform package and install it with the following commands:

```bash
cd bin
wget https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
sudo apt-get install unzip
unzip terraform_1.7.5_linux_amd64.zip
rm terraform_1.7.5_linux_amd64.zip
```
