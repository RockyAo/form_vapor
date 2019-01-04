//
// Created by Yun Ao on 2019-01-04.
//

import Foundation
import Vapor
import FluentMySQL
import Fluent

struct Message: Content, MySQLModel {
    var id: Int?
    var forumID: Int
    var title: String
    var content: String
    var originID: Int
    var author: String
    var createdAt: TimeInterval

    init(id: Int?, forumID: Int, title: String, content: String, originID: Int, author: String, createdAt: Date) {
        self.id = id
        self.forumID = forumID
        self.title = title
        self.content = content
        self.originID = originID
        self.author = author
        self.createdAt = createdAt.timeIntervalSince1970
    }
}

extension Message: Migration {
    public static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return Database.create(Message.self, on: conn) {
            builder in
            try addProperties(to: builder)
        }
    }

    public static func revert(on conn: MySQLConnection) -> Future<Void> {
        return  Database.delete(Message.self, on: conn)
    }
}