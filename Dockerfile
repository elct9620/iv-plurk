FROM ruby:2.6 AS build

ARG GEM_PKG_PATH

COPY $GEM_PKG_PATH /root
RUN gem install /root/$(basename $GEM_PKG_PATH)

FROM ruby:2.6-alpine
COPY --from=build /usr/local/bundle/bin /usr/local/bundle/bin
COPY --from=build /usr/local/bundle/extensions /usr/local/bundle/extensions
COPY --from=build /usr/local/bundle/gems /usr/local/bundle/gems
COPY --from=build /usr/local/bundle/specifications /usr/local/bundle/specifications

ENTRYPOINT ["iv-plurk"]
