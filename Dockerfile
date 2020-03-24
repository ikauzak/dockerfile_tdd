FROM ruby:2.4.1-alpine
LABEL maintainer="brunokazuaki@gmail.com"

COPY Gemfile Gemfile.lock ./

RUN apk add --update --no-cache build-base && bundle install

ENTRYPOINT ["rspec"]
CMD ["-h"]
