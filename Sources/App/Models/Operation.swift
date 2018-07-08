import FluentSQLite
import Vapor

final class Operation: SQLiteModel {
    
    static let incomeOperationId = 0
    static let outgoOperationId = 1
    static let transferOperationId = 2

    var id: Int?
    var operationTypeId: Int
    var sum: Int                // !!!!!!!!
    var firstAccoountid: Int
    var secondAccoountid: Int?  
    var date: Date
    var comment: String

    init(id: Int? = nil, operationTypeId: Int, sum: Int, firstAccoountid: Int, secondAccoountid: Int?, comment: String) {
        self.id = id
        self.operationTypeId = operationTypeId
        self.sum = sum
        self.firstAccoountid = firstAccoountid
        self.secondAccoountid = secondAccoountid
        date = Date()
        self.comment = comment
    }
    
    init() {
        self.id = 0
        self.operationTypeId = 0
        self.sum = 0
        self.firstAccoountid = 0
        self.secondAccoountid = 0
        date = Date()
        self.comment = ""
    }
    
}

extension Operation: Content {}
extension Operation: Migration {}
extension Operation: Parameter { }
