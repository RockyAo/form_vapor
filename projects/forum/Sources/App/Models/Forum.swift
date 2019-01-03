//
// Created by Yun Ao on 2019-01-03.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL

struct Forum: Content, MySQLModel, Migration {
    var id: Int?
    var name: String
}