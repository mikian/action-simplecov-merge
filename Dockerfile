FROM ruby:3.3

COPY Gemfile Gemfile.lock ./
RUN bundle

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
