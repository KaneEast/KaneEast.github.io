//import Publish
//import Plot
//
//extension Theme {
//    static var custom: Self {
//        Theme(
//            htmlFactory: CustomHTMLFactory(),
//            resourcePaths: ["Resources/styles.css"]
//        )
//    }
//}
//
//private struct CustomHTMLFactory<Site: Website>: HTMLFactory {
//    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
//        HTML(
//            .lang(context.site.language),
//            .head(for: index, on: context.site),
//            .body(
//                .header(for: context, selectedSection: nil),
//                .wrapper(
//                    .h1(.text(index.title)),
//                    .p(.text(index.description)),
//                    .h2("最新文章"),
//                    .itemList(for: context.allItems(sortedBy: \.date, order: .descending), on: context.site)
//                ),
//                .footer(for: context.site)
//            )
//        )
//    }
//    
//    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
//        HTML(
//            .lang(context.site.language),
//            .head(for: section, on: context.site),
//            .body(
//                .header(for: context, selectedSection: section.id),
//                .wrapper(
//                    .h1(.text(section.title)),
//                    .itemList(for: section.items, on: context.site)
//                ),
//                .footer(for: context.site)
//            )
//        )
//    }
//    
//    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
//        HTML(
//            .lang(context.site.language),
//            .head(for: item, on: context.site),
//            .body(
//                .header(for: context, selectedSection: item.sectionID),
//                .wrapper(
//                    .article(
//                        .div(
//                            .class("content"),
//                            .contentBody(item.body)
//                        ),
//                        .span("标签: "),
//                        .tagList(for: item, on: context.site)
//                    )
//                ),
//                .footer(for: context.site)
//            )
//        )
//    }
//    
//    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
//        HTML(
//            .lang(context.site.language),
//            .head(for: page, on: context.site),
//            .body(
//                .header(for: context, selectedSection: nil),
//                .wrapper(.contentBody(page.body)),
//                .footer(for: context.site)
//            )
//        )
//    }
//    
//    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
//        HTML(
//            .lang(context.site.language),
//            .head(for: page, on: context.site),
//            .body(
//                .header(for: context, selectedSection: nil),
//                .wrapper(
//                    .h1("所有标签"),
//                    .ul(
//                        .class("all-tags"),
//                        .forEach(page.tags.sorted()) { tag in
//                            .li(
//                                .class("tag"),
//                                .a(
//                                    .href(context.site.path(for: tag)),
//                                    .text(tag.string)
//                                )
//                            )
//                        }
//                    )
//                ),
//                .footer(for: context.site)
//            )
//        )
//    }
//    
//    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
//        HTML(
//            .lang(context.site.language),
//            .head(for: page, on: context.site),
//            .body(
//                .header(for: context, selectedSection: nil),
//                .wrapper(
//                    .h1("标签: ", .text(page.tag.string)),
//                    .a(
//                        .class("browse-all"),
//                        .text("浏览所有标签"),
//                        .href(context.site.tagListPath)
//                    ),
//                    .itemList(
//                        for: context.items(taggedWith: page.tag, sortedBy: \.date, order: .descending),
//                        on: context.site
//                    )
//                ),
//                .footer(for: context.site)
//            )
//        )
//    }
//}
