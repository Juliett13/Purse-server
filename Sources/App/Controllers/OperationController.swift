import Vapor
import SQLite
import FluentSQLite

final class OperationController {
    
    func getList(_ req: Request) throws -> Future<[Operation]> {
        return Operation.query(on: req).sort(\.date, .descending).all()
    }

    
    func getElem(_ req: Request) throws -> Future<Operation> {
        return try Operation.find(req.parameters.next(Int.self), on: req).unwrap(or: OperationError.noSuchOperation)
    }


    func filteredList(_ req: Request, _ operationTypeId: Int) -> Future<[Operation]> {
        return Operation.query(on: req).filter(\.operationTypeId == operationTypeId).sort(\.date, .descending).all()
    }

    
    func getIncomeList(_ req: Request) throws -> Future<[Operation]> {
        return filteredList(req, Operation.incomeOperationId)
    }
    
    
    func getOutgoList(_ req: Request) throws -> Future<[Operation]> {
        return filteredList(req, Operation.outgoOperationId)
    }
    
    
    func getTransferList(_ req: Request) throws -> Future<[Operation]> {
        return filteredList(req, Operation.transferOperationId)
    }
    
    
    func createIncome(_ req: Request) throws -> Future<HTTPStatus> {
        
        var accId = 0, sum = 0, comment = ""
    
        _ = try req.content.decode(IncomeData.self).map(to: IncomeData.self) { value in
            accId = value.id!
            sum = value.sum
            comment = value.comment
            return value
        }
        
        _ = Account.find(accId, on: req).map(to: Account.self) { account in
            account!.sum += sum
            _ = account!.save(on: req)
            return account!
        }
        
        let op = Operation(operationTypeId: Operation.incomeOperationId, sum: sum, firstAccoountid: accId, secondAccoountid: nil, comment: comment)
        return op.create(on: req).transform(to: .ok)
        
    }
    
    
    func createOutgo(_ req: Request) throws -> Future<HTTPStatus> {
        var accId = 0, sum = 0, comment = ""
        
        _ = try req.content.decode(IncomeData.self).map(to: IncomeData.self) { value in
            accId = value.id!
            sum = value.sum
            comment = value.comment
            return value
        }
        
        _ =  Account.find(accId, on: req).map(to: Account.self) { account in
            account!.sum -= sum
            _ = account!.save(on: req)
            return account!
        }
        
        let op = Operation(operationTypeId: Operation.outgoOperationId, sum: sum, firstAccoountid: accId, secondAccoountid: nil, comment: comment)
        return  op.create(on: req).transform(to: .ok)
    }
    
    
    func createTransfer(_ req: Request) throws -> Future<HTTPStatus> {
        var accId1 = 0, accId2 = 0, sum = 0, comment = ""
        
        _ = try req.content.decode(TransferData.self).map(to: TransferData.self) { value in
            accId1 = value.id!
            accId2 = value.id2!
            sum = value.sum
            comment = value.comment
            return value
        }
        
        _ = Account.find(accId1, on: req).map(to: Account.self) { account in
            account!.sum -= sum
            _ = account!.save(on: req)
            return account!
        }

        _ = Account.find(accId2, on: req).map(to: Account.self) { account in
            account!.sum += sum
            _ = account!.save(on: req)
            return account!
        }
        
        let op = Operation(operationTypeId: Operation.transferOperationId, sum: sum, firstAccoountid: accId1, secondAccoountid: accId2, comment: comment)
        return op.create(on: req).transform(to: .ok)
    }
    
}


enum OperationError: Error {
    case noSuchOperation
}

