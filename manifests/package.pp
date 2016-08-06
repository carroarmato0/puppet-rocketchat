class rocketchat::package {

  if $::rocketchat::package {
    package { $::rocketchat::package:
      ensure => installed,
    }
  }

}
