ctx logger info "starting DNS..."

# Update BIND configuration with the specified zone and key.
sudo bash -c 'cat >> /etc/bind/named.conf.local << EOF
key example.com. {
  algorithm "HMAC-MD5";
  secret "8r6SIIX/cWE6b0Pe8l2bnc/v5vYbMSYvj+jQPP4bWe+CXzOpojJGrXI7iiustDQdWtBHUpWxweiHDWvLIp6/zw==";
};

zone "example.com" {
  type master;
  file "/var/lib/bind/db.example.com";
  allow-update {
    key example.com.;
  };
};
EOF'

# zone configuration.
cat > /home/ubuntu/db.example.com << EOF
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     example.com. root.example.com. (
                          1         	; Serial
                          604800      ; Refresh
                          86400       ; Retry
                          2419200     ; Expire
                          604800 )    ; Negative Cache TTL
;
@       IN      NS      example.com.
@       IN      A       $dns_ip

EOF

# apparmor in Ubuntu
sudo mv /home/ubuntu/db.example.com /var/lib/bind
sudo chown root:bind /var/lib/bind/db.example.com

# forwarder configuration
sudo bash -c 'cat > /etc/bind/named.conf.options << EOF
options {
        directory "/var/cache/bind";
        allow-recursion { any; };
        allow-query { any; };
        allow-query-cache { any; };
        forwarders {
                8.8.8.8;
        };
        dnssec-validation auto;
        auth-nxdomain no;
        listen-on-v6 { any; };
};
EOF'

ctx logger info "DNS IP address is ${dns_ip}"
sudo echo ${dns_ip} > /home/ubuntu/dnsfile

# Now that BIND configuration is correct, kick it to reload.
sudo service bind9 reload
