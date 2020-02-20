#!/usr/bin/env python3

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
