# Telegram File Stream Bot

## 项目简介 | Project Introduction
本项目是一个 Telegram 机器人，支持为 Telegram 频道/群组中的文件生成直接下载链接（直链），支持断点续传、在线播放等功能。适合个人或团队部署，实现文件分享自动化。
This project is a Telegram bot that generates direct download links for files in Telegram channels/groups, supporting HTTP Range requests, resume download, and online playback. Suitable for personal or team deployment to automate file sharing.

## 项目功能 | Features
- 生成 Telegram 文件的直链，支持 HTTP Range 请求
- 支持视频、音频、文档、图片等多种类型文件
- **User Bot 支持**：可选配置 User Bot 用于访问私有频道和增强兼容性
- **Telegram 链接解析**：支持 t.me/c/ 和 t.me/username/ 格式链接直接生成直链
- 用户访问权限控制与黑名单管理
- 文件信息缓存，提升性能
- 支持在线播放和断点续传
- 支持多用户管理
- 支持自定义直链 hash 长度
- **安全加密存储**：手机号码使用 AES-GCM 加密本地保存

## 技术栈 | Tech Stack
- Go 1.21+
- [gotgproto](https://github.com/celestix/gotgproto) (Telegram 客户端)
- [Gin](https://github.com/gin-gonic/gin) (HTTP 框架)
- SQLite (会话存储)
- FreeCache (文件信息缓存)

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
- `ADMIN_USERS`：管理机器人的 Telegram 用户 ID，逗号分隔（**强烈推荐设置**）
- `PHONE_NUMBER`：User Bot 手机号（可选，格式如 +8613800138000）

## 使用示例 | Usage Example

### 基本使用
1. 向 Bot 发送文件或转发频道/群组中的文件
2. Bot 回复直链下载地址
3. 通过直链可直接下载或在线播放文件

### Telegram 链接解析
1. 向 Bot 发送 Telegram 链接：
   - 私有频道：`https://t.me/c/1683088671/36831`
   - 公开频道：`https://t.me/channelname/123` 或 `@channelname/123`
2. Bot 自动解析并返回直链
3. **注意**：机器人或 User Bot 必须加入该频道才能访问

### 管理命令（仅限管理员）
- `/start` - 开始使用机器人
- `/ban <用户ID>` - 将用户加入黑名单
- `/unban <用户ID>` - 将用户移出黑名单
- `/phone <手机号>` - 设置 User Bot 手机号
- `/code <验证码>` - 提交登录验证码
- `/pass <密码>` - 提交两步验证密码

### 配置 User Bot（可选，增强功能）

#### 为什么需要 User Bot？
- 访问私有频道和群组的消息
- 提升对某些链接的兼容性
- 绕过某些 Bot 访问限制

#### 配置步骤
1. **前提**：在 `ADMIN_USERS` 中包含你的 Telegram 用户 ID
2. **设置手机号**：
   ```
   /phone +8613800138000
   ```
   - 手机号会使用 AES-GCM 加密保存到本地 `phone.enc`
   - 加密密钥由 `API_HASH + BOT_TOKEN + TELE_ID` 派生生成

3. **提交验证码**：
   - Telegram 会发送验证码到你的手机
   - 在机器人中发送：`/code 12345`
   - 超时时间：5 分钟

4. **提交两步验证密码**（如果需要）：
   ```
   /pass yourpassword
   ```

5. **完成**：User Bot 启动成功后会显示用户名和 ID

#### 安全说明
- 手机号加密存储，密钥与 `API_HASH`、`BOT_TOKEN`、`TELE_ID` 绑定
- 若这些参数变动，历史 `phone.enc` 将无法解密，需要重新设置
- 建议仅在可信环境部署
- 验证码和密码通过私聊发送，不会被记录

## 直链格式说明  Link Format

### Bot 转发的文件
```
http://your-host/stream/{messageID}?hash={hash}
```

### Telegram 链接生成的直链
```
http://your-host/stream/{channelID}_{messageID}?hash={hash}
```

### 下载参数
- 在线播放：`http://your-host/stream/xxx?hash=xxx`
- 强制下载：`http://your-host/stream/xxx?hash=xxx&d=true`

## 常见问题  FAQ

**Q: LOG_CHANNEL 必须是频道吗？**  
A: 是，且 Bot 必须为频道管理员。

**Q: 如何保证直链安全？**  
A: 直链包含安全 hash 校验，防止非法访问。Hash 基于文件名、大小、MIME类型和文件ID生成。

**Q: 文件信息缓存多久？**  
A: 默认缓存 1 小时，使用 FreeCache 存储（最大 10MB）。

**Q: 如何添加/移除管理员？**  
A: 修改 `.env` 中的 `ADMIN_USERS` 参数，重启服务。

**Q: User Bot 和普通 Bot 有什么区别？**  
A: User Bot 使用真实用户账号登录，可以访问用户加入的所有频道和群组；普通 Bot 只能访问明确添加它的频道。

**Q: 手机号加密是否安全？**  
A: 使用 AES-256-GCM 加密，密钥基于 SHA-256 哈希派生。但仍建议在可信环境部署，避免配置文件泄露。

**Q: 如果验证码输入错误怎么办？**  
A: 验证码有多次尝试机会。如果失败，需要删除 `userbot.session` 文件并重新启动服务。

**Q: 支持哪些文件类型？**  
A: 支持所有 Telegram 支持的文件类型，包括文档、图片、视频、音频等。

## 项目结构  Project Structure
```
TGFileBot/
├── main.go              # 主程序
├── go.mod               # Go 模块配置
├── go.sum               # 依赖校验
├── .env                 # 配置文件（需自行创建）
├── sample.zh.env        # 配置示例
├── fsb.session          # Bot 会话文件（自动生成）
├── userbot.session      # User Bot 会话文件（自动生成）
├── phone.enc            # 加密的手机号（自动生成）
└── README.md            # 本文件
```

## 贡献指南  Contributing
欢迎提交 Issue 和 Pull Request。请遵循 [Go 代码规范](https://golang.org/doc/effective_go.html)。

## 许可证  License
MIT License. 详见 LICENSE 文件。