import Vapor

final class OperationTypeController {
    
    /// Returns a list of all operation types.
    func getList(_ req: Request) throws -> Future<[OperationType]> {
        return OperationType.query(on: req).all()
    }
    
    /// Returns operation type
    func getElem(_ req: Request) throws -> Future<OperationType> {
        return try OperationType.find(req.parameters.next(Int.self), on: req) ?? OperationType(id: 0, name: "") // ??

//        guard let ot = try OperationType.find(req.parameters.next(Int.self), on: req) else {
//            throw OperationTypeError.noSuchType
//        }
//        return ot

    }
    
    /// Saves a decoded operation type to the database.
    func create(_ req: Request) throws -> Future<OperationType> {
        return try req.content.decode(OperationType.self).create(on: req)
    }

    /// Deletes a parameterized operation type.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(OperationType.self).flatMap { ot in
            return ot.delete(on: req)
        }.transform(to: .ok)
    }
}


//enum OperationTypeError: Error {
//    case noSuchType
//}
