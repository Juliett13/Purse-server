import Vapor

public func routes(_ router: Router) throws {
    
    let opTypeController = OperationTypeController()
    router.get("operationType", use: opTypeController.getList)
    router.get("operationType", Int.parameter, use: opTypeController.getElem)
    
    let userController = UserController()
    router.post("user", use: userController.createUser)
    router.post("user", "login", use: userController.loginUser)
    
    let tokenAuthenticationMiddleware = User.tokenAuthMiddleware()
    let authedRoutes = router.grouped(tokenAuthenticationMiddleware)
        
    let accountController = AccountController()
    authedRoutes.get("account", use: accountController.getList)
    authedRoutes.get("account", Int.parameter, use: accountController.getElem)
    authedRoutes.post("account", use: accountController.create)

    let operationController = OperationController()
    authedRoutes.get("operation", use: operationController.getList)
    authedRoutes.get("operation", Int.parameter, use: operationController.getListForAccount)

    authedRoutes.post("operation", "income", use: operationController.createIncome)
    authedRoutes.post("operation", "outgo", use: operationController.createOutgo)
    authedRoutes.post("operation", "transfer", use: operationController.createTransfer)

    authedRoutes.get("operation", "income", Int.parameter, use: operationController.getIncomeListForAccount)
    authedRoutes.get("operation", "outgo", Int.parameter, use: operationController.getOutgoListForAccount)
    authedRoutes.get("operation", "transfer", Int.parameter, use: operationController.getTransferListForAccount)
    
    authedRoutes.get("operation", "income", use: operationController.getIncomeList)
    authedRoutes.get("operation", "outgo", use: operationController.getOutgoList)
    authedRoutes.get("operation", "transfer", use: operationController.getTransferList)
}
