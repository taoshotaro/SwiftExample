//
//  SongManager.swift
//  MusicSeekBar
//
//  Created by 垰尚太朗 on 2021/05/04.
//

import Foundation
import Combine

class SongManager {
    let duration: TimeInterval = 200
    let currentTime = CurrentValueSubject<TimeInterval, Never>(.zero)
    var timer: Cancellable?
    
    func play() {
        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                self.currentTime.send(self.currentTime.value + 1)
            }
    }
    
    func pause() {
        timer?.cancel()
    }
    
    func seek(to: TimeInterval) {
        currentTime.send(to)
    }
}
