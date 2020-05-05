FROM ruby:2.6.3

LABEL maintainer="Radin <radin@instedd.org>"

# Updating nodejs version
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

# Install dependencies
RUN apt-get update && \
  apt-get install -y nodejs yarn postgresql-client && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /app
WORKDIR /app

# Install gem bundle
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler && \
  bundle install --jobs 20 --deployment --without development test

# Install the application
COPY . /app

# Generate version file if available
RUN if [ -d .git ]; then git describe --always > VERSION; fi

# Precompile assets
RUN bundle exec rake assets:precompile RAILS_ENV=production

ENV RAILS_LOG_TO_STDOUT=true
ENV RACK_ENV=production
ENV RAILS_ENV=production
EXPOSE 80

# Add scripts
COPY docker/database.yml /app/config/database.yml

CMD ["bundle", "exec", "puma", "-e", "production", "-b", "tcp://0.0.0.0:80"]