#!/bin/bash

git rev-list HEAD |                     # list commits
  xargs -n1 git ls-tree -rl |             # expand their trees
  sed -e 's/[^ ]* [^ ]* \(.*\)\t.*/\1/' | # keep only sha-1 and size
  sort -u |                               # eliminate duplicates
  awk '{ sum += $2 } END { print sum }'   # add up the sizes in bytes