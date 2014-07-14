# == Class: aerospike
#
# Full description of class aerospike here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { aerospike: }
#
# === Authors
#
# Author Name <alex.kalyvitis@gmail.com>
#
# === Copyright
#
# Copyright 2014 Alex Kalyvitis
#
class aerospike (
    $version      = "3.3.8",
    $download_dir = "/usr/local/src",
) {
    Exec { path => ["/usr/local/bin", "/usr/bin", "/usr/bin", "/bin", "/sbin"] }

    package { ["wget"]: }

    $src = "http://www.aerospike.com/artifacts/aerospike-server-community/$version/aerospike-server-community-$version-ubuntu12.04.tgz"
    $dest = "$download_dir/aerospike-server-community-$version-ubuntu12.04"

    exec { "aerospike-download":
        command => "wget -O $dest.tgz $src",
        creates => "$dest.tgz",
        require => Package['wget'],
    } ->
    exec { "aerospike-extract":
        command => "tar -C $download_dir -xzf $dest.tgz",
        onlyif  => "test -f $dest.tgz",
    } ->
    exec { "aerospike-install-server":
        command => "dpkg -i $dest/aerospike-server-community-$version.ubuntu12.04.x86_64.deb",
    } ->
    exec { "aerospike-install-tools":
        command => "dpkg -i $dest/aerospike-tools-$version.ubuntu12.04.x86_64.deb",
    }
}