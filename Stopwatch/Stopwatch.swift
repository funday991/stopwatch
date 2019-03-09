import Foundation


class Stopwatch {
    
    enum State { case paused, running }
    
    var state: State
    var centisecondsCounter: Int
    var updateTimeLabelCallback: () -> Void
    
    var formattedTime: String {
        let centiseconds = centisecondsCounter % 100
        let seconds = centisecondsCounter / 100 % 60
        let minutes = centisecondsCounter / 6000 % 60
        let hours = centisecondsCounter / 360000
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes, seconds, centiseconds)
    }
    
    var timer: Timer?
    
    
    init(state: State, currentCentiseconds: Int, callbackOnFire: @escaping () -> Void) {
        self.state = state
        self.centisecondsCounter = currentCentiseconds
        self.updateTimeLabelCallback = callbackOnFire
    }
    
    
    func toggle() {
        switch state {
        case .paused:
            state = .running
            run()
        case .running:
            state = .paused            
            pause()
        }
    }
    
    
    func run() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    
    @objc func updateTime() {
        centisecondsCounter += 1
        
        updateTimeLabelCallback()
    }
    
    
    func pause() {
        guard let timer = timer else { return }
        
        timer.invalidate()
    }
    
    
    func reset() {
        centisecondsCounter = 0
        
        updateTimeLabelCallback()
    }
    
}
