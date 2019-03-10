import Foundation


class Stopwatch {
    
    enum State { case paused, running }
    
    var state: State
    var centisecondsCounter: Int
    private var updateTimeLabelCallback: () -> Void
    
    var formattedTime: String {
        let centiseconds = centisecondsCounter % 100
        let seconds = centisecondsCounter / 100 % 60
        let minutes = centisecondsCounter / 6000 % 60
        let hours = centisecondsCounter / 360000
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes, seconds, centiseconds)
    }
    
    private var timer = Timer()
    
    
    init(state: State, currentCentiseconds: Int, callbackOnFire: @escaping () -> Void) {
        self.state = state
        self.centisecondsCounter = currentCentiseconds
        self.updateTimeLabelCallback = callbackOnFire
    }
    
    
    func toggle() {
        timer.isValid ? pause() : run()
    }
    
    
    private func run() {
        state = .running

        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    
    @objc private func updateTime() {
        centisecondsCounter += 1
        
        updateTimeLabelCallback()
    }
    
    
    private func pause() {
        state = .paused
        
        timer.invalidate()
    }
    
    
    func reset() {
        centisecondsCounter = 0
    
        updateTimeLabelCallback()
    }
    
}
