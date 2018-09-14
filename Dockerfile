FROM ruby:alpine

MAINTAINER Jeremie CUADRADO <redbeard28>, based on Manfred Touron <m@42.am>, based on Simon Weis <docker@w3is.de>
########################################
#
#   Add some plugins
#
########################################

WORKDIR /dashboard

ENV GEM_HOME /dashboard/.bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN addgroup smashing \
    && adduser -S -G smashing smashing \
    && chown -R smashing:smashing /dashboard

RUN apk update && apk add make gcc g++ nodejs git

USER smashing

RUN gem install smashing bundler
RUN gem 'curb'
RUN gem 'json'

####################################################
# Confluence calendar plugin
RUN smashing install 350f00cd49c782157ee4

# MQTT Plugin
RUN smashing install ac36d16a5180c3d2032a

# Netatmo plugin
#RUN git clone https://github.com/olf/dashing_netatmo.git

# Shopify plugin
RUN smashing install 547b46be893f3cd6c62b077027cb3122 
####################################################

ONBUILD COPY . /dashboard
ONBUILD RUN bundle

EXPOSE 8080

ENTRYPOINT ["smashing"]
CMD ["start", "-p", "8080"]
