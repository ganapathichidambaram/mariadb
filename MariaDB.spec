# Restore old style debuginfo creation for rpm >= 4.14.
%undefine _debugsource_packages
%undefine _debuginfo_subpackages

# -*- rpm-spec -*-
BuildRoot:      %_topdir/mariadb-10.5.4
Summary:        MariaDB: a very fast and robust SQL database server
Name:           MariaDB
Version:        10.5.4
Release:        <RELEASE>%{?dist}
License:        GPLv2
Group:          Applications/Databases
Vendor:         MariaDB Foundation

Source: MariaDB-10.5.4.tar.gz
BuildRequires: gawk bison boost-devel coreutils checkpolicy binutils cmake gcc-c++ gcc glibc-devel make libcurl-devel ncurses-devel systemtap-sdt-devel libevent-devel flex glibc-common git groff-base tar libaio-devel cracklib-devel zlib-devel xz-devel pcre2-devel systemd-devel java-1.8.0-openjdk java-1.8.0-openjdk-headless krb5-devel libxml2-devel libxml2 unixODBC-devel unixODBC openssl-devel pam-devel readline-devel ruby snappy-devel thrift-devel

%if (0%{?fedora} > 28 || 0%{?rhel} > 7)
BuildRequires: libxcrypt-devel pkgconf-pkg-config
%else
BuildRequires: pkgconfig Judy-devel policycoreutils-python
%endif

%if (0%{?fedora} > 28 || 0%{?rhel})
BuildRequires: libzstd-devel
%endif

%define debug_package %{nil}

%define _rpmdir %_topdir/RPMS
%define _srcrpmdir %_topdir/SRPMS

%define _unpackaged_files_terminate_build 0


%define mysql_vendor MariaDB Foundation
%define mysqlversion 10.5.4
%define mysqlbasedir /usr
%define mysqldatadir /var/lib/mysql
%define mysqld_user  mysql
%define mysqld_group mysql
%define _bindir     /usr/bin
%define _sbindir    /usr/sbin
%define _sysconfdir /etc
%define restart_flag_dir %{_localstatedir}/lib/rpm-state/mariadb
%define restart_flag %{restart_flag_dir}/need-restart

%{?filter_setup:
%filter_provides_in \.\(test\|result\|h\|cc\|c\|inc\|opt\|ic\|cnf\|rdiff\|cpp\)$
%filter_requires_in \.\(test\|result\|h\|cc\|c\|inc\|opt\|ic\|cnf\|rdiff\|cpp\)$
%filter_from_provides /perl(\(mtr\|My::\)/d
%filter_from_requires /\(lib\(ft\|lzma\|tokuportability\)\)\|\(perl(\(.*mtr\|My::\|.*HandlerSocket\|Mysql\)\)/d
%filter_setup
}

%define ignore #

%if 0%{?centos}
%define mysql_rpm centos%{?centos}
%endif

%if 0%{?fedora}
%define mysql_rpm fedora%{?centos}
%endif

%if 0%{centos} == 7
%define mysql_rpm centos74
%endif


%description
MariaDB: a very fast and robust SQL database server

It is GPL v2 licensed, which means you can use the it free of charge under the
conditions of the GNU General Public License Version 2 (http://www.gnu.org/licenses/).

MariaDB documentation can be found at https://mariadb.com/kb
MariaDB bug reports should be submitted through https://jira.mariadb.org

# This is a shortcutted spec file generated by CMake RPM generator
# we skip _install step because CPack does that for us.
# We do only save CPack installed tree in _prepr
# and then restore it in build.
%prep
%setup -c


%build
mkdir cpack_rpm_build_dir
cd cpack_rpm_build_dir
cmake  -DRPM=%{mysql_rpm} -DCMAKE_BUILD_TYPE=Release -DBUILD_CONFIG=mysql_release -DWITH_SSL=system -DCPACK_PACKAGING_INSTALL_PREFIX=/ ../mariadb-10.5.4
make %{?_smp_mflags}
#make package
#p build

%install

cd cpack_rpm_build_dir
cpack -G RPM
mv *.rpm %_rpmdir/%{_arch}/

%clean

%changelog
* Tue Jul 21 2020 Ganapathi Chidambaram <ganapathi.rj@gmail.com> - 10.5.4-1%{?dist}
  Generated by CPack RPM (no Changelog file were provided)