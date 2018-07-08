import FluentSQLite
import Vapor

final class Account: SQLiteModel {
    
    var id: Int?
    var sum: Int // !!!!!!
    
    init(id: Int? = nil, sum: Int) {
        self.id = id
        self.sum = sum
    }

    init() {
        self.id = 0
        self.sum = 0
    }
    
}
extension Account: Content {}
extension Account: Migration {}
extension Account: Parameter { }
