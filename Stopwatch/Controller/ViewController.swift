import UIKit


class ViewController: UIViewController {

    // MARK: - View controller IBOutlets
    
    @IBOutlet weak private var toggleButton: UIButton!
    @IBOutlet weak private var resetButton: UIButton!
    
    @IBOutlet weak private var timeLabel: UILabel! {
        
        // Prevents time label from "shaking" on change by using monospaced font
        didSet {
            timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: UIFont.Weight.thin)
        }
    }
    
    
    // MARK: -  View controller constants and variables
    
    var stopwatch: Stopwatch!
    
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setForegroundObserver()
        initializeStopwatch()
    }
    
    // MARK: - Private accessory functions
    
    private func setForegroundObserver() {
        
        // A listener observing the scene entring foreground after being dismissed needed for culculating a current stopwatch value
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(foregroundEntered),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc private func foregroundEntered() {
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
        timeLabel.text = stopwatch.formattedTime
    }
    
    private func updateUI() {
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
    
    
    // MARK: - View controller IBActions
    
    @IBAction private func toggleButtonTapped(_ sender: UIButton) {
        stopwatch.toggle()
        updateUI()
    }
    
    @IBAction private func resetButtonTapped(_ sender: UIButton) {
        stopwatch.reset()
    }
    
}

