echo "[INFO]: Installing nvm, npm, Nodejs, pnpm & yarn..."

echo "[INFO] Step 1: Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
source "$HOME/.nvm/nvm.sh"
echo "[INFO] Step 1: Done installing nvm..."

echo "[INFO] Step 2: Installing Nodejs v24 & npm..."
# Download and install Node.js:
nvm install 24

# Verify the Node.js version:
node -v 
nvm current

# Verify npm version:
npm -v 
echo "[INFO] Step 2: Done installing Nodejs & npm..."

echo "[INFO] Step 3: Install corepack..."
npm install -g corepack
echo "[INFO] Step 3: Done installing corepack..."


echo "[INFO] Step 4: Installing pnpm..."
corepack enable pnpm
echo "[INFO] Step 4: Done installing pnpm..."


echo "[INFO] Add NVM Nodejs path to nushell config written to $HOME/.config/nushell/config.nu"
cat <<'EOF' >> $HOME/.config/nushell/config.nu


let node_bin = (
    ls /root/.nvm/versions/node
    | insert base {|r| $r.name | path basename }
    | where base =~ '^v\d+\.\d+\.\d+$'
    | insert ver {|r|
        $r.base
        | str replace --regex '^v' ''
        | split row '.'
        | each {|n| $n | into int }
    }
    | sort-by ver
    | last
    | get base
    | path join /root/.nvm/versions/node $in bin
)

$env.PATH = ($env.PATH | split row (char esep) | prepend $node_bin)

EOF
echo "[INFO] completed."
