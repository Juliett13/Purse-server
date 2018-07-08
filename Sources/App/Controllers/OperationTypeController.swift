import Vapor

final class OperationTypeController {
    
    func getList(_ req: Request) throws -> Future<[OperationType]> {
        return OperationType.query(on: req).all()
    }
    
    func getElem(_ req: Request) throws -> Future<OperationType> {
        return try OperationType.find(req.parameters.next(Int.self), on: req).unwrap(or: OperationTypeError.noSuchType)
    }
}


enum OperationTypeError: Error {
    case noSuchType
}
