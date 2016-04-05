$username='chrisbarker'

ec2_instance { ["centos-stack-02-${username}",
  "centos-stack-01-${username}",
  "centos-stack-03-${username}",
  "centos-agent-01-${username}"
  ]:
  ensure => absent,
  before => Ec2_Securitygroup['tse-awstraining-agentsg'],
}
ec2_securitygroup { 'tse-awstraining-agentsg':
  ensure  => absent,
}
ec2_vpc_subnet { ['tse-awstraining-avzb','tse-awstraining-avzc']:
  ensure => absent,
  require => Ec2_Securitygroup['tse-awstraining-agentsg'],
}
