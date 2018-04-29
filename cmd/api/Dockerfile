FROM alpine:3.7

RUN apk update && apk --no-cache add ca-certificates
RUN addgroup -S app && adduser -S -g app app
USER app

WORKDIR app

COPY api .

CMD ["./api"]
