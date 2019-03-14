import UIKit


class ViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak private var toggleButton: UIButton!
    @IBOutlet weak private var resetButton: UIButton!
    
    @IBOutlet weak private var timeLabel: UILabel! {
        
        // Prevents time label from "shaking" on change by using monospaced font
        didSet {
            timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: UIFont.Weight.thin)
        }
    }
    
    
    // MARK: -  Internal readonly properties
    
    private(set) var stopwatch: Stopwatch! {
        didSet {
            updateTimeLabel()
        }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setForegroundObserver()
        initializeStopwatch()
    }
    
    // MARK: - Private accessory methods
    
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
        stopwatch.restore(backgoundTime: UserDefaults.standard.integer(forKey: "backgroundStopwatchValue"))
    }
    
    
    private func initializeStopwatch() {
        stopwatch = Stopwatch(state: .paused, currentCentiseconds: calculateBackgroundTime(), callbackOnFire: updateTimeLabel)
        
        checkStopwatchBackgoundState()
    }
    
    private func calculateBackgroundTime() -> Int {
        let backgroundStopwatchValue = UserDefaults.standard.integer(forKey: "backgroundStopwatchValue")
        let suspendedStopwatchValue = UserDefaults.standard.integer(forKey: "suspendedStopwatchValue")
        
        return suspendedStopwatchValue + backgroundStopwatchValue
    }
    
    private func checkStopwatchBackgoundState() {
        let stopwatchIsRunning = UserDefaults.standard.bool(forKey: "stopwatchIsRunning")
        
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
    
    
    // MARK: - IBActions
    
    @IBAction private func toggleButtonTapped(_ sender: UIButton) {
        stopwatch.toggle()
        updateUI()
    }
    
    @IBAction private func resetButtonTapped(_ sender: UIButton) {
        stopwatch.reset()
    }
    
}

