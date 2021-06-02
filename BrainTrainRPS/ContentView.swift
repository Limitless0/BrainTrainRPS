//
//  ContentView.swift
//  BrainTrainRPS
//
//  Created by Abanoub Iskander on 02/06/2021.
//

import SwiftUI

struct RPSButton: View {
    let identifier: String
    let buttonAction: () -> Void
    
    var body: some View {
		Button(action: buttonAction) {
			Text("\(identifier)")
				.font(.headline)
				.foregroundColor(Color.black)
				.frame(width: 100, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
				.padding()
				.background(Color.blue)
				.clipShape(Capsule())
		}
    }
}

struct Game: View {
	
	let option: [String]
	let finishGame: () -> Void
	
	@State private var computerChoice: Int
	@State private var shouldPlayerWin = Bool.random()
	@State private var correctAnswer: Int
	@State private var count = 0
	@State private var playerScore = 0
	
	init(options: [String], finishGameAction: @escaping () -> Void) {
		self.option = options
		self.finishGame = finishGameAction
		self.shouldPlayerWin = Bool.random()
		self.computerChoice = Int.random(in: 0..<options.count)
		self.correctAnswer = 0
	}
	
	var body: some View {
		playingGame()
	}
	
	func initGameQuestion () -> Void {
		computerChoice = generateComputerChoice()
		shouldPlayerWin = Bool.random()
		correctAnswer = generateCorrectAnswer(computerChoice)
	}
	
	func generateCorrectAnswer(_ choice: Int) -> Int {
		switch shouldPlayerWin {
			case true:
				var possibleAns = choice + 1
				// scissors beats paper beats rock
				
				if possibleAns == option.count {
					possibleAns = 0
						//rock beats scissors
				}
				return possibleAns
			case false:
				var possibleAns = choice - 1
				//rock loses to paper loses to scissors
				
				if possibleAns == -1 {
					possibleAns = option.count - 1
						//scissors loses to rock
				}
				return possibleAns
			}
		
	}
	
	func generateComputerChoice () -> Int {
		return Int.random(in: 0..<option.count)
	}
	
	func updateScore (option: Int) {
		correctAnswer = generateCorrectAnswer(computerChoice)
		if correctAnswer == option {
			playerScore += 1
		}
	}
	
	func userInput (input: Int) -> Void {
		updateScore(option: input)
		initGameQuestion()
		count += 1
	}
	
	@ViewBuilder
	func playingGame () -> some View {
		if count < 10 {
			VStack {
				Text("You need to " + (shouldPlayerWin ? "win" : "lose"))
				
				ForEach(0..<option.count) { chosen in
					RPSButton(identifier: option[chosen], buttonAction: { userInput(input: chosen)})
				}
				.padding()
				
				Text("Computer chose: \(option[computerChoice])")
			}
		} else {
			ScoreShow(score: playerScore, buttonAction: finishGame)
		}
	}
}

struct ScoreShow: View {
	
	@State var score: Int
	var buttonAction: () -> Void
	
	
	var body: some View {
		VStack {
			Text("Your score is")
			Text("\(score)")
				.font(.largeTitle)
				.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
				
			Button(action: buttonAction, label: {
				Text("Try Again")
			})
		}
		
		
	}
	
}

struct Initaliser: View {
	
	let buttonAction: () -> Void
	
	var body: some View {
		Button("Ready?", action: buttonAction)
	}
}

struct ContentView: View {
	
	let options = ["Rock", "Paper", "Scissors"]
	
	@State private var playing = false
	
	
	var body: some View {
		
		return playGame()
		
	}
	
	@ViewBuilder
	func playGame() -> some View {
		switch playing {
			case false:
				VStack {
					Initaliser(buttonAction: {playing = true})
				}
			case true:
				VStack {
					Game(options: options, finishGameAction: {playing = false})
				
				}
			}
		}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
