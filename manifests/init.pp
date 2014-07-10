class javadev {

    $defpath = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin"
    $modpath = 'puppet:///modules/javadev'

    case $::operatingsystem {
        FreeBSD: {
            $manualant = false

            include pkgng

            $packages = [
                'openjdk',
                'openjdk6',
                'apache-ant',
            ]

            $pkg_provider = pkgng
        }
        centos: {
            $packages = [
                'java-1.6.0-openjdk',
                'java-1.6.0-openjdk-devel',
                'java-1.7.0-openjdk',
                'java-1.7.0-openjdk-devel',
            ]

            $manualant = true

            $pkg_provider = yum
        }
        default: {
            
            $manualant = false

            $packages = [
                'openjdk',
                'openjdk6',
                'apache-ant',
            ]

            $pkg_provider = pkgng
        }
    }

    # Install packages
    package { $packages:
        ensure   => installed,
        provider => $pkg_provider
    }

    if $::operatingsystem == 'centos' {
        package { ['ant', 'ant-apache-regexp']:
            ensure   => purged,
        }
    }

    # Install ant manually
    if $manualant  {
        $ant_url = "http://mirror.cogentco.com/pub/apache//ant/binaries"
        $ant_version = "apache-ant-1.9.4"

        exec { 'fetch-ant':
            command => "curl -o $ant_version-bin.tar.gz $ant_url/$ant_version-bin.tar.gz",
            user    => 'root',
            cwd     => '/root',
            unless  => "ls /root/$ant_version-bin.tar.gz",
            path    => $defpath
        }

        exec { 'extract-ant':
            command => "tar xzf /root/$ant_version-bin.tar.gz",
            user    => 'root',
            cwd     => '/opt',
            unless  => "ls -d /opt/$ant_version",
            path    => $defpath,
            require => Exec['fetch-ant']
        }

        file { 'ant-env':
            path => '/etc/profile.d/ant.sh',
            ensure => file,
            mode => 0644,
            owner => 'root',
            group => 'root',
            source => "$modpath/ant.sh"
        }
    }

    #TODO: install latest ivy
}
