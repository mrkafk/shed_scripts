#!/bin/bash


SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

function activate_ve () {
  if [ -f ".jupyter_params" ]; then
      VE=$(cat .jupyter_params | grep -i 'virtualenv:' | awk '{print $2;}')
      if [ -f "$VE/bin/activate" ]; then
        echo "Activating $VE/bin/activate"
        source "$VE/bin/activate"
      else
        echo "Virtualenv $VE/bin/activate could not be activated. Abort."
        exit 1
      fi
    else
      echo "File .jupyter_params not found."
      exit 1
  fi
}

function get_port () {
  if [ -f ".jupyter_params" ]; then
    PORT=$(cat .jupyter_params | grep -i 'port:' | awk '{print $2;}')
    echo "$PORT"
  else
    echo "File .jupyter_params not found."
    exit 1
  fi
}

function jupyter_stop () {
  if [ -f ".jupyter_params" ]; then
    PORT=$(cat .jupyter_params | grep -i 'port:' | awk '{print $2;}')
    VE=$(cat .jupyter_params | grep -i 'virtualenv:' | awk '{print $2;}')
    PID=$(ps auxwww | grep "$VE/bin/jupyter-notebook" | grep "port $PORT" | grep -v grep | awk '{print $2};')
    set -x
    kill "$PID"
    set +x
  else
    echo "File .jupyter_params not found."
    exit 1
  fi
}

case "$1" in
  "start")
    activate_ve
    PORT=$(get_port)
    echo "Starting jupyter (port $PORT), log ./.jupyter_log"
    nohup jupyter notebook --port "$PORT" &> .jupyter_log &
    sleep 1
    cat .jupyter_log
    ;;
   "stop")
    jupyter_stop
    ;;
    "template")
    if [ ! -f '.jupyter_params' ]; then
      echo "Writing template .jupyter_params"
      cat <<EOF >.jupyter_params
virtualenv: ve
port: 8010
EOF
    else
      echo "File .jupyter_port present in current dir."
      exit 1
    fi
    ;;
  *)
  echo "Unknown command $1"
  echo "Usage:"
  echo "  start"
  echo "  stop"
  echo "  template"
  ;;
esac
