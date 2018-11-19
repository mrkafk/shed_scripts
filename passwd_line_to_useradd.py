#!/usr/bin/env python2

'''
Convert line from /etc/passwd to useradd command.
'''

import os
import sys

__author__ = 'mrkafk@gmail.com'


def pwdline2useradd(line):
    try:
        username, _, uid, gid, uid_info, home, shell = line.split(':')
    except ValueError:
        sys.stderr.write('Error parsing line: {}'.format(line))
        sys.exit(1)
    return 'useradd --uid {} --gid {} --comment {} --home-dir {} -m --shell {} {}'.format(uid, gid, uid_info, home, shell, username)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage:\n Specify user line from /etc/passwd as first argument')
        sys.exit(1)
    print(pwdline2useradd(sys.argv[1]))
