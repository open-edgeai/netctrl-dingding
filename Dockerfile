FROM laixinyi/rails
#RUN mkdir /project
COPY Gemfile Gemfile.lock /project/
RUN bundle install
WORKDIR /project
COPY . /project