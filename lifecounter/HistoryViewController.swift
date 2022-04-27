//
//  HistoryViewController.swift
//  lifecounter
//
//  Created by Maxwell London on 4/26/22.
//

import UIKit

class HistoryViewController: UIViewController {

    public var gameHistory: [String] = []
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        populateHistory()
        
        dismissButton.titleLabel?.numberOfLines = 0
        dismissButton.titleLabel?.lineBreakMode = .byWordWrapping
    }

    @IBAction func dismissHistory(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func populateHistory(){
        print(gameHistory)
        for i in gameHistory{
            if(gameHistory.count > 0 ){
               
                let label = UILabel()
                label.text = i
                label.textAlignment = .center
                stackView.addArrangedSubview(label)
            } else {
                print("There is no history to populate")
                return
            }
        }
    }
}
