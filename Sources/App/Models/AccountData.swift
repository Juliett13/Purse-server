import FluentSQLite
import Vapor

final class AccountData: SQLiteModel {
    var id: Int?
    var sum: Int // !!!!!!
    var description: String

    init(id: Int? = nil, sum: Int, description: String) {
        self.id = id
        self.sum = sum
        self.description = description
    }
}

extension AccountData: Content {}
