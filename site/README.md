# umuo.app

[umuo 官网](https://umuo.app)和 Cloudflare Worker 的源码。这里是独立的 Bun 项目，以下命令均在 `site/` 中执行。macOS 客户端的构建步骤见 [仓库 README](../README.md)。

| 路径 | 用途 |
| --- | --- |
| [`apps/web/`](apps/web/) | Vite 与 React 官网。构建时为简体中文、繁体中文、英文、日文和韩文各生成一份首页 |
| [`middleware/`](middleware/) | Void 中间件入口，将请求交给 Worker |
| [`worker/`](worker/) | 按语言返回首页，提供 `/download/macos`、`/download/macos/appcast.xml` 和 `/api/health` |

## 本地开发

按 [package.json](package.json) 的 `packageManager` 安装 Bun，使用 Node 24.21 或更新版本。

```bash
bun install
bun run dev:web
```

测试下载跳转或按语言返回首页时，先生成预渲染页面，再运行本地 Worker。

```bash
bun run build:web
bun run dev:worker
```

提交前运行 `bun run verify`，验证 lint、类型、Vitest 以及官网与 Worker 构建。本机默认 Node 较旧时，可运行 `mise exec node@24 -- bun run verify`。

## 维护

- 修改官网或 Worker，先读 [官网指引](AGENTS.md)。视觉与文案分别见 [设计规范](DESIGN.md) 和 [官网产品说明](PRODUCT.md)。
- 生产配置、构建与发布见 [部署手册](docs/DEPLOY.md)。Cloudflare Workers Builds 设置、接管记录与回滚见 [Void 迁移手册](docs/VOID-MIGRATION.md)。

## 许可

官网源码采用 [MIT](../LICENSE) 许可证。「umuo」名称与图标不随 MIT 授权。第三方字体按各自条款授权。 [Open Sans 字体许可](apps/web/public/fonts/open-sans/OFL.txt)
