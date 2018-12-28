#!/usr/bin/env python
import logging
import sys

s = """
Personalities : [raid1]
md1 : active raid1 sdc[1]
      1953383360 blocks super 1.2 [2/1] [_U]

md2 : active raid1 sda1[0] sdb1[1]
      976630336 blocks super 1.2 [2/2] [UU]


"""

logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.INFO)


def get_inner(e):
    return e.strip('[').strip(']').split('/')


def detect_faulty_md(s):
    lines = s.split('\n')
    fault = False
    for idx, line in enumerate(lines):
        if line.startswith('md'):
            mdline = lines[idx+1]
            elems = mdline.split()[-2:]
            e1, e2 = elems
            online = get_inner(e2)
            if '_' in online:
                log.info('Fault elem: %s', online)
                fault = True
                break
            num = map(int, get_inner(e1))
            if num[0] != num[1]:
                log.info('Fault elem: %s', elems)
                fault = True
                break
    return fault


def read_proc_mdstat():
    with open('/proc/mdstat') as fo:
        return fo.read()


if __name__ == '__main__':
    mdstat = read_proc_mdstat()
    fault = detect_faulty_md(mdstat)
    if fault:
        sys.exit(1)
