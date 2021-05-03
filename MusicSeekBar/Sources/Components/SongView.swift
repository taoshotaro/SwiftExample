//
//  SongView.swift
//  MusicSeekBar
//
//  Created by 垰尚太朗 on 2021/05/04.
//

import SwiftUI

struct SongView: View {
    let songManager = SongManager()
    
    @State var timeString = "00:00"

    var body: some View {
        VStack {
            Spacer()
            
            Button("Play") {
                songManager.play()
            }
            
            Button("Pause") {
                songManager.pause()
            }
            
            GeometryReader { geometry in
                SeekBar(
                    duration: songManager.duration,
                    currentTime: songManager.currentTime,
                    shouldSeek: { time in
                        songManager.seek(to: time)
                    }
                )
            }
            .frame(height: 100)
            .padding()
            
            Text(timeString)
                .font(.system(.body, design: .monospaced))
            
            Spacer()
        }
        .onReceive(songManager.currentTime) { time in
            let min = Int(time / 60)
            let sec = Int(time.truncatingRemainder(dividingBy: 60))
            
            timeString = String(format: "%02d:%02d", min, sec)
        }
    }
}

struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        SongView()
    }
}
