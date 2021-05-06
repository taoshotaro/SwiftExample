//
//  MainViewController.swift
//  SpotifyPKCE
//
//  Created by Shotaro Tao on 2021/04/30.
//

import UIKit
import CryptoKit
import CommonCrypto

class MainViewController: UIViewController {
    var codeVerifier: String?
    var codeChallenge: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        // Do any additional setup after loading the view.

        let url = generateAuthURL()

        print("codeVerifier: ", codeVerifier)
        print("codeChallenge: ", codeChallenge)

        if let url = url {
            UIApplication.shared.open(url)
        }
    }

    func generateRandomString() -> String? {
        var bytes = [UInt8](repeating: 0, count: 32)
        let result = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

        guard result == errSecSuccess else { return nil }

        return Data(bytes).base64EncodedString().base64ToBase64url()
    }

    func sha256(string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    func generateAuthURL() -> URL? {
        guard let randomString = generateRandomString() else { return nil }

        codeVerifier = randomString
        codeChallenge = Data(SHA256.hash(data: Data(randomString.utf8))).base64EncodedString().base64ToBase64url()

        guard var base = URLComponents(string: "https://accounts.spotify.com/authorize") else { return nil }

        let queryItems = [
            URLQueryItem(name: "client_id", value: <#client_id#>),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: "spotify-pkce://spotify-login-callback"),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "state", value: "thisisthestate"),
            URLQueryItem(name: "scope", value: "app-remote-control")
        ]

        base.queryItems = queryItems
        return base.url
    }
}
