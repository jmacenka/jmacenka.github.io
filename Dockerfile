FROM debian:latest

COPY Gemfile* ./

RUN apt-get install clang make ruby-dev libffi-dev ruby-full build-essential zlib1g-dev -y && \
    echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc && \
    echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc && \
    source ~/.bashrc

RUN gem install jekyll bundler

RUN bundle

ENTRYPOINT [ "jekyll" ]

CMD [ "build" ]