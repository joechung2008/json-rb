# Dockerfile for Roda API
FROM ruby:3.3.9
WORKDIR /app
# Copy Gemfile and Gemfile.lock from project root
COPY ../Gemfile ../Gemfile.lock ./
RUN bundle install
# Copy all project files (except Dockerfile itself)
COPY .. .
EXPOSE 8000
# Bind to 0.0.0.0 for external access
CMD ["bundle", "exec", "rackup", "api_roda/config.ru", "-p", "8000", "-o", "0.0.0.0", "-s", "webrick"]
