import UIKit


class ViewController: UIViewController {

    @IBOutlet weak private var toggleButton: UIButton!
    @IBOutlet weak private var resetButton: UIButton!
    
    @IBOutlet weak private var timeLabel: UILabel! {
        didSet {
            timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: UIFont.Weight.thin)
        }
    }
    
    var stopwatch: Stopwatch?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setForegroundObserver()
        initializeStopwatch()
    }
    
    
    private func setForegroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(foregroundEntered),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    
    @objc private func foregroundEntered() {
        guard let stopwatch = stopwatch else { return }
        
        stopwatch.centisecondsCounter += UserDefaults.standard.integer(forKey: "backgroundStopwatchValue")
    }
    
    
    private func initializeStopwatch() {
        let backgroundStopwatchValue = UserDefaults.standard.integer(forKey: "backgroundStopwatchValue")
        let suspendedStopwatchValue = UserDefaults.standard.integer(forKey: "suspendedStopwatchValue")
        
        let stopwatchIsRunning = UserDefaults.standard.bool(forKey: "stopwatchIsRunning")
        
        let currentCentiseconds = suspendedStopwatchValue + backgroundStopwatchValue
        
        stopwatch = Stopwatch(state: .paused, currentCentiseconds: currentCentiseconds, callbackOnFire: updateTimeLabel)
        updateTimeLabel()
        
        if stopwatchIsRunning {
            toggleButtonTapped(toggleButton)
        }
    }
    
    
    private func updateTimeLabel() {
        guard let stopwatch = stopwatch else { return }

        timeLabel.text = stopwatch.formattedTime
    }
    
    
    @IBAction private func toggleButtonTapped(_ sender: UIButton) {
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
    
    
    @IBAction private func resetButtonTapped(_ sender: UIButton) {
        guard let stopwatch = stopwatch else { return }
        
        stopwatch.reset()
    }
    
}

