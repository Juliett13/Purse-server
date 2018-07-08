import Vapor

final class AccountController {
    
    func getList(_ req: Request) throws -> Future<[Account]> {
        return Account.query(on: req).all()
    }
    
    func getElem(_ req: Request) throws -> Future<Account> {
        return try Account.find( req.parameters.next(Int.self), on: req).unwrap(or: AccountError.noSuchAccount)
    }
    
    func create(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(Account.self).create(on: req).transform(to: .ok)
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Account.self).flatMap { a in
            return a.delete(on: req)
            }.transform(to: .ok)
    }
    
}

enum AccountError: Error {
    case noSuchAccount
}
