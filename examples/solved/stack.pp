class awstraining::stack {
  $username='chrisbarker'

  Ec2_Instance {
    ensure            => 'running',
    image_id          => 'ami-d440a6e7',
    instance_type     => 'm4.medium',
    key_name          => 'chris.barker',
    region            => 'us-west-2',
    security_groups   => ['tse-awstraining-agentsg'],
    tags              => {
      'department'    => 'tse',
      'project'       => 'awstraining',
      'created_by'    => $username,
    },
    user_data         => 'puppet:///modules/awstraining/rpm.sh',
  }

  Ec2_Instance { "centos-stack-02-${username}":
    availability_zone => 'us-west-2c',
    subnet            => 'tse-awstraining-avzc',
  }
  Ec2_Instance { "centos-stack-01-${username}":
    availability_zone => 'us-west-2b',
    subnet            => 'tse-awstraining-avzb',
  }
  Ec2_Instance { "centos-stack-03-${username}":
    availability_zone => 'us-west-2c',
    subnet            => 'tse-awstraining-avza',
  }
}
