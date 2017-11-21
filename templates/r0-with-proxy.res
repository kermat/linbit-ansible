resource r0 {
  protocol A;
  device    /dev/drbd0;
  disk      {{ drbd_backing_disk }};
  meta-disk internal;
  proxy {
      memlimit 100M;
  }
  on {{ hostvars['linbit-ans-a']['ansible_hostname'] }} {
    address   127.0.0.1:7997;
    proxy on {{ hostvars['linbit-ans-a']['ansible_hostname'] }} {
        inside   127.0.0.1:7998;
        outside   {{ hostvars['linbit-ans-a']['drbd_replication_ip'] }}:7999;
    }
    node-id   0;
  }
  on {{ hostvars['linbit-ans-b']['ansible_hostname'] }} {
    address   127.0.0.1:7997;
    proxy on {{ hostvars['linbit-ans-b']['ansible_hostname'] }} {
        inside   127.0.0.1:7998;
        outside   {{ hostvars['linbit-ans-b']['drbd_replication_ip'] }}:7999;
    }
    node-id   1;
  }
}
