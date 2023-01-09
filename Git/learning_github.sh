# UBUNTU: first of all install GCM https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git#git-credential-manager

wget https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.886/gcm-linux_amd64.2.0.886.deb
sudo dpkg -i gcm-linux_amd64.2.0.886.deb
git-credential-manager configure
git config --global credential.credentialStore secretservice

# create a new repository on the command line

echo "# testing_my_knowledge" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/txominvs/testing_my_knowledge.git
git push -u origin main

# …or push an existing repository from the command line

git remote add origin https://github.com/txominvs/testing_my_knowledge.git
git branch -M main
git push -u origin main

