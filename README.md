Installation / Upgradation of MariaDB 10.4
============================================

* MariaDB 10.3+ onwards JSON support enabled.

Repository doesn't allow us to upgrade recent version due to support for version which we're are using not officially supported version from package maintainer.

So in that cases we need to build binary RPM or source code installation method to upgrade MariaDB version.

Also mariadb Source code providing option to build binary through CMake Method, so here we're going to look into build those binary RPM and install it further.

Download Source Code
-------------------------------

- Download the latest Stable Source Code of MariDB for installation.

```
wget https://downloads.mariadb.org/interstitial/mariadb-10.4.8/source/mariadb-10.4.8.tar.gz
```

- Where-as MariaDB 10.4.x required galera-4(galera-26.4.2) as minimum 
required version to install, so download galera-4 source code as well with URL mentioned below.

```
wget http://nyc2.mirrors.digitalocean.com/mariadb/mariadb-10.4.8/galera-26.4.2/src/galera-26.4.2.tar.gz
```

Building RPM of Galera-4
-------------------------------

- Install dependencies to build galera-4

```
yum -y install boost-devel check-devel glibc-devel openssl-devel scons
```

- Extract the source code and enter into the directory

```
cd /usr/local/src/
tar -zxf galera-26.4.2.tar.gz
cd galera-26.4.2/
```

- Follow these steps to build galera-4(galera-26.4.2) binary RPM

```
scons
./scripts/build.sh
./scripts/build.sh -p
```

Installation of Galera-4
------------------------------------
- Once after successful execution of build script from above steps produce the binary RPM in the same folder. 
Install using rpm -ivh command to install the same.

```
rpm -ivh galera-4-26.4.2-1.fc23.fc23.x86_64.rpm
```

Now we're ready to install mariaDB-10.4.


Building binary RPM of MariaDB
------------------------------------------

- Extract source code and enter into mariadb source code directory

```
cd /usr/local/src/
tar -zxf mariadb-10.4.8.tar.gz
```

- Create the build directory and enter into build directory.

```
mkdir -p /usr/local/src/mariadb-build/
cd /usr/local/src/mariadb-build/
```

- Run CMAKE command to build the binary into mariadb-build folder.

```
cmake -DRPM=fedora ../mariadb-10.4.8
```

- Build binary RPM using make command mentioned below.

```
make package
```

- Once after successful execution of make commmand binary RPM's available in the build directory itself.


Installation of MariaDB 10.4
---------------------------------------

Installation of MariaDB required sequence of RPM of install all dependencies at the same time. 
But upgradation of MariaDB required extreme caution to avoid data loss.

- Take Necessary backup of mysql folder level. For safety reason take SQL dump as well.

```
cp -r /var/lib/mysql
```

- Erase existing version of mariaDB if there any. Need to erase complete package which includes client,common,devel,connect-engine etc.

```
yum remove mariadb-server mariadb-common mariadb-client
```

- Install RPM in the same order or install all those RPM at the same time to avoid dependencies error within mariadb itself.

```
rpm -ivh MariaDB-10.4.8-fedora-x86_64-common.rpm
rpm -ivh MariaDB-10.4.8-fedora-x86_64-client.rpm
rpm -ivh MariaDB-10.4.8-fedora-x86_64-connect-engine.rpm
rpm -ivh MariaDB-10.4.8-fedora-x86_64-server.rpm
rpm -ivh MariaDB-10.4.8-fedora-x86_64-devel.rpm
```

It may throw some error like selinux, it's usual when selinux is disabled.


- Once after successful installation need to upgrade the table to work with latest mariadb version. 
Execute mentioned below command to update the existing database.

```
mysql_upgrade -uroot -p
```

It would show the list of tables from each database status whether upgrade is successful or not. Also it would throw some notice as converted to longtext when varchar length is higher than limit.

