# Swift Publish 完整指南：从入门到精通

## 目录
1. [简介](#简介)
2. [安装](#安装)
3. [快速开始](#快速开始)
4. [核心概念](#核心概念)
5. [项目结构](#项目结构)
6. [内容创建](#内容创建)
7. [主题系统](#主题系统)
8. [插件系统](#插件系统)
9. [部署](#部署)
10. [高级用法](#高级用法)
11. [最佳实践](#最佳实践)
12. [故障排除](#故障排除)

---

## 简介

Swift Publish 是由 John Sundell 创建的**静态网站生成器**，专为 Swift 开发者设计。它提供：

- 🔒 **类型安全**：使用 Swift 类型系统确保网站构建的正确性
- ⚡ **高性能**：生成优化的静态 HTML 文件
- 🧩 **可扩展**：强大的插件和主题系统
- 📱 **现代化**：支持响应式设计和现代 Web 标准

### 系统要求
- **macOS**: 12.0+ (Monterey) 或 **Linux**
- **Swift**: 5.5+
- **Xcode**: 13.0+ (仅 macOS)
- **Git**: 用于版本控制和部署

---

## 安装

### 方法1：从源码安装（推荐）

```bash
# 克隆官方仓库
git clone https://github.com/JohnSundell/Publish.git
cd Publish

# 编译并安装 CLI 工具
make

# 验证安装
publish help
```

### 方法2：使用 Mint

```bash
# 安装 Mint
brew install mint

# 使用 Mint 安装 Publish
mint install JohnSundell/Publish
```

### 方法3：添加为 Swift Package 依赖

在你的 `Package.swift` 中：

```swift
dependencies: [
    .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0")
]
```

---

## 快速开始

### 创建新项目

```bash
# 创建项目目录
mkdir MyWebsite
cd MyWebsite

# 初始化 Publish 项目
publish new

# 查看项目结构
tree .
```

### 基础项目结构

```
MyWebsite/
├── Package.swift
├── Sources/
│   └── MyWebsite/
│       └── main.swift
├── Content/
│   ├── index.md
│   └── posts/
│       └── first-post.md
├── Resources/
└── Output/           # 生成的静态文件
```

### 运行和预览

```bash
# 构建网站
swift run

# 启动本地服务器
publish run

# 访问 http://localhost:8000
```

---

## 核心概念

### 1. Website 协议

所有 Publish 网站都必须实现 `Website` 协议：

```swift
struct MyWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case about
        case projects
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var excerpt: String?
        var estimatedReadingTime: String?
    }

    var url = URL(string: "https://mywebsite.com")!
    var name = "我的网站"
    var description = "个人博客和项目展示"
    var language: Language { .chinese }
    var imagePath: Path? { "images/logo.png" }
}
```

### 2. 发布管道（Publishing Pipeline）

Publish 使用步骤化的管道来构建网站：

```swift
try MyWebsite().publish(using: [
    .addMarkdownFiles(),           // 解析 Markdown 文件
    .copyResources(),              // 复制资源文件
    .generateHTML(withTheme: .foundation),  // 生成 HTML
    .generateRSSFeed(including: [.posts]),  // 生成 RSS
    .generateSiteMap(),            // 生成站点地图
    .deploy(using: .gitHub("username/repo")) // 部署
])
```

### 3. 内容模型

#### Section（分区）
网站的主要分区，如博客文章、项目等。

#### Item（项目）
单个内容项，如一篇博客文章。

#### Page（页面）
独立页面，如关于页面、联系页面。

#### Tag（标签）
用于分类和组织内容。

---

## 项目结构

### Sources/ 目录

```swift
// Sources/MyWebsite/main.swift
import Foundation
import Publish
import Plot

struct MyWebsite: Website {
    // 网站定义
}

// 发布配置
try MyWebsite().publish(using: [
    .step(named: "Custom preprocessing") { context in
        // 自定义预处理步骤
    },
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .myCustomTheme),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap()
])
```

### Content/ 目录

#### 主页：Content/index.md
```markdown
# 欢迎来到我的网站

这是网站首页的内容。可以使用 Markdown 语法。

## 最新动态

- 项目 A 已完成
- 博客更新频率提升
```

#### 文章：Content/posts/my-article.md
```markdown
---
date: 2024-01-15 12:00
description: 这是一篇关于 Swift 的文章
tags: swift, ios, 编程
excerpt: Swift 是一门现代化的编程语言...
---

# 我的第一篇文章

这里是文章内容...

## 代码示例

\```swift
func hello() {
    print("Hello, World!")
}
\```
```

#### 页面：Content/about.md
```markdown
---
title: 关于我
---

# 关于我

我是一名 Swift 开发者...
```

### Resources/ 目录

```
Resources/
├── styles/
│   ├── main.css
│   └── syntax-highlighting.css
├── images/
│   ├── logo.png
│   └── profile.jpg
├── scripts/
│   └── analytics.js
└── fonts/
    └── custom-font.woff2
```

---

## 内容创建

### Markdown 语法支持

```markdown
# 标题 1
## 标题 2
### 标题 3

**粗体** 和 *斜体*

- 无序列表
- 项目 2

1. 有序列表
2. 项目 2

[链接](https://example.com)

![图片](images/example.jpg)

> 引用块

`行内代码`

\```swift
// 代码块
func example() {
    print("Hello")
}
\```
```

### 元数据（Front Matter）

```markdown
---
date: 2024-01-15 14:30
title: 自定义标题
description: SEO 描述
tags: tag1, tag2, tag3
excerpt: 文章摘要
author: 作者名
featured: true
image: images/cover.jpg
---

# 文章内容
```

### 自定义元数据

```swift
struct ItemMetadata: WebsiteItemMetadata {
    var excerpt: String?
    var author: String?
    var featured: Bool = false
    var estimatedReadingTime: String?
    var coverImage: String?
}
```

在 Markdown 中使用：

```markdown
---
date: 2024-01-15 14:30
author: John Doe
featured: true
estimatedReadingTime: 5分钟
coverImage: images/article-cover.jpg
---
```

---

## 主题系统

### 使用内置主题

```swift
try MyWebsite().publish(using: [
    .generateHTML(withTheme: .foundation)  // 使用 Foundation 主题
])
```

### 创建自定义主题

```swift
extension Theme {
    static var myCustomTheme: Self {
        Theme(
            htmlFactory: MyHTMLFactory(),
            resourcePaths: [
                "Resources/styles/main.css",
                "Resources/scripts/main.js"
            ]
        )
    }
}
```

### HTML Factory 实现

```swift
private struct MyHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(
                .meta(.charset(.utf8)),
                .meta(.name("viewport"), .content("width=device-width, initial-scale=1")),
                .title(index.title),
                .description(index.description),
                .stylesheet("/styles/main.css"),
                .script(.src("/scripts/main.js"))
            ),
            .body(
                .class("index"),
                .header(
                    .nav(
                        .class("navigation"),
                        .ul(
                            .li(.a(.text("首页"), .href("/"))),
                            .li(.a(.text("文章"), .href("/posts"))),
                            .li(.a(.text("关于"), .href("/about")))
                        )
                    )
                ),
                .main(
                    .class("content"),
                    .section(
                        .class("hero"),
                        .h1(.text(index.title)),
                        .p(.text(index.description))
                    ),
                    .section(
                        .class("latest-posts"),
                        .h2("最新文章"),
                        .itemList(
                            for: context.allItems(
                                sortedBy: \.date,
                                order: .descending
                            ).prefix(5),
                            on: context.site
                        )
                    )
                ),
                .footer(
                    .class("site-footer"),
                    .p(.text("© 2024 \(context.site.name)"))
                )
            )
        )
    }

    // 实现其他必需的方法...
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        // 分区页面 HTML
    }

    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        // 文章页面 HTML
    }

    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        // 独立页面 HTML
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        // 标签列表页面 HTML
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        // 标签详情页面 HTML
    }
}
```

### Plot DSL 语法

Plot 是 Publish 的 HTML DSL：

```swift
// 基本元素
.div(.class("container"))
.h1(.text("标题"))
.p(.text("段落"))
.a(.href("/link"), .text("链接"))

// 属性
.id("element-id")
.class("css-class")
.style("color: red;")

// 条件渲染
.if(condition, .p(.text("条件内容")))

// 循环
.forEach(items) { item in
    .li(.text(item.title))
}

// 嵌套
.div(
    .class("card"),
    .h2(.text("卡片标题")),
    .p(.text("卡片内容"))
)
```

---

## 插件系统

### 安装插件

通过 Swift Package Manager 添加插件：

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0"),
    .package(url: "https://github.com/alexito4/ReadingTimePublishPlugin", from: "0.1.0")
]
```

### 使用插件

```swift
import SplashPublishPlugin
import ReadingTimePublishPlugin

try MyWebsite().publish(
    withTheme: .myTheme,
    plugins: [
        .splash(withClassPrefix: ""),
        .readingTime()
    ]
)
```

### 创建自定义插件

```swift
extension Plugin {
    static func addLastModified() -> Self {
        Plugin(name: "Add Last Modified") { context in
            for item in context.allItems() {
                // 获取文件修改时间
                let filePath = "Content/posts/\(item.path.string).md"
                let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
                let modificationDate = attributes[.modificationDate] as? Date

                // 添加到元数据
                item.metadata.lastModified = modificationDate
            }
        }
    }
}
```

### 常用插件

#### 1. Splash - 代码高亮
```swift
.splash(withClassPrefix: "")
```

#### 2. Reading Time - 阅读时间估算
```swift
.readingTime()
```

#### 3. 自定义插件示例

```swift
extension Plugin {
    static func generateTOC() -> Self {
        Plugin(name: "Generate Table of Contents") { context in
            for item in context.allItems() {
                let html = item.body.html
                let toc = generateTableOfContents(from: html)
                item.metadata.tableOfContents = toc
            }
        }
    }

    static func optimizeImages() -> Self {
        Plugin(name: "Optimize Images") { context in
            let resourcesPath = context.folder.path + "Resources/"
            // 压缩和优化图片
        }
    }
}
```

---

## 部署

### GitHub Pages

#### 1. 配置 GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v4

    - name: Build site
      run: |
        swift build
        swift run

    - name: Upload artifact
      uses: actions/upload-pages-artifact@v3
      with:
        path: ./Output

    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v4
```

#### 2. 使用 Publish 内置部署

```swift
try MyWebsite().publish(using: [
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .myTheme),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    .deploy(using: .gitHub("username/repository"))
])
```

### Netlify

```swift
extension DeploymentMethod {
    static func netlify(siteID: String, accessToken: String) -> Self {
        .custom { context in
            // 自定义 Netlify 部署逻辑
        }
    }
}
```

### 自定义部署

```swift
extension DeploymentMethod {
    static var myCustomDeployment: Self {
        .custom { context in
            let outputPath = context.outputPath

            // 1. 压缩文件
            try compressFiles(at: outputPath)

            // 2. 上传到服务器
            try uploadToServer(from: outputPath)

            // 3. 清理缓存
            try clearCDNCache()

            print("✅ 部署完成")
        }
    }
}
```

---

## 高级用法

### 1. 自定义构建步骤

```swift
try MyWebsite().publish(using: [
    // 预处理步骤
    .step(named: "Validate content") { context in
        try validateAllMarkdownFiles(in: context)
    },

    .addMarkdownFiles(),

    // 自定义处理步骤
    .step(named: "Generate excerpts") { context in
        for item in context.allItems() {
            if item.metadata.excerpt == nil {
                item.metadata.excerpt = generateExcerpt(from: item.body)
            }
        }
    },

    .step(named: "Add reading time") { context in
        for item in context.allItems() {
            let wordCount = countWords(in: item.body.plainText)
            let readingTime = wordCount / 200 // 假设每分钟读 200 字
            item.metadata.estimatedReadingTime = "\(readingTime)分钟"
        }
    },

    .copyResources(),
    .generateHTML(withTheme: .myTheme),

    // 后处理步骤
    .step(named: "Optimize HTML") { context in
        try optimizeHTMLFiles(in: context.outputPath)
    },

    .step(named: "Generate search index") { context in
        try generateSearchIndex(from: context.allItems())
    },

    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),

    .step(named: "Analytics") { context in
        logBuildStatistics(context)
    }
])
```

### 2. 条件构建

```swift
#if DEBUG
let deploymentStep: PublishingStep<MyWebsite> = .step(named: "Debug deploy") { _ in
    print("Debug build - skipping deployment")
}
#else
let deploymentStep: PublishingStep<MyWebsite> = .deploy(using: .gitHub("username/repo"))
#endif

try MyWebsite().publish(using: [
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .myTheme),
    deploymentStep
])
```

### 3. 多语言支持

```swift
struct MyWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case postsEn = "posts-en"
        case about
        case aboutEn = "about-en"
    }

    var language: Language { .chinese }
}

// 在主题中处理多语言
func makeNavigationHTML(for context: PublishingContext<MyWebsite>) -> Node<HTML.BodyContext> {
    let currentPath = context.site.path
    let isEnglish = currentPath.string.contains("-en")

    return .nav(
        .ul(
            .li(.a(.text(isEnglish ? "Home" : "首页"), .href(isEnglish ? "/en" : "/"))),
            .li(.a(.text(isEnglish ? "Posts" : "文章"), .href(isEnglish ? "/posts-en" : "/posts"))),
            .li(.a(.text(isEnglish ? "About" : "关于"), .href(isEnglish ? "/about-en" : "/about")))
        ),
        .div(
            .class("language-switcher"),
            .a(.text("中文"), .href(currentPath.string.replacingOccurrences(of: "-en", with: ""))),
            .text(" | "),
            .a(.text("English"), .href(currentPath.string + "-en"))
        )
    )
}
```

### 4. 动态内容生成

```swift
extension PublishingStep {
    static func generateProjectsFromGitHub(username: String) -> Self {
        .step(named: "Fetch GitHub projects") { context in
            let projects = try fetchGitHubProjects(for: username)

            for project in projects {
                let item = Item<MyWebsite>(
                    path: Path("projects/\(project.name)"),
                    sectionID: .projects,
                    metadata: MyWebsite.ItemMetadata(),
                    tags: Set(project.topics.map(Tag.init)),
                    content: Content(
                        title: project.name,
                        description: project.description,
                        body: Content.Body(markdown: project.readme)
                    ),
                    date: project.updatedAt
                )

                context.addItem(item)
            }
        }
    }
}
```

### 5. 自定义 Markdown 处理

```swift
extension PublishingStep {
    static func processCustomMarkdown() -> Self {
        .step(named: "Process custom markdown") { context in
            for item in context.allItems() {
                var markdown = item.content.body.markdown

                // 处理自定义语法
                markdown = markdown.replacingOccurrences(
                    of: "{{TOC}}",
                    with: generateTableOfContents(from: markdown)
                )

                markdown = markdown.replacingOccurrences(
                    of: "{{READING_TIME}}",
                    with: item.metadata.estimatedReadingTime ?? "未知"
                )

                // 处理图片优化
                markdown = processImageTags(in: markdown)

                // 更新内容
                item.content.body = Content.Body(markdown: markdown)
            }
        }
    }
}
```

### 6. SEO 优化

```swift
extension Node where Context == HTML.HeadContext {
    static func seoTags(
        for item: Item<MyWebsite>,
        on site: MyWebsite
    ) -> Node {
        .group(
            // Open Graph
            .meta(.property("og:title"), .content(item.title)),
            .meta(.property("og:description"), .content(item.description)),
            .meta(.property("og:type"), .content("article")),
            .meta(.property("og:url"), .content(site.url.appendingPathComponent(item.path.string).absoluteString)),
            .meta(.property("og:image"), .content(item.metadata.coverImage ?? "/images/default-cover.jpg")),

            // Twitter Card
            .meta(.name("twitter:card"), .content("summary_large_image")),
            .meta(.name("twitter:title"), .content(item.title)),
            .meta(.name("twitter:description"), .content(item.description)),
            .meta(.name("twitter:image"), .content(item.metadata.coverImage ?? "/images/default-cover.jpg")),

            // 结构化数据
            .script(.type("application/ld+json"), .text("""
            {
                "@context": "https://schema.org",
                "@type": "BlogPosting",
                "headline": "\(item.title)",
                "description": "\(item.description)",
                "author": {
                    "@type": "Person",
                    "name": "\(item.metadata.author ?? site.name)"
                },
                "datePublished": "\(item.date)",
                "url": "\(site.url.appendingPathComponent(item.path.string).absoluteString)"
            }
            """))
        )
    }
}
```

---

## 最佳实践

### 1. 项目结构

```
MyWebsite/
├── Package.swift
├── Sources/
│   └── MyWebsite/
│       ├── main.swift
│       ├── Theme/
│       │   ├── MyTheme.swift
│       │   └── HTMLFactory.swift
│       ├── Plugins/
│       │   └── CustomPlugins.swift
│       └── Extensions/
│           └── PublishingSteps.swift
├── Content/
│   ├── index.md
│   ├── posts/
│   ├── projects/
│   └── pages/
├── Resources/
│   ├── styles/
│   ├── scripts/
│   ├── images/
│   └── fonts/
└── Tests/
    └── MyWebsiteTests/
```

### 2. 性能优化

```swift
// 图片优化
extension PublishingStep {
    static func optimizeImages() -> Self {
        .step(named: "Optimize images") { context in
            let imagesPath = context.folder.subfolder(named: "Resources/images")

            for file in try imagesPath.files {
                if file.extension == "jpg" || file.extension == "png" {
                    try optimizeImage(at: file.path)
                }
            }
        }
    }
}

// CSS/JS 压缩
extension PublishingStep {
    static func minifyAssets() -> Self {
        .step(named: "Minify assets") { context in
            let outputPath = context.outputPath

            // 压缩 CSS
            for cssFile in try outputPath.subfolders.recursivelyAllFiles().filter({ $0.extension == "css" }) {
                let minified = try minifyCSS(cssFile.read())
                try cssFile.write(minified)
            }

            // 压缩 JS
            for jsFile in try outputPath.subfolders.recursivelyAllFiles().filter({ $0.extension == "js" }) {
                let minified = try minifyJavaScript(jsFile.read())
                try jsFile.write(minified)
            }
        }
    }
}
```

### 3. 内容管理

```swift
// 内容验证
extension PublishingStep {
    static func validateContent() -> Self {
        .step(named: "Validate content") { context in
            for item in context.allItems() {
                // 检查必需字段
                guard !item.title.isEmpty else {
                    throw ValidationError.missingTitle(item.path)
                }

                guard !item.description.isEmpty else {
                    throw ValidationError.missingDescription(item.path)
                }

                // 检查图片链接
                try validateImageReferences(in: item.body.html)

                // 检查内部链接
                try validateInternalLinks(in: item.body.html, context: context)
            }
        }
    }
}
```

### 4. 错误处理

```swift
enum WebsiteError: Error, LocalizedError {
    case missingRequiredFile(String)
    case invalidConfiguration(String)
    case deploymentFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingRequiredFile(let file):
            return "缺少必需文件: \(file)"
        case .invalidConfiguration(let issue):
            return "配置错误: \(issue)"
        case .deploymentFailed(let reason):
            return "部署失败: \(reason)"
        }
    }
}
```

### 5. 测试

```swift
// Tests/MyWebsiteTests/MyWebsiteTests.swift
import XCTest
import Publish

final class MyWebsiteTests: XCTestCase {
    func testWebsiteCanBeBuilt() throws {
        let website = MyWebsite()

        XCTAssertNoThrow(
            try website.publish(using: [
                .addMarkdownFiles(),
                .generateHTML(withTheme: .myTheme)
            ])
        )
    }

    func testAllPostsHaveValidMetadata() throws {
        let context = try PublishingContext<MyWebsite>.forTesting()

        for item in context.allItems() {
            XCTAssertFalse(item.title.isEmpty, "文章标题不能为空: \(item.path)")
            XCTAssertFalse(item.description.isEmpty, "文章描述不能为空: \(item.path)")
            XCTAssertTrue(item.tags.count > 0, "文章至少需要一个标签: \(item.path)")
        }
    }
}
```

---

## 故障排除

### 常见问题

#### 1. 编译错误

**问题**: `Package.swift` 配置错误
```swift
// ❌ 错误
dependencies: [
    .package(url: "https://github.com/johnsundell/publish.git", .branch("main"))
]

// ✅ 正确
dependencies: [
    .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0")
]
```

**问题**: Plot DSL 语法错误
```swift
// ❌ 错误
.link(.rel(.stylesheet), .href("/styles.css"))

// ✅ 正确
.stylesheet("/styles.css")
```

#### 2. 内容问题

**问题**: Markdown 前置元数据格式错误
```markdown
// ❌ 错误
---
date: 2024-01-15
tags: tag1 tag2 tag3
---

// ✅ 正确
---
date: 2024-01-15 12:00
tags: tag1, tag2, tag3
---
```

#### 3. 部署问题

**问题**: GitHub Actions 权限不足
```yaml
# 添加必要权限
permissions:
  contents: read
  pages: write
  id-token: write
```

**问题**: 资源文件未复制
```swift
// 确保包含 copyResources 步骤
try MyWebsite().publish(using: [
    .addMarkdownFiles(),
    .copyResources(),  // 不要忘记这一步
    .generateHTML(withTheme: .myTheme)
])
```

### 调试技巧

#### 1. 启用详细输出

```swift
try MyWebsite().publish(
    using: [...],
    rssFeedConfiguration: .default,
    deploymentConfiguration: .init(verbose: true)
)
```

#### 2. 添加调试步骤

```swift
.step(named: "Debug info") { context in
    print("📊 网站统计:")
    print("- 总页面数: \(context.allItems().count)")
    print("- 分区数: \(context.sections.count)")
    print("- 标签数: \(context.allTags().count)")

    print("\n📄 页面列表:")
    for item in context.allItems() {
        print("- \(item.path): \(item.title)")
    }
}
```

#### 3. 本地调试服务器

```bash
# 启动调试服务器
publish run --port 8080

# 查看生成的文件
ls -la Output/

# 检查特定文件
cat Output/index.html
```

---

## 扩展资源

### 官方文档
- [Publish GitHub](https://github.com/JohnSundell/Publish)
- [Plot DSL 文档](https://github.com/JohnSundell/Plot)

### 社区插件
- [Splash - 语法高亮](https://github.com/JohnSundell/SplashPublishPlugin)
- [CNAMEPublishPlugin - 自定义域名](https://github.com/alexito4/CNAMEPublishPlugin)
- [TwitterPublishPlugin - Twitter 卡片](https://github.com/alexito4/TwitterPublishPlugin)

### 示例项目
- [Swift by Sundell](https://github.com/JohnSundell/SwiftBySundell) - John Sundell 的个人网站
- [Publish Examples](https://github.com/JohnSundell/PublishExamples) - 官方示例

### 学习资源
- [Swift by Sundell 博客](https://swiftbysundell.com/tags/publish/)
- [iOS Dev Weekly](https://iosdevweekly.com/)

---

这份指南涵盖了 Swift Publish 从基础到高级的所有用法。随着你对 Publish 的深入使用，你可以根据具体需求定制和扩展这些功能。记住，Publish 的强大之处在于其类型安全和可扩展性，善用这些特性可以构建出强大而优雅的静态网站。