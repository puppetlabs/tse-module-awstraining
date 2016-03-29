class awstraining::agent {
  $username='chrisbarker'

  ec2_instance { "centos-agent-01-${username}":
    ensure            => 'running',
    availability_zone => 'us-west-2b',
    image_id          => 'ami-d440a6e7',
    instance_type     => 'm4.medium',
    key_name          => 'chris.barker',
    region            => 'us-west-2',
    security_groups   => ['tse-awstraining-agentsg','tse-awstraining-prep'],
    subnet            => 'tse-awstraining-avzb',
    tags              => {
      'department'    => 'tse',
      'project'       => 'awstraining',
      'created_by'    => $username,
    },
    user_data         => 'puppet:///modules/awstraining/rpm.sh',
  }


}
