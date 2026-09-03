---
title: "你好,世界:博客上线了"
date: 2026-09-03T01:50:00+08:00
draft: false
tags: ["随笔"]
---

这是这个博客的第一篇文章,由 Hugo 生成、托管在 Cloudflare 上。

## 以后怎么写新文章?

1. 在 `content/posts/` 目录下新建一个 Markdown 文件,比如 `my-second-post.md`;
2. 文件开头加上这段信息(照抄改一改就行):

```markdown
---
title: "文章标题"
date: 2026-09-03
draft: false
tags: ["标签1"]
---

正文用 Markdown 写……
```

3. `draft` 是草稿开关:`true` 的文章不会发布,写完记得改成 `false`;
4. 改完让 ZCode 重新构建部署,或者自己跑:

```bash
hugo            # 编译,输出到 public/ 目录
hugo server -D  # 本地预览,浏览器打开 http://localhost:1313
```

## 这个博客是怎么搭的

- **Hugo** 把 `content/` 里的 Markdown 编译成纯静态 HTML,速度飞快;
- **Cloudflare** 负责把网站发给全世界访问,免费额度对个人博客绰绰有余;
- 当前用的是 **PaperMod** 主题,外观设置都在站点根目录的 `hugo.yaml` 里。

接下来可以做的事:改标题和欢迎语(`hugo.yaml`)、删掉这篇文章、写真正属于自己的第一篇。
