import FluentSQLite
import Vapor

final class OperationType: SQLiteModel {

    var id: Int?
    var name: String
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }

}
extension OperationType: Content {}
extension OperationType: Migration {}
extension OperationType: Parameter { }
