#!/usr/bin/env python3

# Copyright (c) 2020 Marcin Krol <mrkafk@gmail.com>.  All rights reserved.

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


import sys

def find_requirements_file(fname='requirements.txt'):
    fname = 'requirements.txt'
    if len(sys.argv) > 1:
        fname = sys.argv[1]
    try:
        fo = open(fname, 'r')
    except OSError as exc:
        print(exc)
        sys.exit(1)
    return fo

def strip_vers(fo):
    lines = [line.split('=') for line in fo]
    return [_f for _f in [line[0] for line in lines] if _f]

def write_reqs_nover():
    fo = find_requirements_file()
    vers = strip_vers(fo)
    outfname = 'requirements_nover.txt'
    with open(outfname, 'w') as fo:
        fo.write('\n'.join(vers))
    print('Wrote output to', outfname, file=sys.stderr)

if __name__ == '__main__':
    write_reqs_nover()
