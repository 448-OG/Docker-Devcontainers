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

alias upgradable = sudo apt list --upgradable
alias update = sudo apt update
alias upgrade = sudo apt upgrade
alias dist_upgrade = sudo apt dist-upgrade
alias cargo_install_path = cargo install --path .
alias install_update = cargo install-update -a
alias check_watch = cargo watch -c -w src -w Cargo.toml -s "RUST_LOG=trace cargo check"
alias watch_debug = cargo watch -c -w src -w Cargo.toml -s "RUST_LOG=debug cargo run"
alias watch_trace = cargo watch -c -w src -w Cargo.toml -s "RUST_LOG=trace cargo run"
alias watch_info = cargo watch -c -w src -w Cargo.toml -s "RUST_LOG=info cargo run"

def watch_debug_example [value: string] {
    cargo watch -c -w src -w Cargo.toml -w $"examples/($value).rs" -s $"RUST_LOG=debug cargo run --example ($value)"
}

def watch_trace_example [value: string] {
    cargo watch -c -w src -w Cargo.toml -w $"examples/($value).rs" -s $"RUST_LOG=trace cargo run --example ($value)"
}

def watch_info_example [value: string] {
    cargo watch -c -w src -w Cargo.toml -w $"examples/($value).rs" -s $"RUST_LOG=info cargo run --example ($value)"
}

alias watch_error = cargo watch -c -w src -w Cargo.toml -s "RUST_LOG=error cargo run"
alias test_watch = cargo watch -c -w src -w Cargo.toml -s "RUST_LOG=trace cargo test"
alias test_watch_all_features = cargo watch -c -w src -w Cargo.toml -s "RUST_LOG=trace cargo test --verbose --all-features"

$env.PATH = ($env.PATH | split row (char esep) | prepend '/root/.cargo/bin')
EOF
echo "[INFO] completed."

echo "[INFO] All steps completed successfully."
