#!/usr/bin/env python

# Copyright (c) 2010 Marcin Krol <mrkafk@gmail.com>.  All rights reserved.

# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose and without fee is hereby granted,
# provided that the above copyright notice appear in all copies and that
# both that copyright notice and this permission notice appear in
# supporting documentation.

# MARCIN KROL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS,
# IN NO EVENT SHALL MARCIN KROL BE LIABLE FOR ANY SPECIAL, INDIRECT
# OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
# WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# This software is licensed under MIT License:
# http://opensource.org/licenses/mit-license.php


import re
import sys

def find_ip_mac(hname, fname):
    with open(fname) as fo:
        cnt = ''.join(fo.readlines())
        re_s = r"%s.+\{[^\}]+hardware\s+ethernet\s+([\w\:]+)[^\}]+fixed-address\s+([\d\.]+)" % hname
        #re_s = r"%s.+\{([^\}]+?)\}" % hname
        a=re.search(re_s, cnt, re.MULTILINE)
        if a:
            print a.group(1), a.group(2)
        

if __name__ == "__main__":
    hname = sys.argv[1]
    find_ip_mac(hname, '/etc/dhcp/dhcpd.conf')
    
