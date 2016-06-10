//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Wei-Jen Chiang on 5/13/16.
//  Copyright © 2016 Wei-Jen Chiang. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    var quizzes: [Quiz] = [Quiz]()
    var quiz: Quiz = Quiz()
    var userAnswers: [Int] = []
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var correctAnswer: UILabel!
    @IBOutlet weak var indicate: UILabel!
    @IBOutlet weak var next: UIBarButtonItem!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        questionText.lineBreakMode = .ByWordWrapping
        questionText.numberOfLines = 0
        
        correctAnswer.lineBreakMode = .ByWordWrapping
        correctAnswer.numberOfLines = 0
        
        questionText.text = "Question: \(quiz.questionList[userAnswers.count - 1].text)"
        correctAnswer.text = "The correct answer was: \(quiz.questionList[userAnswers.count - 1].answerList[quiz.questionList[userAnswers.count - 1].answer - 1])"
        if userAnswers[userAnswers.count - 1] == quiz.questionList[userAnswers.count - 1].answer {
           indicate.text = "Wow! You are super smart!"
        } else {
            indicate.text = "Ehhh wrong. Go back to school, kid."
        }
    }
    @IBAction func nextView(sender: AnyObject) {
        if (userAnswers.count < quiz.questionList.count) {
            self.performSegueWithIdentifier("question", sender: nil)
        } else {
            self.performSegueWithIdentifier("result", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "question") {
            let questionViewController = segue.destinationViewController as! QuestionViewController
                questionViewController.quizzes = self.quizzes
                questionViewController.quiz = self.quiz
                questionViewController.userAnswers = self.userAnswers
        } else if (segue.identifier == "result") {
            let resultViewController = segue.destinationViewController as! ResultViewController
                resultViewController.quizzes = self.quizzes
                resultViewController.quiz = self.quiz
                resultViewController.userAnswers = self.userAnswers
        }
    }
}
