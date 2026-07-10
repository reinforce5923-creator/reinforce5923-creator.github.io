# 新手怎么改这个博客

你先记住一句话：

> 首页改 `source/_data/home.yml`，文章改 `source/_posts/`，关于页改 `source/about/index.md`。

## 1. 改首页文字

打开：

```text
source/_data/home.yml
```

最常改这几行：

```yml
title: "Silicon & Thoughts"
intro: "我是强化加第五，山东大学微电子科学与工程专业学生。这里记录..."
```

按钮也在这个文件里：

```yml
buttons:
  - text: "了解我"
    url: "/about/"
```

注意：

- 冒号后面要有一个空格。
- 不确定怎么写时，就把文字放在英文双引号里。
- 不要删掉每行前面的空格，YAML 很在意缩进。

## 2. 改“关于我”

打开：

```text
source/about/index.md
```

里面就是普通 Markdown，像写 Word 一样改文字就行。

## 3. 写新文章

在项目目录打开终端，运行：

```bash
npx hexo new post "文章标题"
```

新文章会出现在：

```text
source/_posts/
```

打开生成的 `.md` 文件，往下面写正文。

## 4. 改完怎么看效果

如果本地服务已经开着，通常刷新浏览器就能看到。

如果没开服务，运行：

```bash
npm run server
```

然后打开：

```text
http://127.0.0.1:4000/
```

## 5. 哪些文件不要改

不要手动改：

```text
public/
db.json
node_modules/
```

这些是自动生成的，改了也会被覆盖。
