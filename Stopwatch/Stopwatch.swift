import Foundation


class Stopwatch {
    
    enum State { case paused, running }

    
    // MARK: - Stopwatch public constants and variables
    
    var state: State
    var centisecondsCounter: Int

    var formattedTime: String {
        let centiseconds = centisecondsCounter % 100
        let seconds = centisecondsCounter / 100 % 60
        let minutes = centisecondsCounter / 6000 % 60
        let hours = centisecondsCounter / 360000
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes, seconds, centiseconds)
    }
    
    
    // MARK: - Stopwatch private constants and variables
    
    private var updateTimeLabelCallback: () -> Void
    
    private var timer = Timer()
    
    
    // MARK: - Instance initializer
    
    init(state: State, currentCentiseconds: Int, callbackOnFire: @escaping () -> Void) {
        self.state = state
        self.centisecondsCounter = currentCentiseconds
        self.updateTimeLabelCallback = callbackOnFire
    }
    
    
    // MARK: - Public stopwatch methods
    
    func toggle() {
        timer.isValid ? pause() : run()
    }
    
    func reset() {
        centisecondsCounter = 0
        
        updateTimeLabelCallback()
    }
    
    
    // MARK: - Private accessory stopwatch functions
    
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
    
}
