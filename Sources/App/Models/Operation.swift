import FluentSQLite
import Vapor

final class Operation: SQLiteModel {
    
    static let incomeOperationId = 0
    static let outgoOperationId = 1
    static let transferOperationId = 2

    var id: Int?
    var operationTypeId: OperationType.ID
    var sum: Int
    var firstAccountId: Account.ID
    var secondAccountId: Account.ID?
    var date: Date
    var comment: String
    
    init(id: Int? = nil, operationTypeId: OperationType.ID, sum: Int, firstAccountId: Account.ID, secondAccountId: Account.ID?, comment: String) {
        self.id = id
        self.operationTypeId = operationTypeId
        self.sum = sum
        self.firstAccountId = firstAccountId
        self.secondAccountId = secondAccountId
        date = Date()
        self.comment = comment
    }
    
    init() {
        self.id = 0
        self.operationTypeId = 0
        self.sum = 0
        self.firstAccountId = 0
        self.secondAccountId = 0
        date = Date()
        self.comment = ""
    }

    func willCreate(on conn: SQLiteConnection) throws -> EventLoopFuture<Operation> {
        if self.sum < 0 {
            throw Abort(HTTPStatus.badRequest)
        }
        return Future.map(on: conn) { self }
    }

}
    
extension Operation: Content {}
extension Operation: Migration {}
extension Operation: Parameter { }
