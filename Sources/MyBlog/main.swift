// 修复后的自定义主题代码
import Foundation
import Publish
import Plot

// 网站结构定义
struct MyBlog: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // 可以添加自定义元数据
    }

    var url = URL(string: "https://yourusername.github.io/MyBlog")!
    var name = "我的博客"
    var description = "用 Swift Publish 创建的个人博客"
    var language: Language { .chinese }
    var imagePath: Path? { nil }
}

// 修复后的自定义主题
extension Theme {
    static var custom: Self {
        Theme(
            htmlFactory: CustomHTMLFactory(),
            resourcePaths: ["Resources/styles.css"]
        )
    }
}

private struct CustomHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                // 修复：使用简化的header
                .header(
                    .nav(
                        .ul(
                            .li(.a(.text("首页"), .href("/"))),
                            .li(.a(.text("文章"), .href("/posts"))),
                            .li(.a(.text("关于"), .href("/about")))
                        )
                    )
                ),
                .div(
                    .class("wrapper"),
                    .h1(.text(index.title)),
                    .p(.text(index.description)),
                    .h2("最新文章"),
                    // 修复：使用正确的文章列表格式
                    .ul(
                        .class("item-list"),
                        .forEach(context.allItems(sortedBy: \.date, order: .descending)) { item in
                            .li(
                                .article(
                                    .h3(.a(.href(item.path), .text(item.title))),
                                    .p(.text(item.description)),
                                    .p(.text("发布于: \(DateFormatter.blog.string(from: item.date))")),
                                    .div(
                                        .class("tags"),
                                        .forEach(item.tags) { tag in
                                            .span(.class("tag"), .text(tag.string))
                                        }
                                    )
                                )
                            )
                        }
                    )
                ),
                // 修复：使用简化的footer
                .footer(
                    .p(.text("© 2025 \(context.site.name). 使用 Swift Publish 构建。"))
                )
            )
        )
    }
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(
                    .nav(
                        .ul(
                            .li(.a(.text("首页"), .href("/"))),
                            .li(.a(.text("文章"), .href("/posts"))),
                            .li(.a(.text("关于"), .href("/about")))
                        )
                    )
                ),
                .div(
                    .class("wrapper"),
                    .h1(.text(section.title)),
                    .ul(
                        .class("item-list"),
                        .forEach(section.items) { item in
                            .li(
                                .article(
                                    .h3(.a(.href(item.path), .text(item.title))),
                                    .p(.text(item.description)),
                                    .p(.text("发布于: \(DateFormatter.blog.string(from: item.date))")),
                                    .div(
                                        .class("tags"),
                                        .forEach(item.tags) { tag in
                                            .span(.class("tag"), .text(tag.string))
                                        }
                                    )
                                )
                            )
                        }
                    )
                ),
                .footer(
                    .p(.text("© 2025 \(context.site.name). 使用 Swift Publish 构建。"))
                )
            )
        )
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .header(
                    .nav(
                        .ul(
                            .li(.a(.text("首页"), .href("/"))),
                            .li(.a(.text("文章"), .href("/posts"))),
                            .li(.a(.text("关于"), .href("/about")))
                        )
                    )
                ),
                .div(
                    .class("wrapper"),
                    .article(
                        .h1(.text(item.title)),
                        .p(.class("meta"), .text("发布于: \(DateFormatter.blog.string(from: item.date))")),
                        .div(
                            .class("tags"),
                            .text("标签: "),
                            .forEach(item.tags) { tag in
                                .a(
                                    .class("tag"),
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            }
                        ),
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        )
                    )
                ),
                .footer(
                    .p(.text("© 2025 \(context.site.name). 使用 Swift Publish 构建。"))
                )
            )
        )
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(
                    .nav(
                        .ul(
                            .li(.a(.text("首页"), .href("/"))),
                            .li(.a(.text("文章"), .href("/posts"))),
                            .li(.a(.text("关于"), .href("/about")))
                        )
                    )
                ),
                .div(
                    .class("wrapper"),
                    .contentBody(page.body)
                ),
                .footer(
                    .p(.text("© 2025 \(context.site.name). 使用 Swift Publish 构建。"))
                )
            )
        )
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(
                    .nav(
                        .ul(
                            .li(.a(.text("首页"), .href("/"))),
                            .li(.a(.text("文章"), .href("/posts"))),
                            .li(.a(.text("关于"), .href("/about")))
                        )
                    )
                ),
                .div(
                    .class("wrapper"),
                    .h1("所有标签"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .a(
                                    .class("tag"),
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(
                    .p(.text("© 2025 \(context.site.name). 使用 Swift Publish 构建。"))
                )
            )
        )
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(
                    .nav(
                        .ul(
                            .li(.a(.text("首页"), .href("/"))),
                            .li(.a(.text("文章"), .href("/posts"))),
                            .li(.a(.text("关于"), .href("/about")))
                        )
                    )
                ),
                .div(
                    .class("wrapper"),
                    .h1("标签: \(page.tag.string)"),
                    .a(
                        .class("browse-all"),
                        .text("浏览所有标签"),
                        .href(context.site.tagListPath)
                    ),
                    .ul(
                        .class("item-list"),
                        .forEach(context.items(taggedWith: page.tag, sortedBy: \.date, order: .descending)) { item in
                            .li(
                                .article(
                                    .h3(.a(.href(item.path), .text(item.title))),
                                    .p(.text(item.description)),
                                    .p(.text("发布于: \(DateFormatter.blog.string(from: item.date))"))
                                )
                            )
                        }
                    )
                ),
                .footer(
                    .p(.text("© 2025 \(context.site.name). 使用 Swift Publish 构建。"))
                )
            )
        )
    }
}

// 日期格式化扩展
extension DateFormatter {
    static let blog: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
}

// 使用自定义主题的发布配置
try MyBlog().publish(
    at: Path("Output"),
    using: [
        .addMarkdownFiles(),
        .copyResources(),
        .generateHTML(withTheme: .custom),
        .generateRSSFeed(including: [.posts]),
        .generateSiteMap()
    ]
)
