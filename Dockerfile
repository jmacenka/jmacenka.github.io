FROM jekyll/jekyll

COPY Gemfile* ./

RUN gem install jekyll bundler

RUN bundle

ENTRYPOINT [ "jekyll" ]

CMD [ "build" ]