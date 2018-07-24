import FluentSQLite
import Vapor

final class Account: SQLiteModel {
    var id: Int?
    var sum: Int // !!!!!!
    var description: String
    var userId: User.ID
    
    init(id: Int? = nil, sum: Int, userId: User.ID, description: String) {
        self.id = id
        self.sum = sum
        self.userId = userId
        self.description = description
    }

    init() {
        self.id = 0
        self.sum = 0
        self.userId = 0
        self.description = ""
    }
}

extension Account: Content {}
extension Account: Migration {}
extension Account: Parameter { }
