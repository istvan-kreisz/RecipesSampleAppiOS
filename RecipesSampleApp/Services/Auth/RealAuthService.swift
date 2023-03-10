//
//  RealAuthService.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 2/6/23.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import Combine
import AuthenticationServices

enum AuthError: LocalizedError {
    case unknown
    case userNotFound
    case appleSignIn(error: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Auth Error"
        case .userNotFound:
            return "User Not Found"
        case let .appleSignIn(error):
            return "Apple Sign In Error: \(error)"
        }
    }
}

class RealAuthService: NSObject, AuthService {
    private weak var userWebRepository: (any UserWebRepository)?

    fileprivate var appleSignInContinuation: CheckedContinuation<Void, Error>? = nil

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    private var user: User? {
        get {
            UserDefaults.standard.user
        }
        set {
            UserDefaults.standard.user = newValue
        }
    }

    private var idToken: String? {
        get {
            UserDefaults.standard.idToken
        }
        set {
            UserDefaults.standard.idToken = newValue
        }
    }

    private let auth = Auth.auth()

    fileprivate var currentNonce: String?

    init(userWebRepository: any UserWebRepository) {
        self.userWebRepository = userWebRepository
        super.init()
        print(idToken)
        print(user)

        if DebugSettings.shared.useEmulators {
            auth.useEmulator(withHost: "localhost", port: 9100)
        }

        Task { @MainActor in
            await restoreState()
            authStateListenerHandle = auth.addStateDidChangeListener { [weak self] auth, user in
                guard let user else {
                    self?.user = nil
                    self?.idToken = nil
                    return
                }
                let userChanged = user.uid != self?.user?.id
                Task { [weak self] in
                    guard let self else { return }
                    do {
                        let token = try await user.getIDToken()
                        self.idToken = token

                        if userChanged {
                            let newUser = try await self.getUser(with: user.uid)
                            self.user = newUser
                        }
                    } catch {
                        try? await self.signOut()
                        self.user = nil
                        self.idToken = nil
                    }
                }
            }
        }
    }

    deinit {
        if let authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(authStateListenerHandle)
        }
    }

    private func getUser(with uuid: String) async throws -> User {
        if let userWebRepository {
            return try await userWebRepository.fetchUser(userId: uuid)
        } else {
            throw NSError(domain: "", code: 0)
        }
    }

    private func restoreState() async {
        do {
            if let currentUser = auth.currentUser {
                self.idToken = try await currentUser.getIDToken()
                self.user = try await self.getUser(with: currentUser.uid)
            } else if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                let googleUser = try await GIDSignIn.sharedInstance.restorePreviousSignIn()

                guard let idToken = googleUser.idToken else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: googleUser.accessToken.tokenString)
                try await auth.signIn(with: credential)
            } else {
                try await self.signOut()
            }
        } catch {
            log(error.localizedDescription, logLevel: .debug, logType: .auth)
        }
    }

    func signUpWith(email: String, password: String) async throws {
        do {
            _ = try await auth.createUser(withEmail: email, password: password)
        } catch {
            log(error, logLevel: .error, logType: .auth)
            throw error
        }
    }

    func signInWith(email: String, password: String) async throws {
        do {
            _ = try await auth.signIn(withEmail: email, password: password)
        } catch {
            log(error, logLevel: .error, logType: .auth)
            throw error
        }
    }

    func signOut() async throws {
        do {
            let signoutGoogle = GIDSignIn.sharedInstance.currentUser != nil
            try auth.signOut()
            if signoutGoogle {
                GIDSignIn.sharedInstance.signOut()
            }
        } catch {
            log(error, logLevel: .error, logType: .auth)
            throw error
        }
    }

    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
}

// MARK: - Sign in with Google

extension RealAuthService {
    func signInWithGoogle() async throws {
        do {
            guard let viewController = UIApplication.shared.keyWindowPresentedController else {
                throw AuthError.unknown
            }
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
            if result.user.userID == nil {
                throw AuthError.userNotFound
            }
        } catch {
            log(error, logLevel: .error, logType: .auth)
            throw error
        }
    }
}

// MARK: - Sign in with Apple

extension RealAuthService {
    func signInWithApple() async throws {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.appleSignInContinuation = continuation

            let nonce = randomNonceString()
            self?.currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)

            Task { @MainActor [weak self] in
                guard let self = self else { return }
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
        }
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

extension RealAuthService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        func throwError(message: String) {
            let error = AuthError.appleSignIn(error: message)
            self.appleSignInContinuation?.resume(throwing: error)
            self.appleSignInContinuation = nil
        }

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                throwError(message: "Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                throwError(message: "Unable to fetch identity token.")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                throwError(message: "Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            Task { [weak self] in
                guard let self = self else { return }
                do {
                    _ = try await self.auth.signIn(with: credential)
                    self.appleSignInContinuation?.resume()
                    self.appleSignInContinuation = nil
                } catch {
                    log(error, logLevel: .error, logType: .auth)
                    self.appleSignInContinuation?.resume(throwing: error)
                    self.appleSignInContinuation = nil
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleSignInContinuation?.resume(throwing: error)
        appleSignInContinuation = nil

        log("Sign in with Apple errored: \(error)", logLevel: .error, logType: .auth)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.keyWindow!
    }
}

extension UserDefaults {
    fileprivate(set) var user: User? {
        get {
            guard let userJSONString, let user = User(rawValue: userJSONString) else { return nil }
            return user
        }
        set {
            userJSONString = newValue?.rawValue
        }
    }

    @objc fileprivate(set) dynamic var userJSONString: String? {
        get {
            string(forKey: Keys.user.rawValue)
        }
        set {
            setValue(newValue, forKey: Keys.user.rawValue)
        }
    }

    fileprivate(set) var idToken: String? {
        get {
            string(forKey: Keys.idToken.rawValue)
        }
        set {
            setValue(newValue, forKey: Keys.idToken.rawValue)
        }
    }
}

enum UserUpdateStrategy {
    case userChanged
    case userUpdatedOrChanged
}

protocol UserListener {
    @MainActor var cancellable: AnyCancellable? { get set }
}

extension UserListener {
    func listenToUserUpdates(updateStrategy: UserUpdateStrategy, updated: @escaping (User?) -> Void) -> AnyCancellable? {
        UserDefaults.standard.publisher(for: \.userJSONString)
            .map { _ in UserDefaults.standard.user }
            .removeDuplicates(by: { first, second in
                if updateStrategy == .userChanged {
                    return first?.id == second?.id
                } else {
                    return first == second
                }
            })
            .sink(receiveValue: { newValue in
                updated(newValue)
            })
    }
}
