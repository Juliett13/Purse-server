import FluentSQLite
import Vapor

final class IncomeData: SQLiteModel {
    var id: Int?
    var sum: Int = 0 //
    var comment: String = ""
    
    init(accId: Int?, sum: Int, comment: String) {
        self.id = accId
        self.sum = sum
        self.comment = comment
    }
}

extension IncomeData: Content {}
