class awstraining::securitygroup {
  $aws_tags = {
    'department' => 'tse',
    'project'    => 'awstraining',
  }

  ec2_securitygroup { 'tse-awstraining-agentsg':
    ensure      => present,
    region      => 'us-west-2',
    vpc         => 'tse-awstraining-vpc',
    description => 'Security group for use by the Master, and associated ports',
    ingress     => [
      {
        protocol => 'tcp',
        port     => '80',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '8080',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '443',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '3000',
        cidr     => '0.0.0.0/0',
      },
      {
        cidr => '10.70.0.0/16',
        port => '-1',
        protocol => 'icmp'
      },
    ],
    tags => $aws_tags,
  }



}
