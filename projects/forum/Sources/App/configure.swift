import FluentMySQL
import Vapor
import Fluent

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    let mysqlHost: String
    let mysqlPort: Int
    let mysqlDB: String
    let mysqlUser: String
    let mysqlPassword: String

    if env == .development || env == .testing {
        print("Under dev or testing mode")
        mysqlHost = "mysql"
        mysqlPort = 3306
        mysqlDB = "vapor"
        mysqlUser = "vapor"
        mysqlPassword = "vapor"
    } else {
        print("Under production mode")
        mysqlHost = Environment.get("MYSQL_HOST") ?? "mysql"
        mysqlPort = 3306
        mysqlDB = Environment.get("MYSQL_DB") ?? "vapor"
        mysqlUser = Environment.get("MYSQL_USER") ?? "vapor"
        mysqlPassword = Environment.get("MYSQL_PASS") ?? "vapor"
    }

    var databases = DatabasesConfig()

    let mysqlConfig = MySQLDatabaseConfig(
            hostname: mysqlHost,
            port: mysqlPort,
            username: mysqlUser,
            password: mysqlPassword,
            database: mysqlDB,
            transport: .unverifiedTLS)

    let mysqlDatabase = MySQLDatabase(config: mysqlConfig)

    databases.add(database: mysqlDatabase, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    Forum.defaultDatabase = .mysql
    Message.defaultDatabase = .mysql
//    migrations.add(migration: CreateForumTable.self, database: .mysql)
    migrations.add(model: Forum.self, database: .mysql)
    migrations.add(model: Message.self, database: .mysql)
    if env == .development {
        migrations.add(migration: ForumSeeder.self, database: .mysql)
        migrations.add(migration: MessageSeeder.self, database: .mysql)
    }

    services.register(migrations)

    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}
