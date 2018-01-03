class role::tfs_wsus {

  require profile::base
  include profile::wsus
  include profile::tfs
}
