# 1. Switch to main branch
git checkout main

# 2. Pull latest main (in case there are remote changes)
git pull origin main

# 3. Merge dev-bedrock-integration into main
git merge dev-bedrock-integration

# 4. Push main to trigger production deployment
git push origin main

# 5. Switch back to dev-bedrock-integration to continue working
git checkout dev-bedrock-integration

# 6. Continue developing on dev-bedrock-integration as normal