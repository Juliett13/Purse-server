import Vapor
import FluentSQLite

final class AccountController {
    
    func getList(_ req: Request) throws -> Future<[Account]> {
        let user = try req.requireAuthenticated(User.self)
        return try Account.query(on: req)
            .filter(\.userId == user.requireID()).all()
    }
    
    func getElem(_ req: Request) throws -> Future<Account> {
        let user = try req.requireAuthenticated(User.self)
        return try Account.find( req.parameters.next(Int.self), on: req)
            .unwrap(or: Abort(HTTPStatus.badRequest))
            .map { account in
                if account.userId != user.id {
                    throw Abort(HTTPStatus.badRequest)
                }
                return account
        }
    }
    
    func create(_ req: Request) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        return try req.content.decode(Account.self)
            .map(to: Account.self) { account in
                if account.userId != user.id {
                    throw Abort(HTTPStatus.badRequest)
                }
                return account
            }.create(on: req)
            .transform(to: HTTPStatus.created)
    }
}

