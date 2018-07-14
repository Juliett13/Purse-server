import Vapor
import FluentSQLite
import Authentication

final class User: SQLiteModel {
    var id: Int?
    var name: String
    var password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    struct PublicUser: Content {
        var username: String
        var token: String
    }
}

extension User: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> { return \User.name }
    static var passwordKey: WritableKeyPath<User, String> { return \User.password }
}

extension User: TokenAuthenticatable { typealias TokenType = Token }

extension User: Migration { }
extension User: Content { }
extension User: Parameter { }
