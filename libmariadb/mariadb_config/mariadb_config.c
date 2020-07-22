#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <mariadb_version.h>

static char *mariadb_progname;

#define INCLUDE "-I/usr/include/mysql -I/usr/include/mysql/mysql"
#define LIBS    "-L/usr/lib64/ -lmariadb"
#define LIBS_SYS "-lz -ldl -lm -lpthread -lssl -lcrypto"
#define CFLAGS  INCLUDE
#define VERSION "10.5.4"
#define CC_VERSION "3.1.9"
#define PLUGIN_DIR "/usr/lib64/mysql/plugin"
#define SOCKET  "/var/lib/mysql/mysql.sock"
#define PORT "3306"
#define TLS_LIBRARY_VERSION "OpenSSL 1.0.2k"

#if defined(SOLARIS) || defined(__sun)
#define OPT_STRING_TYPE (char *)
#else
#define OPT_STRING_TYPE
#endif
static struct option long_options[]=
{
  {OPT_STRING_TYPE "cflags", no_argument, 0, 'a'},
  {OPT_STRING_TYPE "help", no_argument, 0, 'b'},
  {OPT_STRING_TYPE "include", no_argument, 0, 'c'},
  {OPT_STRING_TYPE "libs", no_argument, 0, 'd'},
  {OPT_STRING_TYPE "libs_r", no_argument, 0, 'e'},
  {OPT_STRING_TYPE "libs_sys", no_argument, 0, 'l'},
  {OPT_STRING_TYPE "version", no_argument, 0, 'f'},
  {OPT_STRING_TYPE "cc_version", no_argument, 0, 'g'},
  {OPT_STRING_TYPE "socket", no_argument, 0, 'h'},
  {OPT_STRING_TYPE "port", no_argument, 0, 'i'},
  {OPT_STRING_TYPE "plugindir", no_argument, 0, 'j'},
  {OPT_STRING_TYPE "tlsinfo", no_argument, 0, 'k'},
  {NULL, 0, 0, 0}
};

static const char *values[]=
{
  CFLAGS,
  NULL,
  INCLUDE,
  LIBS,
  LIBS,
  LIBS_SYS,
  VERSION,
  CC_VERSION,
  SOCKET,
  PORT,
  PLUGIN_DIR,
  TLS_LIBRARY_VERSION
};

void usage(void)
{
  int i=0;
  puts("Copyright 2011-2019 MariaDB Corporation AB");
  puts("Get compiler flags for using the MariaDB Connector/C.");
  printf("Usage: %s [OPTIONS]\n", mariadb_progname);
  while (long_options[i].name)
  {
    if (values[i])
      printf("  --%-12s  [%s]\n", long_options[i].name, values[i]);
    i++;
  }
}


int main(int argc, char **argv)
{
  int c;
  mariadb_progname= argv[0];

  if (argc <= 1)
  {
    usage();
    exit(0);
  }

  while(1)
  {
    int option_index= 0;
    c= getopt_long(argc, argv, "abcdefghijkl", long_options, &option_index);

    switch(c) {
    case 'a':
      puts(CFLAGS);
      break;
    case 'b':
      usage();
      break;
    case 'c':
      puts(INCLUDE);
      break;
    case 'd':
    case 'e':
      puts(LIBS);
      break;
    case 'f':
      puts(VERSION);
      break;
    case 'g':
      puts(CC_VERSION);
      break;
    case 'h':
      puts(SOCKET);
      break;
    case 'i':
      puts(PORT);
      break;
    case 'j':
      puts(PLUGIN_DIR);
      break;
    case 'k':
      puts(TLS_LIBRARY_VERSION);
      break;
    case 'l':
      puts(LIBS_SYS);
      break;
    default:
      exit((c != -1));
    }
  }

  exit(0);
}

