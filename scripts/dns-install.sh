ctx logger info "installing DNS..."
# Install BIND.
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install bind9 --yes
