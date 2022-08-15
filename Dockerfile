ARG RUBY_VERSION=3.0.0
FROM ruby:$RUBY_VERSION-slim-buster

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Uncomment this line if you store Bundler settings in the project's root
# ENV BUNDLE_APP_CONFIG=.bundle

# Create a directory for the app code
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME

RUN gem update bundler
RUN bundle install --without development test --jobs 5