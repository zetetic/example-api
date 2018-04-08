FROM ruby:2.3.3

WORKDIR /app

RUN gem install thin

ADD config.ru /app/config.ru

EXPOSE "3000"

CMD ["thin", "-p", "3000", "-R", "config.ru", "-D", "-V", "start"]
