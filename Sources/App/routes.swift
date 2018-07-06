import Vapor

public func routes(_ router: Router) throws {
    
    let opTypeController = OperationTypeController()
    router.get("operationType", use: opTypeController.getList)
    router.get("operationType", Int.parameter, use: opTypeController.getElem)
    router.post("operationType", use: opTypeController.create)
    router.delete("operationType", OperationType.parameter, use: opTypeController.delete)
}
