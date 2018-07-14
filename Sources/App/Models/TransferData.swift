import FluentSQLite
import Vapor

final class TransferData: SQLiteModel {
    var id: Int?
    var sum: Int //
    var comment: String
    var firstAccountId: Account.ID
    var secondAccountId: Account.ID

    init(id: Int?, id2: Int?, sum: Int, comment: String, firstAccountId: Account.ID, secondAccountId: Account.ID) {
        self.id = id
        self.sum = sum
        self.comment = comment
        self.firstAccountId  = firstAccountId
        self.secondAccountId = secondAccountId
    }
}

extension TransferData: Content {}
