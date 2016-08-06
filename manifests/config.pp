class rocketchat::config {

  file { '/etc/rocketchat':
    ensure  => directory,
    mode    => '0644',
  }

  file { '/etc/rocketchat/rocketchat.conf':
    ensure  => file,
    mode    => '0644',
    content => template('rocketchat/configfile.erb'),
    notify  => Service['rocketchat'],
  }

}
