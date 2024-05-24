#!/bin/bash
set -e

# Ensure the /workspace directory is clean
rm -rf /workspace
mkdir /workspace

# Clone the repository
git clone https://github.com/nazar-kh/ci-cd-testing.git /workspace
cd /workspace

# Checkout the branch with the latest push
git checkout $GITHUB_REF

# Run the CI/CD workflow steps

# Checkout Code
echo "Checking out code..."
git checkout HEAD

# Install Node
echo "Installing Node.js..."
# Already handled by Dockerfile

# Install Dependencies
echo "Installing dependencies..."
npm install

# Build Project
echo "Building project..."
npm run build

# Upload artifact to enable deployment
echo "Uploading artifact..."
mkdir -p /artifacts
cp -r ./dist /artifacts

# Deploy to GitHub Pages
echo "Deploying to GitHub Pages..."
# Log in to GitHub CLI using the token, then unset the GITHUB_TOKEN environment variable
echo $GITHUB_TOKEN | gh auth login --with-token
unset GITHUB_TOKEN
gh pages publish ./dist --repo https://github.com/nazar-kh/ci-cd-testing.git --branch gh-pages
