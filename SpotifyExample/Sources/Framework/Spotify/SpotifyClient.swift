//
//  Spotify.swift
//  SpotifyExample
//
//  Created by Shotaro Tao on 2021/04/30.
//

import SpotifyiOS

class SpotifyClient: NSObject {
    static var shared = SpotifyClient()

    static private let kAccessTokenKey = "access-token-key"
    let spotifyClientID: String = <#client_id#>
    let spotifyRedirectURL = URL(string: "spotify-example://spotify-login-callback")!

    lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: spotifyRedirectURL
    )

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: SpotifyClient.kAccessTokenKey)
        }
    }

    private var playerState: SPTAppRemotePlayerState?

    func authorize(url: URL) {
        let parameters = appRemote.authorizationParameters(from: url);

        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            print("Token: ", access_token)
            self.accessToken = access_token
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
    }

    func play() {
        if appRemote.isConnected == false {
            if appRemote.authorizeAndPlayURI("") == false {
                // The Spotify app is not installed, present the user with an App Store page
                print("SHOW APP STORE")
            }
        } else if playerState == nil ||  playerState!.isPaused {
            startPlayback()
        } else {
            pausePlayback()
        }
    }

    private func startPlayback() {
        appRemote.playerAPI?.resume { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    private func pausePlayback() {
        appRemote.playerAPI?.pause { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension SpotifyClient: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("connected")
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
}

extension SpotifyClient: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("player state changed")
        print("isPaused", playerState.isPaused)
        print("track.uri", playerState.track.uri)
        print("track.name", playerState.track.name)
        print("track.imageIdentifier", playerState.track.imageIdentifier)
        print("track.artist.name", playerState.track.artist.name)
        print("track.album.name", playerState.track.album.name)
        print("track.isSaved", playerState.track.isSaved)
        print("playbackSpeed", playerState.playbackSpeed)
        print("playbackOptions.isShuffling", playerState.playbackOptions.isShuffling)
        print("playbackOptions.repeatMode", playerState.playbackOptions.repeatMode.hashValue)
        print("playbackPosition", playerState.playbackPosition)
        
        self.playerState = playerState
    }
}
