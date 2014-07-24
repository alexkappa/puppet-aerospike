# == Class: aerospike
#
# Installs the Aerospike server.
#
# === Parameters
#
# Document parameters here.
#
# [*version*]
#   The version of aerospike server to download.
#
# [*download_dir*]
#   Where to store downloaded packages.
#
# === Examples
#
#  class { aerospike:
#   version      => "3.3.8",
#   download_dir => "/usr/local/src",
#  }
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

    file { "/etc/aerospike/aerospike.conf":
        content => template("aerospike/aerospike.conf.erb"),
        owner   => root,
        group   => root,
        mode    => 644,
    }
}