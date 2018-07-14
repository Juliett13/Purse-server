import FluentSQLite
import Vapor

final class IncomeData: SQLiteModel {
    var id: Int?
    var sum: Int //
    var comment: String
    var accountId: Account.ID
    
    init(accId: Int?, sum: Int, comment: String, accountId: Account.ID) {
        self.id = accId
        self.sum = sum
        self.comment = comment
        self.accountId = accountId
    }
}

extension IncomeData: Content {}
