# Class: daticaldb4puppet::params
#
# This class defines default parameters used by the main module class stdmod
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to daticaldb4puppet class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class daticaldb4puppet::params {

  ### Application related parameters

  $file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $file_group = $::operatingsystem ? {
    default => 'root',
  }

  #only supporting yum for now, may need to change later
  $package_provider = $::operatingsystem ? {
    default => 'yum',
  }
}
