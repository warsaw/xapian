/** @file xapian-replicate.cc
 * @brief Replicate a database from a master server to a local copy.
 */
/* Copyright (C) 2008 Olly Betts
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
 * USA
 */

#include <config.h>

#include "replicatetcpclient.h"

#include <xapian.h>

#include "gnu_getopt.h"

#include <iostream>

using namespace std;

#define PROG_NAME "xapian-replicate"
#define PROG_DESC "Replicate a database from a master server to a local copy"

#define OPT_HELP 1
#define OPT_VERSION 2

static void show_usage() {
    cout << "Usage: "PROG_NAME" [OPTIONS] DATABASE\n\n"
"Options:\n"
"  -h, --host=HOST   host to connect to\n"
"  -p, --port=PORT   port to connect to\n"
"  -m, --master=DB   replicate database DB from the master\n"
"  -i, --interval=N  connect to master every N seconds\n"
"  --help            display this help and exit\n"
"  --version         output version information and exit" << endl;
}

int
main(int argc, char **argv)
{
    const struct option long_opts[] = {
	{"host",	required_argument,	0, 'h'},
	{"port",	required_argument,	0, 'p'},
	{"master",	required_argument,	0, 'm'},
	{"interval",	required_argument,	0, 'i'},
	{"help",	no_argument, 0, OPT_HELP},
	{"version",	no_argument, 0, OPT_VERSION},
	{NULL,		0, 0, 0}
    };

    string host;
    int port = 0;
    string masterdb;
    int interval = 0;

    int c;
    while ((c = gnu_getopt_long(argc, argv, "h:p:m:i:", long_opts, 0)) != EOF) {
	switch (c) {
	    case 'h':
		host.assign(optarg);
		break;
	    case 'p':
		port = atoi(optarg);
		break;
	    case 'm':
		masterdb.assign(optarg);
		break;
	    case 'i':
		interval = atoi(optarg);
		break;
	    case OPT_HELP:
		cout << PROG_NAME" - "PROG_DESC"\n\n";
		show_usage();
		exit(0);
	    case OPT_VERSION:
		cout << PROG_NAME" - "PACKAGE_STRING << endl;
		exit(0);
	    default:
		show_usage();
		exit(1);
	}
    }

    if (argc - optind != 1) {
	show_usage();
	exit(1);
    }

    // Path to the database to create/update.
    string dbpath(argv[optind]);

    try {
	while (true) {
	    ReplicateTcpClient client(host, port, 10000);
	    client.update_from_master(dbpath, masterdb);
	    sleep(interval);
	}
    } catch (const Xapian::Error &error) {
	cerr << argv[0] << ": " << error.get_description() << endl;
	exit(1);
    }
}