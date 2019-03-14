import Foundation


class Stopwatch {
    
    // MARK: - Auxiliary structures
    
    enum StopwatchState { case paused, running }

    
    // MARK: - Internal readonly properties
    
    private(set) var state: StopwatchState
    private(set) var centisecondsCounter: Int

    var formattedTime: String {
        let centiseconds = centisecondsCounter % 100
        let seconds = centisecondsCounter / 100 % 60
        let minutes = centisecondsCounter / 6000 % 60
        let hours = centisecondsCounter / 360000
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes, seconds, centiseconds)
    }
    
    
    // MARK: - Private properties
    
    private var updateTimeLabelCallback: () -> Void
    
    private var timer = Timer()
    
    
    // MARK: - Instance initializer
    
    init(state: StopwatchState, currentCentiseconds: Int, callbackOnFire: @escaping () -> Void) {
        self.state = state
        self.centisecondsCounter = currentCentiseconds
        self.updateTimeLabelCallback = callbackOnFire
    }
    
    
    // MARK: - Internal methods
    
    func toggle() {
        timer.isValid ? pause() : run()
    }
    
    func reset() {
        centisecondsCounter = 0
        
        updateTimeLabelCallback()
    }
    
    func restore(backgoundTime timeValue: Int) {
        centisecondsCounter += timeValue
    }
    
    // MARK: - Private accessory methods
    
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
