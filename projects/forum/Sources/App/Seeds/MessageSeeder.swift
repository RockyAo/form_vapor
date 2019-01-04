//
// Created by Yun Ao on 2019-01-04.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL

struct MessageSeeder: Migration {
    typealias Database = MySQLDatabase

    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        var messageId = 0
        return [1, 2, 3].flatMap {
                    forum in
                    return [1, 2, 3].map {
                        message -> Message in
                        messageId += 1

                        return Message(
                                id: messageId,
                                forumID: forum,
                                title: "Title \(message) in Forum \(forum)",
                                content: "Body \(message) in Forum \(forum)",
                                originID: 0,
                                author: "bx11",
                                createdAt: Date())
                    }
                }
                .map { $0.create(on: conn) }
                .flatten(on: conn)
                .transform(to: ())
    }

    static func revert(
            on conn: Database.Connection) -> Future<Void> {
        return conn.query("truncate table `Message`")
                .transform(to: Void())
    }
}
