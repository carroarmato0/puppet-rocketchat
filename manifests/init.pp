class rocketchat (
  $root_url       = $::rocketchat::root_url,
  $mongo_url      = $::rocketchat::mongo_url,
  $mail_url       = $::rocketchat::mail_url,
  $manage_service = $::rocketchat::manage_service,
  $package        = $::rocketchat::package,
) inherits rocketchat::params {

  include rocketchat::package
  include rocketchat::config
  include rocketchat::service

}
