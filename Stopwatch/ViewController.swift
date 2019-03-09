import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var stopwatch: Stopwatch?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: nil
        ) { (notification) in
            guard let stopwatch = self.stopwatch else { return }
            
            stopwatch.centisecondsCounter += UserDefaults.standard.integer(forKey: "backgroundStopwatchValue")
        }
        
        let backgroundStopwatchValue = UserDefaults.standard.integer(forKey: "backgroundStopwatchValue")
        let suspendedValue = UserDefaults.standard.integer(forKey: "suspendedValue")
        
        let stopwatchIsRunning = UserDefaults.standard.bool(forKey: "stopwatchIsRunning")
        
        let currentCentiseconds = suspendedValue + backgroundStopwatchValue
    
        stopwatch = Stopwatch(state: .paused, currentCentiseconds: currentCentiseconds, callbackOnFire: updateTimeLabel)
        updateTimeLabel()
        
        if stopwatchIsRunning {
            toggleButtonTapped(toggleButton)
        }
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: UIFont.Weight.thin)
    }
    
    
    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        guard let stopwatch = stopwatch else { return }
        
        stopwatch.toggle()
        
        switch stopwatch.state {
        case .running:
            toggleButton.setTitleColor(.red, for: .normal)
            toggleButton.setTitle("Pause", for: .normal)
            resetButton.isEnabled = false
        case .paused:
            toggleButton.setTitleColor(.green, for: .normal)
            toggleButton.setTitle("Run", for: .normal)
            resetButton.isEnabled = true
        }
    }
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        guard let stopwatch = stopwatch else { return }

        stopwatch.reset()
    }
    
    
    func updateTimeLabel() {
        guard let stopwatch = stopwatch else { return }

        timeLabel.text = stopwatch.formattedTime
    }
    
}

