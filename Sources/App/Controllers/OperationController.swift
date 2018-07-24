import Vapor
import SQLite
import FluentSQLite

final class OperationController {
    
    func getList(_ req: Request) throws -> Future<[Operation]> {
        return try listFilteredByUser(req).all()
    }
    
    func getElem(_ req: Request) throws -> Future<Operation> {
        return try listFilteredByUser(req)
            .filter(\Operation.id == req.parameters.next(Int.self))
            .first().unwrap(or: Abort(HTTPStatus.badRequest))
    }
    
    private func listFilteredByOperationType (with id: Int, _ req: Request) throws -> Future<[Operation]> {
        return try listFilteredByUser(req)
            .filter(\Operation.operationTypeId == id).all() 
    }
    
    private func listFilteredByUser(_ req: Request) throws -> QueryBuilder<SQLiteDatabase, Operation> {
        let user = try req.requireAuthenticated(User.self)
        return try Operation.query(on: req)
            .join(\Account.id, to: \Operation.firstAccountId)
            .filter(\Account.userId == user.requireID())
        
    }
    
    func getIncomeList(_ req: Request) throws -> Future<[Operation]> {
        return try listFilteredByOperationType(with: Operation.incomeOperationId, req)
    }
    
    
    func getOutgoList(_ req: Request) throws -> Future<[Operation]> {
        return try listFilteredByOperationType(with: Operation.outgoOperationId, req)
    }
    
    
    func getTransferList(_ req: Request) throws -> Future<[Operation]> {
        return try listFilteredByOperationType(with: Operation.transferOperationId, req)
    }
    
    func getListForAccount(_ req: Request) throws -> Future<[Operation]> {
        let _ = try req.requireAuthenticated(User.self)
        let accountId = try req.parameters.next(Int.self)
        return Operation.query(on: req)
            .group(.or) {
                $0.filter(\Operation.firstAccountId == accountId)
                    .filter(\Operation.secondAccountId == accountId)
            }
//            .filter(\Operation.firstAccountId == accountId)
            .all()
    }

    func getIncomeListForAccount(_ req: Request) throws -> Future<[Operation]> {
        return try getFilteredListForAccount(req, operationTypeId: Operation.incomeOperationId)
    }

    func getOutgoListForAccount(_ req: Request) throws -> Future<[Operation]> {
        return try getFilteredListForAccount(req, operationTypeId: Operation.outgoOperationId)
    }

    func getTransferListForAccount(_ req: Request) throws -> Future<[Operation]> {
        return try getFilteredListForAccount(req, operationTypeId: Operation.transferOperationId)
    }

    func getFilteredListForAccount(_ req: Request, operationTypeId: Int) throws -> Future<[Operation]> {
        let _ = try req.requireAuthenticated(User.self)
        let accountId = try req.parameters.next(Int.self)
        return Operation.query(on: req)
            .group(.or) {
                $0.filter(\Operation.firstAccountId == accountId)
                .filter(\Operation.secondAccountId == accountId)
            }
            .filter(\Operation.operationTypeId == operationTypeId)
            .all()
    }
    
    
    func createIncome(_ req: Request) throws -> Future<HTTPStatus> { //
        let user = try req.requireAuthenticated(User.self)
        var accId = 0, sum = 0, comment = ""
        
        _ = try req.content.decode(IncomeData.self)
            .map(to: IncomeData.self) { value in
                accId = value.accountId
                sum = value.sum
                comment = value.comment
                return value
        }
        
        return Account.find(accId, on: req).map(to: Account?.self) { account in
            if account?.userId != user.id {
                throw Abort(HTTPStatus.badRequest)
            }
            return account
            }.map(to: Operation.self) { account in
                if let account = account {
                    account.sum += sum
                    _ = account.save(on: req)
                }
                let op = Operation(operationTypeId: Operation.incomeOperationId, sum: sum, firstAccountId: accId, secondAccountId: nil, comment: comment)
                return op
            }.create(on: req).transform(to: .created)
    }
    
    
    func createOutgo(_ req: Request) throws -> Future<HTTPStatus> { //
        let user = try req.requireAuthenticated(User.self)
        var accId = 0, sum = 0, comment = ""
        
        _ = try req.content.decode(IncomeData.self).map(to: IncomeData.self) { value in
            accId = value.accountId
            sum = value.sum
            comment = value.comment
            return value
        }
        
        return Account.find(accId, on: req).map(to: Account?.self) { account in
            if account?.userId != user.id {
                throw Abort(HTTPStatus.badRequest)
            }
            return account
            }.map(to: Operation.self) { account in
                if let account = account {
                    account.sum -= sum
                    _ = account.save(on: req)
                }
                let op = Operation(operationTypeId: Operation.outgoOperationId, sum: sum, firstAccountId: accId, secondAccountId: nil, comment: comment)
                return op
            }.create(on: req).transform(to: .created)
    }
    
    
    func createTransfer(_ req: Request) throws -> Future<HTTPStatus> { //
        let user = try req.requireAuthenticated(User.self)
        var accId1 = 0, accId2 = 0, sum = 0, comment = ""
        
        _ = try req.content.decode(TransferData.self).map(to: TransferData.self) { value in
            accId1 = value.firstAccountId
            accId2 = value.secondAccountId
            sum = value.sum
            comment = value.comment
            return value
        }
        
        return Account.find(accId1, on: req).and(Account.find(accId2, on: req))
            .map(to: (Account?, Account?).self) { account1, account2 in
                if account1?.userId != user.id || account2?.userId != user.id || accId1 == accId2 {
                    throw Abort(HTTPStatus.badRequest)
                }
                return (account1, account2)
            }.map(to: Operation.self) { (account1, account2) in
                if let account1 = account1, let account2 = account2 {
                    account1.sum -= sum
                    _ = account1.save(on: req)
                    
                    account2.sum += sum
                    _ = account2.save(on: req)
                }
                let op = Operation(operationTypeId: Operation.transferOperationId, sum: sum, firstAccountId: accId1, secondAccountId: accId2, comment: comment)
                return op
            }.create(on: req).transform(to: .created)
    }
}




