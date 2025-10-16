# Telegram File Stream Bot

## 项目简介 | Project Introduction
本项目是一个 Telegram 机器人，支持为 Telegram 频道/群组中的文件生成直接下载链接（直链），支持断点续传、在线播放等功能。适合个人或团队部署，实现文件分享自动化。
This project is a Telegram bot that generates direct download links for files in Telegram channels/groups, supporting HTTP Range requests, resume download, and online playback. Suitable for personal or team deployment to automate file sharing.

## 项目功能 | Features
- 生成 Telegram 文件的直链，支持 HTTP Range 请求
- 支持视频、音频、文档、图片等多种类型文件
- 用户访问权限控制
- 文件信息缓存，提升性能
- 支持在线播放和断点续传
- 支持多用户管理
- 支持自定义直链 hash 长度

## 技术栈 | Tech Stack
- Go 1.21+
- [gotgproto](https://github.com/gotd/td) (Telegram 客户端)
- [Gin](https://github.com/gin-gonic/gin) (HTTP 框架)
- [SQLite](https://www.sqlite.org/)（会话存储）
- [FreeCache](https://github.com/coocood/freecache)（文件信息缓存）

## 安装与运行 | Installation & Run
1. 安装 Go 1.21+ 环境
2. 复制 `sample.zh.env` 为 `.env`，并填写参数
3. 安装依赖并运行：
   ```cmd
   go mod tidy
   go run main.go
   ```

## 参数配置说明 | Configuration

### 必填参数 | Required Parameters
- `API_ID`：Telegram API ID（在 https://my.telegram.org 获取）
- `API_HASH`：Telegram API Hash（同上）
- `BOT_TOKEN`：Telegram Bot Token（在 @BotFather 获取）
- `LOG_CHANNEL`：用于存储转发消息的频道 ID（必须是频道，格式如 -100xxxxxxxxxx）

### 可选参数 | Optional Parameters
- `PORT`：HTTP 服务端口，默认 8080
- `HOST`：服务地址（如 http://localhost:8080 或 https://your-domain.com）
- `HASH_LENGTH`：直链 hash 长度，默认 6
- `ALLOWED_USERS`：管理机器人的 Telegram 用户 ID，逗号分隔
- `USE_USER_BOT`：是否启用 User Bot（使用你的个人账号读取频道消息，以提升兼容性）
- `PHONE_NUMBER`：仅在 USE_USER_BOT=true 时需要填写，User Bot账号使用的手机号

## 使用示例 | Usage Example
1. 向 Bot 发送文件或转发频道/群组中的文件、或 telegram 链接（User Bot 对应账号必须加入分享链接所在频道/群组）
2. Bot 回复直链下载地址
3. 通过直链可直接下载或在线播放文件
4. 通过 /ban 或 /unban id 方式控制用户权限

## 常见问题 | FAQ
- **Q: LOG_CHANNEL 必须是频道吗？**
  A: 是，且 Bot 必须为频道管理员。
- **Q: 如何保证直链安全？**
  A: 直链包含安全 hash 校验，防止非法访问。
- **Q: 文件信息缓存多久？**
  A: 默认缓存 1 小时，可在配置中调整。
- **Q: 如何添加/移除允许用户？**
  A: 修改 `ALLOWED_USERS` 参数，重启服务。

## 贡献指南 | Contributing
欢迎提交 Issue 和 Pull Request。请遵循 [Go 代码规范](https://golang.org/doc/effective_go.html)。

## 许可证 | License
MIT License. 详见 LICENSE 文件。