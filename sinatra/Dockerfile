FROM ruby:2.6
WORKDIR '/app'

COPY Gemfile* ./
RUN gem install bundler
RUN bundle install
COPY . .
CMD ["bundle", "exec", "ruby", "sinatra.rb"]
