FROM ruby:3.3

COPY Gemfile Gemfile.lock ./
RUN bundle

COPY merge.rb /merge.rb

ENV COVERAGE_PATH /coverage
ENTRYPOINT ["ruby", "/merge.rb"]
