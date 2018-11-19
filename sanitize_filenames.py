#!/usr/bin/env python

__author__ = 'mrkafk@gmail.com'

import os

from string import ascii_uppercase, ascii_letters, ascii_lowercase, digits


allowed_chars = ascii_lowercase + ascii_uppercase + digits + '_-.'


def sanitize_str(s):
    # s = s.replace(""" """, '_')
    # return s
    return ''.join([x if x in allowed_chars else '_' for x in s])


def fnames():
    flist = [x for x in os.listdir(os.getcwd()) if os.path.isfile(x)]
    for fname in flist:
        s = sanitize_str(fname)
        os.rename(fname, s)
    print flist


if __name__ == '__main__':
    fnames()

