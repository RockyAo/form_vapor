//
// Created by Yun Ao on 2019-01-03.
//

import Foundation
import Fluent
import FluentMySQL

struct ForumSeeder: Migration {
    typealias Database = MySQLDatabase

    static func prepare(on conn: Database.Connection) -> Future<Void> {
        return [1,2,3]
            .map { Forum(name: "Forum \($0!)") }
            .map { $0.save(on: conn) }
            .flatten(on: conn)
            .transform(to: Void())
    }

    static func revert(on conn: Database.Connection) -> Future<Void> {
        return conn.query("truncate table 'Forum'")
            .transform(to: Void())
    }
}