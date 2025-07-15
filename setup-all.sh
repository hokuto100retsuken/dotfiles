
#!/bin/bash

set -e

echo "Setting up dotfiles for $(uname -s)..."

# Calling the installation script
echo "Installing packages..."
bash setup-installs.sh

# Calling the dotfiles setup script
echo "Setting up dotfiles..."
bash setup-dotfiles.sh

echo "Setup completed successfully!"
