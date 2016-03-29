class awstraining::setup {
  $vpc_mask     = '10.70.0.0'
  $zone_a_mask  = '10.70.10.0'
  $vpc_name     = 'tse-awstraining-vpc'
  $igw_name     = 'tse-awstraining-igw'
  $routes_name  = 'tse-awstraining-routes'
  $region       = 'us-west-2'
  $aws_tags = {
    'department' => 'tse',
    'project' => 'awstraining',
  }

  ec2_vpc { $vpc_name:
    ensure     => present,
    region     => $region,
    cidr_block => "${vpc_mask}/16",
    tags       => $aws_tags,
  }

  ec2_vpc_internet_gateway { $igw_name:
    ensure  => present,
    region  => $region,
    vpc     => $vpc_name,
    require => Ec2_vpc[$vpc_name],
    tags    => $aws_tags,
  }

  ec2_vpc_routetable { $routes_name:
    ensure => present,
    region => $region,
    vpc    => $vpc_name,
    routes => [
      {
        destination_cidr_block => "${vpc_mask}/16",
        gateway                => 'local',
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway                => $igw_name,
      },
    ],
    require  => [
      Ec2_vpc[$vpc_name],
      Ec2_vpc_internet_gateway[$igw_name],
    ],
    tags => $aws_tags,
  }


  ec2_vpc_subnet { 'tse-awstraining-avza':
    ensure                  => present,
    region                  => 'us-west-2',
    vpc                     => 'tse-awstraining-us-west-2',
    cidr_block              => '10.70.20.0/24',
    availability_zone       => 'us-west-2c',
    route_table             => 'tse-awstraining-routes',
    map_public_ip_on_launch => true,
    tags => $aws_tags,
  }



}
