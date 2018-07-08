import FluentSQLite
import Vapor

final class TransferData: SQLiteModel {
    var id: Int?
    var id2: Int?
    var sum: Int = 0 //
    var comment: String = ""
    
    init(id: Int?, id2: Int?, sum: Int, comment: String) {
        self.id = id
        self.id2 = id2
        self.sum = sum
        self.comment = comment
    }
}

extension TransferData: Content {}
