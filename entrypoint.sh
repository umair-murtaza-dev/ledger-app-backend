#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid
# Then exec the container's main process (what's set as CMD in the Dockerfile).

if [ "$RAILS_ENV" = "production" ]; then
  rake db:migrate RAILS_ENV=production
else
  rake db:migrate
fi

exec "$@"
