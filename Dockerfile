FROM golang:1.22-alpine AS builder
RUN apk add --no-cache make git ca-certificates
WORKDIR /src
COPY . /src
RUN make build

FROM gcr.io/distroless/static
COPY --from=builder /src/pgweb /usr/bin/pgweb
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
USER nonroot:nonroot
EXPOSE 8081
ENTRYPOINT ["/usr/bin/pgweb", "--bind=0.0.0.0", "--listen=8081"]
