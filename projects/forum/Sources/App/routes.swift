import Vapor

struct UserContext: Codable, Content {
    var username: String?
    var forums: [Forum]
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
}
