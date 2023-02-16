FROM ruby:2.7.5
RUN apt-get update -qq && apt-get install -y vim nano
RUN mkdir /ledger
WORKDIR /ledger
COPY Gemfile /ledger/Gemfile
COPY Gemfile.lock /ledger/Gemfile.lock
RUN gem uninstall bundler
RUN gem install bundler -v 2.3.26
RUN bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java
RUN bundle lock --add-platform x86_64-linux
RUN bundle update --bundler

RUN bundle install
COPY . /ledger

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
RUN echo 'alias ll="ls -l"' >> ~/.bashrc
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
