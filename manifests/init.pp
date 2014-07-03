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
