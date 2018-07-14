import Foundation
import Vapor
import FluentSQLite
import Authentication

final class Token: SQLiteModel {
    var id: Int?
    var token: String
    var userId: User.ID
    
    init(token: String, userId: User.ID) {
        self.token = token
        self.userId = userId
    }
    
    init(for user: User) {
        self.token = Token.randomToken(with: 60)
        do {
            self.userId = try user.requireID()
        } catch {
            self.userId = 0
        }
    }
}

extension Token: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<Token, String> { return \Token.token }
}

extension Token: Authentication.Token {
    static var userIDKey: WritableKeyPath<Token, User.ID> { return \Token.userId }
    typealias UserType = User
    typealias UserIDType = User.ID
}

extension Token: Content { }
extension Token: Migration { }

extension Token {
    static func randomToken(with length: Int) -> String {
        let allowedChars = "$!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        for _ in 0..<length {
            let randomNumber = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNumber)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        return randomString
    }
}

