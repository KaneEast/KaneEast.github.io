import Foundation
import Publish
import Plot

struct MyBlog: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {}

    var url = URL(string: "https://kaneeast.github.io/MyBlog")!
    var name = "我的博客"
    var description = "用 Swift Publish 创建的个人博客"
    var language: Language { .chinese }
    var imagePath: Path? { nil }
}

extension Theme {
    static var custom: Self {
        Theme(
            htmlFactory: CustomHTMLFactory(),
            resourcePaths: ["Resources/CustomTheme/styles.css"] // 保持原来的配置
        )
    }
}

// 修复后的CustomHTMLFactory
private struct CustomHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(
                .meta(.charset(.utf8)),
                .meta(.name("viewport"), .content("width=device-width, initial-scale=1")),
                .title(index.title),
                .description(index.description),
                // 修复：使用正确的CSS链接格式
                .stylesheet("/styles.css")
            ),
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
                    .h1(.text(index.title)),
                    .p(.text(index.description)),
                    .h2("最新文章"),
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
                .footer(
                    .p(.text("© 2025 \(context.site.name). 使用 Swift Publish 构建。"))
                )
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(
                .meta(.charset(.utf8)),
                .meta(.name("viewport"), .content("width=device-width, initial-scale=1")),
                .title(section.title),
                .stylesheet("/styles.css")
            ),
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
            .head(
                .meta(.charset(.utf8)),
                .meta(.name("viewport"), .content("width=device-width, initial-scale=1")),
                .title(item.title),
                .stylesheet("/styles.css")
            ),
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
            .head(
                .meta(.charset(.utf8)),
                .meta(.name("viewport"), .content("width=device-width, initial-scale=1")),
                .title(page.title),
                .stylesheet("/styles.css")
            ),
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
            .head(
                .meta(.charset(.utf8)),
                .meta(.name("viewport"), .content("width=device-width, initial-scale=1")),
                .title("所有标签"),
                .stylesheet("/styles.css")
            ),
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
            .head(
                .meta(.charset(.utf8)),
                .meta(.name("viewport"), .content("width=device-width, initial-scale=1")),
                .title("标签: \(page.tag.string)"),
                .stylesheet("/styles.css")
            ),
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

// 日期格式化
extension DateFormatter {
    static let blog: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
}

// 发布配置
try MyBlog().publish(using: [
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .custom),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap()
])
