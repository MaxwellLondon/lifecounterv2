//
//  ViewController.swift
//  lifecounter
//
//  Created by Maxwell London on 4/20/22.
//

import UIKit

class ViewController: UIViewController {
    let currentGame = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addValidPlayer(4)
    }
    
    @IBAction func startGame(_ sender: Any) {
        currentGame.activeGame = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
       self.view.endEditing(true)
    }
   
    @IBOutlet weak var stackedView: UIStackView!
    
    @IBOutlet weak var textBox: UITextField!
    
    @IBAction func updateCustomHealth(_ sender: Any) {
        let input = textBox.text!
        
        do {
            let regex = try NSRegularExpression(pattern: "^-?\\d+$", options: [])
            if regex.firstMatch(in: input, options: [], range: NSMakeRange(0, input.utf16.count)) != nil {
                    print("matched")
                } else {
                    print("not matched")
                    let alert = UIAlertController(title: "Invalid Input", message: "Please enter a positive or negative integer", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
        } catch let error as NSError{
            print(error.localizedDescription)

        }
        
        let operation = Int(input)!
        
        let gameState = currentGame.currentPlayers
        
        for i in gameState{
            if(i.playerView.backgroundColor == .green){
                if(operation < 0){
                    i.subtractLife(amount: operation)
                    currentGame.moveHistory.append("Player \(i.playerID) has lost \(operation) HP")
                } else {
                    currentGame.moveHistory.append("Player \(i.playerID) has gained \(operation) HP")
                    i.addLife(amount: operation)
                }
            }
        }
    }
    
    @IBAction func removePlayer(_ sender: Any) {
        if(currentGame.currentPlayers.count == 2){
            print("You cannot have less than two players")
            let alert = UIAlertController(title: "Invalid Action", message: "You cannot have less than two players", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            let removedPlayer = currentGame.currentPlayers.removeLast()
            print(currentGame.currentPlayers)
            stackedView.removeArrangedSubview(removedPlayer.playerView)
            removedPlayer.playerView.removeFromSuperview()
        }
    }
    
    func addValidPlayer(_ number: Int){
        for _ in 1...number {
            let addedPlayer = Player(currentGame.numberOfPlayers, 20)
            
            addedPlayer.playerView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.selectFunction))
            addedPlayer.playerView.addGestureRecognizer(tap)
            
            
            currentGame.addPlayer(addedPlayer)
            
            stackedView.addArrangedSubview(addedPlayer.playerView)
        }
    }
    
    @IBAction func addPlayer(_ sender: Any) {
        if(currentGame.currentPlayers.count == 8){
            let alert = UIAlertController(title: "Invalid Action", message: "You cannot have more than eight players", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            if(currentGame.activeGame == true){
                let alert = UIAlertController(title: "Invalid Action", message: "You cannot add players during a game", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
               addValidPlayer(1)
            }
        }
    }
    
    @IBAction func updateHealth(_ sender: UIButton) {
        let operation = Int(sender.titleLabel!.text!)!
        
        let gameState = currentGame.currentPlayers
        
        for i in gameState{
            if(i.playerView.backgroundColor == .green){
                if(operation < 0){
                    i.subtractLife(amount: operation)
                    currentGame.moveHistory.append("Player \(i.playerID) has lost 1 HP")
                } else {
                    i.addLife(amount: operation)
                    currentGame.moveHistory.append("Player \(i.playerID) has gained 1 HP")
                }
            }
        }
    }
    
    @IBAction func transitionToHistory(_ sender: Any) {
        let story = storyboard?.instantiateViewController(identifier: "History") as! HistoryViewController
        story.modalPresentationStyle = .fullScreen
        story.gameHistory = currentGame.moveHistory
        present(story, animated: true)
    }
   
    @objc func selectFunction(sender:UITapGestureRecognizer) {
        let button = sender.view as! UILabel
        
        if(button.backgroundColor == .red){
            button.backgroundColor = .green
        } else{
            button.backgroundColor = .red
        }
    }
    
    class Game {
        var currentPlayers: [Player] = []
        var numberOfPlayers: Int {
            get{
                return currentPlayers.count
            }
        }
        var activeGame = false
        var moveHistory: [String] = []
        
        func addPlayer(_ p: Player){
            if(activeGame == true){
                print("cannot add players during active game")
                return
            } else {
                currentPlayers.append(p)
            }
        }
    }
    
    class Player {
        var playerID: Int
        var playerLife: Int
        var playerView: UILabel
        var selected: Bool = false
        
        init(_ id: Int, _ life: Int){
            self.playerID = id
            self.playerLife = life
            
            self.playerView = UILabel()
            self.playerView.backgroundColor = .red
            self.playerView.textAlignment = .center
            self.playerView.text = String(self.playerLife)
        }
        
        func addLife(amount: Int){
            playerLife += amount
            self.playerView.text = String(self.playerLife)
        }
    
        func subtractLife(amount: Int){
            playerLife += amount
            self.playerView.text = String(self.playerLife)
        }
    }
}

