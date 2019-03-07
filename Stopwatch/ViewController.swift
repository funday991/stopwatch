//
//  ViewController.swift
//  Stopwatch
//
//  Created by Yury on 05/03/2019.
//  Copyright © 2019 napoleon. All rights reserved.
//

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
            if self.stopwatch?.state == .running {
                self.stopwatch?.centisecondsCounter += UserDefaults.standard.integer(forKey: "backgroundStopwatchValue")
            }
        }
        
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: UIFont.Weight.thin)
        
        stopwatch = Stopwatch(state: .paused, currentCentiseconds: 0, callbackOnFire: updateTimeLabel)
    }
    
    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        stopwatch?.toggle()
        
        switch stopwatch!.state {
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
        stopwatch?.reset()
    }
    
    
    func updateTimeLabel() {
        timeLabel.text = stopwatch?.formattedTime
    }
    
}

