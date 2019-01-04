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
    var createdAt: Date
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