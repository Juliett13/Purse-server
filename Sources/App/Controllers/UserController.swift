import Foundation
import Vapor
import Authentication

final class UserController {
    func createUser(_ request: Request) throws -> Future<User.PublicUser> {
        return try request.content.decode(User.self).flatMap(to: User.PublicUser.self) { user in
            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
            let newUser = User(name: user.name, password: passwordHashed)
            return newUser.save(on: request).flatMap(to: User.PublicUser.self) { createdUser in
                let accessToken = Token(for: createdUser)
                return accessToken.save(on: request).map(to: User.PublicUser.self) { createdToken in
                    let publicUser = User.PublicUser(username: createdUser.name, token: createdToken.token)
                    return publicUser
                }
            }
        }
    }
    
    func loginUser(_ request: Request) throws -> Future<User.PublicUser> {
        return try request.content.decode(User.self).flatMap(to: User.PublicUser.self) { user in
            let passwordVerifier = try request.make(BCryptDigest.self)
            return User.authenticate(username: user.name, password: user.password, using: passwordVerifier, on: request)
                .unwrap(or: Abort(HTTPResponseStatus.unauthorized)).flatMap(to: User.PublicUser.self) { createdUser in
                    let accessToken = Token(for: createdUser)
                    return accessToken.save(on: request).map(to: User.PublicUser.self) { createdToken in
                        let publicUser = User.PublicUser(username: createdUser.name, token: createdToken.token)
                        return publicUser
                    }
            }
        }
    }
    
}
