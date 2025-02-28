# Installs and configures rssh.
class rssh (
  $package     = 'rssh',
  $config_file = '/etc/rssh.conf',
  $config_mode = '0644',
  $allow       = [],
  $umask       = '022',
  $logfacility = 'LOG_USER',
  $chrootpath  = false,
  $users       = []
) {
  if $facts['os']['release']['major'] > '8' {
    exec { 'rssh-download':
      command => 'wget http://prdownloads.sourceforge.net/rssh/rssh-2.1.1-1.RH9.i386.rpm?download -O /tmp/rssh-2.1.1-1.RH9.i386.rpm',
      path    => '/usr/sbin:/usr/bin:/sbin:/bin',
      unless  => 'rpm -q rssh',
    }
    exec { 'rssh-install':
      command => 'rpm -i /tmp/rssh-2.1.1-1.RH9.i386.rpm',
      path    => '/usr/sbin:/usr/bin:/sbin:/bin',
      require => Exec['rssh-download'],
      unless  => 'rpm -q rssh',
    }
  } else {
    package { $package:
      ensure => present,
      before => File[$config_file],
    }
  }
  file { $config_file:
    ensure  => file,
    mode    => $config_mode,
    content => template('rssh/rssh.conf.erb'),
  }
}
