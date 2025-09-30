# Deployment Guide for Rails API with Private Gem

This Rails API depends on a private gem (`json_rb`) that is not available on rubygems.org. This guide explains how to properly prepare and deploy the application using Docker.

## Development vs Production

### Development Setup
In development, the Gemfile uses a path dependency to the local gem source:
```ruby
gem "json_rb", path: "../"
```

This allows you to make changes to the gem and immediately see them reflected in the Rails app.

### Production Setup
For production/Docker deployment, we need to:
1. Build the gem into a `.gem` package
2. Vendor the gem in `vendor/cache/`
3. Update the Gemfile to reference the gem by version instead of path
4. Update Gemfile.lock to match

## Deployment Workflow

### Pre-Build Steps (before `docker build`)

```bash
# 1. Build the gem from the root of the repository
gem build json_rb.gemspec
# This creates: json_rb-0.1.0.gem

# 2. Switch to production branch (or create deployment branch)
git checkout -b production  # or checkout existing production branch

# 3. Add the built gem to vendor/cache
mkdir -p api_rails/vendor/cache
cp json_rb-0.1.0.gem api_rails/vendor/cache/

# 4. Update Gemfile in api_rails/
cd api_rails
# Edit Gemfile: Change this line:
#   gem "json_rb", path: "../"
# To:
#   gem "json_rb", "0.1.0"

# 5. Update Gemfile.lock to reflect the change
bundle lock --update json_rb

# 6. Commit production changes
git add Gemfile Gemfile.lock vendor/cache/
git commit -m "Prepare for production deployment v0.1.0"

# 7. Build Docker image
cd ..
docker build -f api_rails/Dockerfile -t json-rb-api-rails .

# 8. Run the container
docker run -p 8000:8000 json-rb-api-rails
```

## Why This Approach?

### The Problem
- During development, we use `gem "json_rb", path: "../"` to reference local source
- In Docker, we can't use path dependencies because the gem source isn't in the build context
- We need to package the gem and include it in a way Bundler can use

### Why vendor/cache?
- `vendor/cache` is the standard Rails/Bundler location for vendored gems
- `bundle install --local` will use gems from vendor/cache without hitting rubygems.org
- This is the same mechanism used by `bundle package` for offline deployments
- No network access needed during Docker build

### Why a separate branch?
- The Gemfile and Gemfile.lock are different between development and production
- We can't modify these files during Docker build due to Bundler's frozen mode (`BUNDLE_DEPLOYMENT=1`)
- A production branch keeps deployment configuration separate from development
- You can merge changes from main, rebuild the gem, and update the production branch

## Repository Structure

```
json-rb/
├── lib/                    # json_rb gem source
├── json_rb.gemspec
├── Gemfile                 # Root Gemfile for gem development
├── api_rails/
│   ├── Gemfile            # Rails app Gemfile (path: "../" in dev, version in prod)
│   ├── Gemfile.lock       # Must match Gemfile
│   ├── vendor/
│   │   └── cache/         # Vendored gems for production (only in production branch)
│   │       └── json_rb-0.1.0.gem
│   ├── Dockerfile
│   └── DEPLOYMENT.md      # This file
```

## Branch Strategy

### main branch
- Development configuration
- `gem "json_rb", path: "../"` in Gemfile
- No vendor/cache directory needed

### production branch (or release tags)
- Production/deployment configuration
- `gem "json_rb", "0.1.0"` in Gemfile
- Includes `vendor/cache/json_rb-0.1.0.gem`
- Gemfile.lock updated to match

## Simplified Dockerfile

Because we've prepared everything before building, the Dockerfile can be simple:

```dockerfile
# Copy Gemfile and vendored gems
COPY api_rails/Gemfile api_rails/Gemfile.lock ./
COPY api_rails/vendor/cache ./vendor/cache

# Install from vendor/cache (no external network needed)
RUN bundle install --local
```

## Alternative: Environment-Based Gemfile

Instead of maintaining separate branches, you could use an environment variable in the Gemfile:

```ruby
# In api_rails/Gemfile
if ENV['DOCKER_BUILD']
  gem "json_rb", "0.1.0"
else
  gem "json_rb", path: "../"
end
```

Then in Dockerfile:
```dockerfile
RUN DOCKER_BUILD=1 bundle install --local
```

However, you'd still need to vendor the gem and update Gemfile.lock before building.

## Troubleshooting

### "Could not find gem 'json_rb'"
- Make sure the gem is in `vendor/cache/`
- Verify the version in Gemfile matches the gem filename
- Check that `bundle install --local` is being used

### "The gemspecs for path gems changed"
- This means Gemfile still references `path: "../"` but you're in frozen mode
- Make sure you've updated the Gemfile to use version instead of path
- Ensure Gemfile.lock was updated with `bundle lock --update json_rb`

### "Frozen mode" errors
- Don't try to modify Gemfile during Docker build
- All Gemfile changes must be committed before `docker build`
- The `BUNDLE_DEPLOYMENT=1` environment variable enforces this

## Notes

- Remember to rebuild the gem and update vendor/cache whenever json_rb code changes
- The version number in the Gemfile must match the gem filename exactly
- For real deployments, use proper semantic versioning for the gem
- Consider using Git tags on the production branch for each deployment