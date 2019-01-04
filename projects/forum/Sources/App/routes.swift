import Vapor
import Fluent
import FluentMySQL

struct UserContext: Codable, Content {
    var username: String?
    var forums: [Forum]
}

struct MessageContext: Codable, Content {
    var username: String?
    var forum: Forum
    var messages: [Message]
}

func getUsername() -> String?{
    return "rocky"
}

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }

    router.get("forums") {
        req -> Future<Response> in

        return Forum.query(on: req)
                .all()
                .map(to: UserContext.self) { forums -> UserContext in
                    return UserContext(username: getUsername(), forums: forums)
                }
                .encode(status: .created, for: req)
    }

    router.group("forums",Int.parameter) {
        group in

        group.get("messages") {
            req -> Future<Response> in
            let forumId = try req.parameters.next(Int.self)

            return Forum.find(forumId, on: req).flatMap(to: Response.self) {
                forum in
                guard let forum = forum else { throw Abort(.notFound) }

                return Message.query(on: req)
                        .filter(\.forumID == forum.id!)
                        .filter(\.originID == 0)
                        .all()
                        .map {
                            return MessageContext(
                                    username: "bx11",
                                    forum: forum,
                                    messages: $0)
                        }
                        .encode(status: .ok, for: req)
            }
        }
    }
}
