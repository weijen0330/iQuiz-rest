//
//  ResultViewController.swift
//  iQuiz
//
//  Created by Wei-Jen Chiang on 5/13/16.
//  Copyright © 2016 Wei-Jen Chiang. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var score: UILabel!
    
    var quizzes: [Quiz] = [Quiz]()
    var quiz: Quiz = Quiz()
    var userAnswers: [Int] = []
    var numCorrect: Int = 0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        descriptionText.lineBreakMode = .ByWordWrapping
        descriptionText.numberOfLines = 0
        
        score.lineBreakMode = .ByWordWrapping
        score.numberOfLines = 0
        
        descriptionText.text = "Nice! You just completed the \(quiz.name) quiz! Let's see how you did:"
        var result = ""
        for i in 0...(quiz.questionList.count - 1) {
            result += "\(i + 1). \(quiz.questionList[i].text)\n"
            if (userAnswers[i] == quiz.questionList[i].answer) {
                result += "Correct! \n\n"
                numCorrect += 1
            } else {
                result += "Incorrect! \n\n"
            }
        }
        result += "You got \(numCorrect) out of \(quiz.questionList.count) questions right!"
        score.text = result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mainMenu") {
            let viewController = segue.destinationViewController as! ViewController
            viewController.quizzes = self.quizzes
        }
    }

}
