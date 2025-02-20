import SwiftUI

struct TimerView: View {
    let minutes: Int
    let recipeName: String
    let timerType: String // "Prep" or "Cook"
    
    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var timer: Timer?
    
    init(minutes: Int, recipeName: String, timerType: String) {
        self.minutes = minutes
        self.recipeName = recipeName
        self.timerType = timerType
        self._timeRemaining = State(initialValue: minutes * 60)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(timeString(from: timeRemaining))
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(isRunning ? .accentColor : .primary)
            
            HStack(spacing: 20) {
                Button(action: {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    HStack {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        Text(isRunning ? "Pause" : "Start")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(isRunning ? Color.orange : Color.green)
                    .cornerRadius(8)
                }
                
                if timeRemaining < minutes * 60 {
                    Button(action: resetTimer) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Reset")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
        .onDisappear {
            stopTimer()
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func resetTimer() {
        stopTimer()
        timeRemaining = minutes * 60
    }
} 