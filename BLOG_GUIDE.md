# 博客发布小白指南

## 我的博客网址

```text
https://yifankong823-creator.github.io/
```

发布成功后，任何人都可以用这个网址访问你的博客。

## 平时怎么看博客

直接打开浏览器，访问：

```text
https://yifankong823-creator.github.io/
```

## 怎么在本地预览

先打开桌面上的项目文件夹：

```text
C:\Users\12595\Desktop\github-pages-hexo-node-js-npm
```

最简单的方法是双击：

```text
start-blog.bat
```

也可以在项目目录里运行：

```bash
npm install
npx hexo clean
npx hexo generate
npx hexo server
```

然后在浏览器访问：

```text
http://localhost:4000/
```

本地预览只是给自己检查效果，不等于已经发布到网上。

## 怎么写新文章

在项目目录里运行：

```bash
npx hexo new post "文章标题"
```

文章会出现在：

```text
source/_posts/
```

打开新生成的 `.md` 文件，就可以写文章正文。

文章开头一般长这样：

```markdown
---
title: 文章标题
date: 2026-07-08
categories:
  - 分类名
tags:
  - 标签1
  - 标签2
---
```

下面继续写正文即可。

## 怎么发布文章

写完文章后，在项目目录依次运行：

```bash
git add .
git commit -m "Add new post"
git push
```

推送完成后，不需要手动上传 `public` 文件夹。

GitHub Actions 会自动构建并更新网站。

## 怎么检查发布是否成功

1. 打开 GitHub 仓库：

```text
https://github.com/yifankong823-creator/yifankong823-creator.github.io
```

2. 点击页面上方的 `Actions`。
3. 找到最新的一条工作流。
4. 绿色对勾表示成功。
5. 红色叉号表示失败。

如果工作流成功，再打开博客网址检查：

```text
https://yifankong823-creator.github.io/
```

## 最常见的问题

### 本地能看，网上看不到

通常是忘记执行：

```bash
git push
```

或者 GitHub Actions 还没跑完。等一两分钟后再刷新网站。

### CSS 丢失，网页只有文字

通常是网站地址或路径配置不对。这个项目当前已经配置为：

```text
https://yifankong823-creator.github.io/
```

如果以后换仓库名或自定义域名，需要重新检查 `_config.yml` 里的 `url` 和 `root`。

### 图片不显示

检查图片文件名大小写是否一致。比如文章里写的是：

```markdown
![图片](cover.png)
```

文件名就不要写成 `Cover.png` 或 `cover.PNG`。

### Git push 失败

先确认已经登录 GitHub。可以运行：

```bash
gh auth status
```

如果显示没有登录，就运行：

```bash
gh auth login
```

### Actions 红叉

打开 GitHub 仓库的 `Actions` 页面，点进红叉那一条，看具体报错。

常见原因包括：

- Markdown 文章开头格式写错；
- 依赖安装失败；
- 主题模板语法错误；
- GitHub Pages 设置不正确。

### 修改文章后忘记发布

只保存 Markdown 文件不会更新网上的网站。必须执行：

```bash
git add .
git commit -m "Update blog"
git push
```

### Markdown 文件放错位置

文章应该放在：

```text
source/_posts/
```

普通页面通常放在类似：

```text
source/about/index.md
source/projects/index.md
source/notes/index.md
```

## 最短发布流程

以后每次写完文章，最少记住这三条：

```bash
git add .
git commit -m "Update blog"
git push
```
