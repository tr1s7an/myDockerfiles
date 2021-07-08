#! /bin/sh

#sed -i "s/^#PasswordAuthentication.*$/PasswordAuthentication\ no/g" /etc/ssh/sshd_config
#sed -i "s/^#ChallengeResponseAuthentication.*$/ChallengeResponseAuthentication\ no/g" /etc/ssh/sshd_config
sed -i "s/^#PermitRootLogin.*$/PermitRootLogin\ yes/g" /etc/ssh/sshd_config
sed -i "s/^#ListenAddress\ 0\.0\.0\.0/ListenAddress\ 127\.0\.0\.1:22/g" /etc/ssh/sshd_config
echo "root:${password}" | chpasswd
ssh-keygen -A

/usr/sbin/sshd -f /etc/ssh/sshd_config -D
