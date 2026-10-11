FROM golang:1.18-bullseye AS server-builder
WORKDIR /src/app/fider
COPY app/fider/go.mod app/fider/go.sum ./
RUN go mod download
COPY app/fider/ ./
RUN make build-server

FROM node:16-bullseye AS ui-builder
WORKDIR /src/app/fider
COPY app/fider/package.json app/fider/package-lock.json ./
RUN npm ci
COPY app/fider/ ./
RUN make build-ssr && make build-ui

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=server-builder /src/app/fider/migrations ./migrations
COPY --from=server-builder /src/app/fider/views ./views
COPY --from=server-builder /src/app/fider/locale ./locale
COPY --from=server-builder /src/app/fider/LICENSE ./LICENSE
COPY --from=server-builder /src/app/fider/fider ./fider
COPY --from=ui-builder /src/app/fider/favicon.png ./favicon.png
COPY --from=ui-builder /src/app/fider/dist ./dist
COPY --from=ui-builder /src/app/fider/robots.txt ./robots.txt
COPY --from=ui-builder /src/app/fider/ssr.js ./ssr.js
USER 65532:65532
ENV PORT=80
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD ["./fider", "ping"]
ENTRYPOINT ["./fider"]