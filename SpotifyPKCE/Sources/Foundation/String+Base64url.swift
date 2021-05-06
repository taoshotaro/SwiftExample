//
//  String+Base64URL.swift
//  SpotifyPKCE
//
//  Created by Shotaro Tao on 2021/05/02.
//

import Foundation
import CryptoKit

extension String {
    /// Converts base64 to base64url
    ///
    func base64ToBase64url() -> String {
        let base64url = replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }

    /// Converts base64url to base64
    ///
    /// https://tools.ietf.org/html/rfc4648#page-7
    func base64urlToBase64() -> String {
        var base64 = replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        return base64
    }

    /// Converts base64 to base64url
    ///
    /// https://tools.ietf.org/html/rfc4648#page-7
    public mutating func base64ToBase64url() {
        self = base64ToBase64url()
    }

    /// Converts base64url to base64
    ///
    /// https://tools.ietf.org/html/rfc4648#page-7
    public mutating func base64urlToBase64() {
        self = base64urlToBase64()
    }
}
