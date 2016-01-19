FROM alpine:latest
MAINTAINER Vipin Madhavanunni <vipintm@gmail.com>
LABEL site="unwsolution.com" \
	version="1.0" \
	description="Jekyll Docker image"	\
	source="https://github.com/UNwS/jekyll-docker"

# Install all the dependencies for Jekyll
RUN apk add --update bash build-base libffi-dev zlib-dev libxml2-dev \
			libxslt-dev ruby ruby-dev ruby-io-console ruby-json \
			yaml nodejs git

# let avoide rdoc
RUN echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc

# Install bundler
RUN gem install bundler 

# lets install all required gems
RUN bundle config build.nokogiri --use-system-libraries 
RUN bundle config build.jekyll --no-rdoc
RUN bundle install

# lets clean
RUN find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem 

# Copy source
RUN mkdir -p /src
VOLUME ["/html"]
WORKDIR /html

# Jekyll runs on port 4000 by default
EXPOSE 4000

# Run jekyll serve
CMD ["ls"]
