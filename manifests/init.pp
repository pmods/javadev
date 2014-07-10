class javadev {

    case $::operatingsystem {
        FreeBSD: {

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
                'ant',
                'ant-apache-regexp',
            ]

            $pkg_provider = yum
        }
        default: {
            
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

    #TODO: install latest ivy
}
