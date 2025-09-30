# Dockerfile for CLI
FROM ruby:3.3.9
WORKDIR /app
# Copy Gemfile and Gemfile.lock from project root
COPY ../Gemfile ../Gemfile.lock ./
RUN bundle install
# Copy all project files (except Dockerfile itself)
COPY .. .
# Set entrypoint to the CLI
ENTRYPOINT ["ruby", "bin/cli"]
