#
# = Class: daticaldb::engine
#
#
# == Parameters
#
# [*ensure*]
#   String. Default: present
#   Manages package installation and class resources. Possible values:
#   * 'present' - Install software and ensure files are present.
#   * 'absent' - Remove software and associated files
#
# [*dependency_class*]
#   String. Default: stdmod::dependency
#   Name of a class that contains resources needed by this module but provided
#   by external modules. You may leave the default value to keep the
#   default dependencies as declared in daticaldb/manifests/dependency.pp
#   or define a custom class name where the same resources are provided
#   with custom ways or via other modules.
#   Set to undef to not include any dependency class.
#
# [*my_class*]
#   String. Default undef.
#   Name of a custom class to autoload to manage module's customizations
#   If defined, stdmod class will automatically "include $my_class"
#   Example: my_class => 'site::my_daticaldb',
#
# [*audits*]
#   String or array. Default: undef.
#   Applies audit metaparameter to managed files.
#   Ref: http://docs.puppetlabs.com/references/latest/metaparameter.html#audit
#   Possible values:
#   * '<attribute>' - A name of the attribute to audit.
#   * [ '<attr1>' , '<attr2>' ] - An array of attributes.
#   * 'all' - Audit all the attributes.
#
# [*install_path*]
#   String. Default: /usr/local/DaticalDB
#
# [*package_in_repo*]
#   Boolean. Default: false.
#   The default behavior of this module is to pull the datical install rpm
#   from the files directory of this module. This allows users who do not have
#   an internal RHN satellite server or other type of repository to load the
#   installer RPM into.
#
class daticaldb::engine (
  $ensure               = 'present',
  $dependency_class     = 'daticaldb::dependency',
  $my_class             = undef,
  $audits               = undef, #FIXME add support for this
  $install_path         = '/usr/local/DaticalDB/',
  $package_name         = 'DaticalDB',
  $package_in_repo      = undef
) {

  validate_re($ensure, ['present','absent'],
    'Valid values are: present, absent')

  ### Variables defined in daticaldb::params
  include daticaldb::params

  file {$install_path:
    ensure => directory
  }

  #figure out if we are managing the deb locally or relying on a repository
  if $package_in_repo == '' or $package_in_repo == false {
    file {"${install_path}/${package_name}.deb":
      ensure  => file,
      mode    => '0644',
      owner   => root,
      group   => root,
      source  => "puppet:///modules/daticaldb/${package_name}.deb",
      require => File[$install_path]
    }

    package{'DaticalDB':
      ensure     => installed,
      provider   => 'dpkg',
      source     => "${install_path}/${package_name}.deb",
      require    => File["${install_path}/${package_name}.deb"],
      subscribe  => File["${install_path}/${package_name}.deb"]
    }
  } else {
    package{'DaticalDB':
      ensure => installed
    }
  }
}
