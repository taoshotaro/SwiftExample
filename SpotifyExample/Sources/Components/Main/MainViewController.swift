//
//  MainViewController.swift
//  SpotifyExample
//
//  Created by Shotaro Tao on 2021/04/30.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue

        // Do any additional setup after loading the view.
    }

    @IBAction func playMusicButtonTapped(_ sender: Any) {
        SpotifyClient.shared.play()
    }
}
