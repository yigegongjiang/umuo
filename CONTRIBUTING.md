# 参与贡献

欢迎提交 Issue 和 Pull Request。请用仓库模板记录复现步骤、预期行为和验证结果。安全漏洞请使用 [私密报告渠道](SECURITY.md)，并从日志和截图中移除 API Key。

## 开发前

1. 从 [项目文档](docs/README.md) 找到对应入口。功能范围和验收指标以 [产品需求](docs/PRD.md) 为准。
2. 按 [项目指引](AGENTS.md) 选择实现层、构建命令和测试方式。修改官网或 Worker 时，另读 [官网指引](site/AGENTS.md)，在 `site/` 安装依赖并运行命令。
3. 修改 README 时以 [简体中文版](README.md) 为准，同步 [四种译本](docs/readme/)。来不及补齐时，在 PR 里注明缺少的语言。

## 提交 PR

- 每个 PR 聚焦一项变更。注释和提交信息用中文，代码标识符用英文。提交标题写明具体改动，例如「修复复制取词时误判用户干预」，需要时在正文说明原因和取舍。
- 为新功能和修复补充测试。用替身和本地桩隔离真实 Keychain、用户剪贴板、供应商端点与系统按键。
- 提交前在仓库根目录运行 `bun run verify`。涉及官网时，再在 `site/` 运行 `bun run verify`。在 PR 里贴出结果；涉及系统交互时，按 [真机走查](docs/release/NATIVE-WALKTHROUGH.md) 记录所测机型、macOS 版本和现象。
- 命中发布路径的客户端改动合入 `main` 后会自动发正式版。合并前确认改动可直接交付给用户。 [发布手册](docs/release/RELEASE.md)

## 许可

贡献按项目的 [MIT 许可证](LICENSE) 授权，无需另签 CLA。只提交有权授权的代码。复制第三方源码时，按 [第三方声明](THIRD_PARTY_NOTICES) 登记来源与许可。

「umuo」名称和图标不随 MIT 许可证授权。分发修改版时，请使用其他名称与图标。
