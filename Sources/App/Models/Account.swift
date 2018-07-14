import FluentSQLite
import Vapor

final class Account: SQLiteModel {
    var id: Int?
    var sum: Int // !!!!!!
    var userId: User.ID
    
    init(id: Int? = nil, sum: Int, userId: User.ID) {
        self.id = id
        self.sum = sum
        self.userId = userId
    }

    init() {
        self.id = 0
        self.sum = 0
        self.userId = 0
    }
}

extension Account: Content {}
extension Account: Migration {}
extension Account: Parameter { }
