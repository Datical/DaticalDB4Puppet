#
# = Class: daticaldb4puppet::project
#
#
# == Parameters
#
# [*db_hostname*]
#   String. Hostname of the box to perform migrations on
#
# [*db_username*]
#   String. Username to login to the database with
#
# [*db_password*]
#   String. Password to login to the database with
#
# [*db_port*]
#   String. Network port the database is listening on.
#
# [*db_name*]
#   String. Name of the database to perform migrations on
#
# [*db_type*]
#   String. Valid values are:
#   - mysql
#   - db2
#   - oracle
#   - mssql
#
# [*path*]
#   String. Path on the filesystem that the DaticalDB migration project lives.
#
# [*jdbc_driver*]
# FIXME
# 
# [*db_instance*]
# FIXME

define daticaldb4puppet::project (
  $db_hostname          = undef,
  $db_username          = undef,
  $db_password          = undef,
  $db_port              = undef,
  $db_name              = undef,
  $db_type              = undef,
  $path                 = undef,
  $db_instance          = undef,
  $driver_path          = undef,
  $jdbc_driver		= undef,
  $ensure               = undef
) {
  ### Input parameters validation
  validate_string($db_hostname, 'Hostname is required.')
  validate_string($db_username, 'Username is required.')
  validate_re($db_port, '^\d+$', 'Port is required and must be an integer.')
  validate_string($db_name, 'Database name is required.')
  validate_re($db_type, ['mysql', 'db2', 'oracle', 'mssql'],
    'Database type must be one of mysql, db2, oracle or mssql.')
  validate_string($path, 'Path is required.')
  validate_string($jdbc_driver, 'JDBC Driver is requried.')
  validate_string($db_instance, 'The instance name in the Datical DB project.')

  #set the db depdendent settings
  case $db_type {
    'mysql': {
      $db_type_string = 'dbproject:MysqlDbDef'
      $db_driver      = 'com.mysql.jdbc.Driver'
    }
    'db2':   {
      $db_type_string = 'dbproject:' #FIXME need to know the dbproject string
      $db_driver      = '' #FIXME need to know the driver class
    }
    'oracle': {
      $db_type_string = 'dbproject:' #FIXME need to know the dbproject string
      $db_driver      = '' #FIXME need to know the driver class
    }
    'mssql': {
      $db_type_string = 'dbproject:' #FIXME need to know the dbproject string
      $db_driver      = '' #FIXME need to know the driver class
    }
    default: {
      fail("unknown db type ${db_type}")
    }
  }

  file { "${path}":
    source => "puppet:///modules/daticaldb4puppet/${name}",
    recurse => true,
  }

  file { "${driver_path}/${jdbc_driver}":
    source => "puppet:///modules/daticaldb4puppet/${jdbc_driver}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  }

  file { "${path}/datical.project":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('daticaldb4puppet/datical.project.erb')
  }

  file { "${path}/daticaldb.properties":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('daticaldb4puppet/daticaldb.properties.erb')
  }

  db_migration { $name:
    ensure => $ensure,
    require => File["${path}/datical.project"],
    path   => $path,
    db_instance => $db_instance
  }
}
