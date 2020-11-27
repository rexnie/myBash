#!/bin/bash

hg export -r "outgoing()" -o "%n-%m.patch"
