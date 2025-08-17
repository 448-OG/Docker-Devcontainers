echo "[INFO]: Installing nvm, npm, Nodejs, pnpm & yarn..."

echo "[INFO] Step 1: Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
source "$HOME/.nvm/nvm.sh"
echo "[INFO] Step 1: Done installing nvm..."

echo "[INFO] Step 2: Installing Nodejs v22 & npm..."
# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v # Should print "v22.18.0".
nvm current # Should print "v22.18.0".

# Verify npm version:
npm -v # Should print "10.9.3".
echo "[INFO] Step 2: Done installing Nodejs & npm..."

echo "[INFO] Step 3: Install corepack..."
npm install -g corepack
echo "[INFO] Step 3: Done installing corepack..."


echo "[INFO] Step 4: Installing pnpm..."
corepack enable pnpm
echo "[INFO] Step 4: Done installing pnpm..."
