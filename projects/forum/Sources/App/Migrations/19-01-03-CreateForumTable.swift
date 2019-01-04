//
// Created by Yun Ao on 2019-01-03.
//

import Foundation
import Fluent
import FluentMySQL

struct CreateForumTable: Migration {
    typealias Database = MySQLDatabase

    static func prepare(on conn: Database.Connection) -> Future<Void> {
        return Database.create(Forum.self, on: conn) {
            builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name)
        }
    }

    static func revert(on conn: Database.Connection) -> Future<Void> {
        return Database.delete(Forum.self, on: conn)
    }
}