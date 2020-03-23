FROM ruby:2.6.5-alpine

ENV PORT=4567

WORKDIR /app

ADD Gemfile* /app/

RUN bundle install --without development test

COPY . $APP_HOME

EXPOSE $PORT

CMD ["bundle", "exec", "ruby", "app.rb"]
