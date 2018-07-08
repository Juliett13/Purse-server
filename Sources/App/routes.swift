import Vapor

public func routes(_ router: Router) throws {
    
    let opTypeController = OperationTypeController()
    router.get("operationType", use: opTypeController.getList)
    router.get("operationType", Int.parameter, use: opTypeController.getElem)
    
    
    let accountController = AccountController()
    router.get("account", use: accountController.getList)
    router.get("account", Int.parameter, use: accountController.getElem)
    router.post("account", use: accountController.create)
    router.delete("account", Account.parameter, use: accountController.delete)

    
    let operationController = OperationController()
    router.get("operation", use: operationController.getList)
    router.get("operation", Int.parameter, use: operationController.getElem)
//    router.delete("operation", Operation.parameter, use: operationController.delete)
   
    router.post("operation", "income", use: operationController.createIncome)
    router.post("operation", "outgo", use: operationController.createOutgo)
    router.post("operation", "transfer", use: operationController.createTransfer)
    
    router.get("operation", "income", use: operationController.getIncomeList)
    router.get("operation", "outgo", use: operationController.getOutgoList)
    router.get("operation", "transfer", use: operationController.getTransferList)

}
