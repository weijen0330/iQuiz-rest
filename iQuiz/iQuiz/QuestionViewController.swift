//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Wei-Jen Chiang on 5/13/16.
//  Copyright © 2016 Wei-Jen Chiang. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    var quizzes: [Quiz] = [Quiz]()
    var quiz: Quiz = Quiz()
    var currentAnswer : Int = 0
    var userAnswers: [Int] = []
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var questionText: UILabel!
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    @IBOutlet weak var next: UIBarButtonItem!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        next.enabled = false
        let currentQuestion = quiz.questionList[userAnswers.count]
        self.questionText.text = currentQuestion.text
        
        questionText.lineBreakMode = .ByWordWrapping
        questionText.numberOfLines = 0
        
        answer1.setTitle(currentQuestion.answerList[0].stringValue, forState: .Normal)
        answer2.setTitle(currentQuestion.answerList[1].stringValue, forState: .Normal)
        answer3.setTitle(currentQuestion.answerList[2].stringValue, forState: .Normal)
        answer4.setTitle(currentQuestion.answerList[3].stringValue, forState: .Normal)
    }
    
    @IBAction func answerSelected(sender: UIButton) {
        switch sender {
        case answer1:
            paintButton(1)
            currentAnswer = 1
        case answer2:
            paintButton(2)
            currentAnswer = 2
        case answer3:
            paintButton(3)
            currentAnswer = 3
        case answer4:
            paintButton(4)
            currentAnswer = 4
        default:
            currentAnswer = -1
        }
        next.enabled = true
    }
    
    func paintButton(selectedAnswer: Int) {
        let buttons = [answer1, answer2, answer3, answer4]
        for i in 0...(buttons.count - 1) {
            buttons[i].titleLabel!.lineBreakMode = .ByWordWrapping
            buttons[i].titleLabel!.numberOfLines = 0
            if (i + 1 == selectedAnswer) {
                buttons[i].backgroundColor = UIColor.yellowColor()
            } else {
                buttons[i].backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        userAnswers.append(currentAnswer)
        if (segue.identifier == "answer") {
            let answerViewController = segue.destinationViewController as! AnswerViewController
            answerViewController.quizzes = self.quizzes;
            answerViewController.quiz = self.quiz;
            answerViewController.userAnswers = self.userAnswers;
        } else if (segue.identifier == "mainMenu") {
            let viewController = segue.destinationViewController as! ViewController
            viewController.quizzes = self.quizzes
        }
    }
}
