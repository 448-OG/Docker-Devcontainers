#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

CONFIG_DIR=/root/base

bash "$CONFIG_DIR/system-packages.sh"
bash "$CONFIG_DIR/mold.sh"
bash "$CONFIG_DIR/rust-packages.sh"