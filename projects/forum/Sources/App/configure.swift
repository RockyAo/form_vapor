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

    var databases = DatabasesConfig()

    let mysqlConfig = MySQLDatabaseConfig(
            hostname: "mysql",
            port: 3306,
            username: "vapor",
            password: "vapor",
            database: "vapor",
            transport: .unverifiedTLS)

    let mysqlDB = MySQLDatabase(config: mysqlConfig)

    databases.add(database: mysqlDB, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(migration: CreateForumTable.self, database: .mysql)
    services.register(migrations)

    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}
