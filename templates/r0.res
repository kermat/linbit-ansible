resource r0 {
  device    /dev/drbd0;
  disk      {{ drbd_backing_disk }};
  meta-disk internal;
  on {{ hostvars['linbit-ans-a']['ansible_hostname'] }} {
    address   {{ hostvars['linbit-ans-a']['drbd_replication_ip'] }}:7999;
    node-id   0;
  }
  on {{ hostvars['linbit-ans-b']['ansible_hostname'] }} {
    address   {{ hostvars['linbit-ans-b']['drbd_replication_ip'] }}:7999;
    node-id   1;
  }
  connection-mesh {
	hosts {{ hostvars['linbit-ans-a']['ansible_hostname'] }} {{ hostvars['linbit-ans-b']['ansible_hostname'] }};
  }
}
