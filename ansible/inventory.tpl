[public_hosts]
public_instance ansible_host=${public_ip} ansible_user=ec2-user

[private_hosts]
%{ for idx, ip in private_ips ~}
private_instance_${idx + 1} ansible_host=${ip} ansible_user=ec2-user
%{ endfor ~}
