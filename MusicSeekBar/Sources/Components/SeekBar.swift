//
//  SeekBar.swift
//  MusicSeekBar
//
//  Created by 垰尚太朗 on 2021/05/04.
//

import SwiftUI
import Combine

struct SeekBar: View {
    let duration: TimeInterval
    let currentTime: CurrentValueSubject<TimeInterval, Never>
    
    @State private var _currentTime: TimeInterval = .zero
    @State private var isSeeking: Bool = false
    @State private var tmpWidth: CGFloat = .zero
    
    let shouldSeek: (TimeInterval) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color("appgray"))
                Rectangle()
                    .foregroundColor(Color("applightgray"))
                    .frame(width: geometry.size.width * CGFloat(_currentTime / duration))
            }
            .cornerRadius(12)
            .gesture(
                LongPressGesture()
                    .onEnded { _ in
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        
                        withAnimation {
                            isSeeking = true
                        }
                    }
                    .sequenced(
                        before: DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let shiftPercentage = (value.translation.width - tmpWidth) / geometry.size.width
                                let shiftTimeInterval = Double(shiftPercentage) * duration
                                
                                _currentTime = min(duration, _currentTime + shiftTimeInterval)
                                
                                tmpWidth = value.translation.width
                            }
                            .onEnded { _ in
                                tmpWidth = .zero
                                withAnimation {
                                    isSeeking = false
                                }
                                
                                shouldSeek(_currentTime)
                            }
                    )
            )
        }
        .scaleEffect(isSeeking ? 0.95 : 1)
        .onReceive(currentTime) { time in
            guard !isSeeking else { return }
            _currentTime = time
        }
    }
}

struct SeekBar_Previews: PreviewProvider {
    static var previews: some View {
        SeekBar(duration: 100, currentTime: .init(40), shouldSeek: { _ in })
            .previewLayout(.fixed(width: 200, height: 50))
    }
}
