class awstraining::subnet {
  $aws_tags = {
    'department' => 'tse',
    'project'    => 'awstraining',
  }

  ec2_vpc_subnet { 'tse-awstraining-avzb':
    ensure                  => present,
    region                  => 'us-west-2',
    vpc                     => 'tse-awstraining-vpc',
    cidr_block              => '10.70.40.0/24',
    availability_zone       => 'us-west-2b',
    route_table             => 'tse-awstraining-routes',
    map_public_ip_on_launch => true,
    tags                    => $aws_tags,
  }
  ec2_vpc_subnet { 'tse-awstraining-avzc':
    ensure                  => present,
    region                  => 'us-west-2',
    vpc                     => 'tse-awstraining-vpc',
    cidr_block              => '10.70.30.0/24',
    availability_zone       => 'us-west-2c',
    route_table             => 'tse-awstraining-routes',
    map_public_ip_on_launch => true,
    tags                    => $aws_tags,
  }
}
