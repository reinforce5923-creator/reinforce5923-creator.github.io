# Silicon & Thoughts

这是强化加第五的个人技术博客项目，基于 Hexo、Node.js、npm、Git、GitHub Pages 和 GitHub Actions 构建。

博客定位为大学生个人技术博客，同时作为学习笔记库、项目记录、技术作品集和长期成长档案。主要内容包括微电子、半导体器件、神经形态器件、人工智能、计算机视觉、算法、大学物理、电路基础、高等数学、编程学习、项目记录、大学生活与个人思考。

## 环境要求

- Node.js 22 或更高版本
- npm
- Git

## 安装方式

```bash
git clone https://github.com/你的用户名/你的仓库名.git
cd 你的仓库名
npm install
```

如果是在当前目录直接使用：

```bash
npm install
```

## 本地运行

```bash
npm install
npx hexo clean
npx hexo generate
npx hexo server
```

启动后访问终端提示的本地地址，通常是：

```text
http://localhost:4000
```

也可以使用 npm scripts：

```bash
npm run build
npm run server
```

## 纯新手改内容

最先看这个文件：

```text
docs/beginner-guide.md
```

最常改这三个地方：

```text
source/_data/home.yml        # 改首页文字、按钮、精选分类、四个入口
source/about/index.md        # 改“关于我”
source/_posts/               # 写文章
```

也可以直接双击：

```text
start-blog.bat               # 启动本地预览
new-post.bat                 # 新建文章
```

如果当前 Windows 终端没有配置好 `node`/`npm`，但项目依赖已经安装完成，可以使用项目内的备用启动脚本：

```powershell
powershell -ExecutionPolicy Bypass -File tools/local-server.ps1
```

## 创建文章

新建普通文章：

```bash
npx hexo new post "文章标题"
```

新建项目记录：

```bash
npx hexo new project "项目名称"
```

文章默认保存在 `source/_posts/`。本项目已开启 `post_asset_folder: true`，建议每篇文章配套图片放在同名资源目录中。例如：

```text
source/_posts/my-first-project.md
source/_posts/my-first-project/cover.png
source/_posts/my-first-project/device-test.jpg
```

文章中可以这样引用：

```markdown
![器件测试照片](device-test.jpg)
```

公共图片可以放在：

```text
source/images/
```

## Markdown、公式与代码

支持 Markdown 文章、分类、标签、归档、RSS、站内搜索、目录 TOC、上一篇/下一篇、返回顶部、移动端适配。

行内公式：

```markdown
$E=mc^2$
```

独立公式：

```markdown
\[
F = ma
\]
```

长公式在移动端会横向滚动，避免撑破页面。

代码块示例：

````markdown
```python
def hello():
    print("Hello, Silicon & Thoughts")
```
````

支持 C、C++、Java、Python、MATLAB、JavaScript、Shell、Verilog 等常见语言的语法高亮，并带有复制按钮。

## 发布流程

完成文章或页面修改后：

```bash
git add .
git commit -m "add new post"
git push
```

推送到 `main` 分支后，GitHub Actions 会自动安装依赖、构建 Hexo，并将 `public/` 中的静态网站部署到 GitHub Pages。

## GitHub Pages 配置

推荐仓库名称：

- 用户主页仓库：`你的用户名.github.io`
- 项目仓库：任意仓库名，例如 `silicon-and-thoughts`

在 GitHub 仓库中进入：

```text
Settings -> Pages
```

将 Source 设置为：

```text
GitHub Actions
```

本项目的 workflow 会在 GitHub Actions 中自动判断仓库类型：

- 如果仓库名是 `用户名.github.io`，站点根路径为 `/`；
- 如果是普通项目仓库，站点根路径为 `/仓库名/`。

因此通常不需要手动修改 `_config.yml` 的 `root`。如果你后续绑定自定义域名，可以在：

```text
Settings -> Pages -> Custom domain
```

中填写域名，并按 GitHub 提示配置 DNS。绑定自定义域名后，建议把 `_config.yml` 中的 `url` 改成你的正式域名。

## GitHub Actions 自动部署

工作流文件位于：

```text
.github/workflows/pages.yml
```

主要步骤：

1. checkout 仓库；
2. 使用 Node.js 22；
3. 执行 `npm ci`；
4. 根据仓库类型配置 Hexo 的 `url` 和 `root`；
5. 执行 `npx hexo clean` 与 `npx hexo generate`；
6. 使用 GitHub 官方 Pages Actions 上传并部署静态文件。

## 常见问题

### 页面 404

确认 GitHub Pages 的 Source 已设置为 `GitHub Actions`，并检查 Actions 是否成功完成。首次启用 Pages 后，GitHub 可能需要等待几十秒到几分钟。

### CSS 丢失

通常是 `root` 或 `url` 配置不匹配导致。GitHub Actions 已经自动处理普通仓库和 `用户名.github.io` 仓库的路径。如果你手动本地构建后上传，请确认 `_config.yml` 中的 `root` 与部署路径一致。

### base URL 错误

项目仓库部署到 `https://用户名.github.io/仓库名/` 时，根路径应该是 `/仓库名/`。用户主页仓库部署到 `https://用户名.github.io/` 时，根路径应该是 `/`。

### GitHub Actions 构建失败

先进入 Actions 页面查看失败日志。常见原因包括依赖安装失败、Node.js 版本不兼容、Markdown front matter 格式错误、主题模板语法错误。

### Node.js 版本问题

建议本地使用 Node.js 22 或更高版本。GitHub Actions 已配置 Node.js 22。

### npm 依赖问题

可以尝试清理后重新安装：

```bash
rm -rf node_modules package-lock.json
npm install
```

Windows PowerShell 可以使用：

```powershell
Remove-Item -Recurse -Force node_modules
Remove-Item -Force package-lock.json
npm install
```

## 目录结构

```text
.
├── .github/
│   └── workflows/
│       └── pages.yml
├── scaffolds/
├── source/
│   ├── _posts/
│   ├── about/
│   ├── projects/
│   ├── notes/
│   ├── microelectronics/
│   ├── life/
│   └── images/
├── themes/
│   └── silicon/
├── _config.yml
├── package.json
├── README.md
└── .gitignore
```
