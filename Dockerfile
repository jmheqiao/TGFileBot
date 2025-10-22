# dockerfile
# 构建阶段
FROM golang:1.24-alpine AS builder

ARG TARGETARCH
ARG TARGETOS

WORKDIR /tgfilebot
COPY . .

RUN go mod tidy

RUN CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    go build -ldflags "-s -w" \
             -tags netgo \
             -installsuffix netgo \
             -o tgfilebot main.go

# 运行阶段
FROM alpine:3.20

WORKDIR /root/

RUN apk --no-cache add ca-certificates tzdata

# 复制编译产物
COPY --from=builder /tgfilebot/tgfilebot .

# 确保配置文件存在
RUN mkdir "files"
RUN cd files && touch "blacklist.json"
RUN echo -n "[]" > blacklist.json

EXPOSE 9981

CMD ["./tgfilebot"]

ENV TZ=Asia/Shanghai