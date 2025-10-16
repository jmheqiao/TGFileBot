# 构建阶段 - 使用 Golang 1.23.0 版本
FROM golang:1.23.0-alpine AS builder

# 定义构建参数，指定目标架构
ARG TARGETARCH
ARG TARGETOS

WORKDIR /tgfilebot
COPY . .

# 处理依赖
RUN go mod tidy

# 修正环境变量设置方式，正确传递GOOS和GOARCH
RUN CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    go build -ldflags "-s -w" \
             -tags netgo \
             -installsuffix netgo \
             -o tgfilebot main.go

# 运行阶段
FROM alpine:3.20

# 接收构建阶段的参数（保持一致性）
ARG TARGETARCH
ARG TARGETOS

WORKDIR /root/

# 安装必要的系统工具
RUN apk --no-cache add ca-certificates tzdata
# 在工作目录创建配置文件（与程序读取路径一致）
RUN touch blacklist.json

# 复制编译产物和配置文件
COPY --from=builder /tgfilebot/tgfilebot .
COPY --from=builder /tgfilebot/blacklist.json .


EXPOSE 9981

# 修正命令格式，拆分命令和参数
CMD ["./tgfilebot"]

# 设置默认的时区
ENV TZ=Asia/Shanghai
