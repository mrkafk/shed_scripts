#!/bin/bash

ssh -v -C -o CompressionLevel=9 -p 52300 -L 127.0.0.1:14000:127.0.0.1:5432 root@host.name

