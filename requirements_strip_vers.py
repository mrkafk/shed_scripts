#!/usr/bin/env python

import sys

def find_requirements_file():
    try:
        fo = open('requirements.txt', 'rb')
    except OSError:
        print >>sys.stderr, 'File requirements.txt not found'
        sys.exit(1)
    return fo

def strip_vers(fo):
    lines = [line.split('=') for line in fo]
    return filter(None, [line[0] for line in lines])

def write_reqs_nover():
    fo = find_requirements_file()
    vers = strip_vers(fo)
    outfname = 'requirements_nover.txt'
    with open(outfname, 'wb') as fo:
        fo.write('\n'.join(vers))
    print >>sys.stderr, 'Wrote output to', outfname

if __name__ == '__main__':
    write_reqs_nover()
