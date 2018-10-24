#!/bin/bash


SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

if [ ! -d ~/.config/shed_scripts ]; then
  mkdir -p ~/.config/shed_scripts
  rm -f ~/.config/shed_scripts/bin &>/dev/null
  ln -s "$SCRIPTDIR" ~/.config/shed_scripts/bin
fi

