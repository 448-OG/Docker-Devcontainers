#!/bin/bash

set -e  # Exit on error

CONFIG_DIR=/root/base

echo "[INFO] Initializing... Installing the Rust compiler"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
echo "[Info: Done installing Rust compiler"]

echo "[INFO] Step 1: Installing sccache..."
cargo install sccache
echo "[INFO] Step 1 completed."

echo "[INFO] Step 2: Configuring Cargo with sccache and mold..."
cat <<EOF > $HOME/.cargo/config.toml
[build]
rustc-wrapper = "/root/.cargo/bin/sccache"

[target.'cfg(target_os = "linux")']
rustflags = ["-C", "link-arg=-fuse-ld=mold"]
EOF
echo "[INFO] Cargo config written to $HOME/.cargo/config.toml"
echo "[INFO] Step 2 completed."

echo "[INFO] Step 3: Update rust to latest stable version"
rustup update stable
echo "[INFO] Step 3 completed."

echo "[INFO] Step 4: Installing additional Rust tools (cargo-binstall, nu, bat)..."
if cargo install cargo-binstall ;
then
    cargo binstall bat nu cargo-deny cargo-watch starship cargo-make cargo-update -y
else
    cargo install bat nu cargo-deny cargo-watch starship cargo-make
fi
echo "[INFO] Step 4 completed."

echo "[INFO] Add Rust path to nushell config written to $HOME/.config/nushell/config.nu"
mkdir -p $HOME/.config/nushell/
touch $HOME/.config/nushell/config.nu
cat <<'EOF' >> $HOME/.config/nushell/config.nu

$env.PATH = ($env.PATH | split row (char esep) | prepend '/root/.cargo/bin')
EOF
echo "[INFO] completed."

echo "[INFO] All steps completed successfully."