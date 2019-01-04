//
// Created by Yun Ao on 2019-01-03.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL

struct Forum: Content, MySQLModel {
    var id: Int?
    var name: String

    init(id: Int?, name: String) {
        self.id = id
        self.name = name
    }

    init(name: String) {
        self.init(id: nil, name: name)
    }
}

extension Forum: Migration {

}