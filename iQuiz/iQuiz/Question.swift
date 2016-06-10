//
//  Question.swift
//  iQuiz
//
//  Created by Wei-Jen Chiang on 5/13/16.
//  Copyright © 2016 Wei-Jen Chiang. All rights reserved.
//

import Foundation
import SwiftyJSON

class Question {
    var text: String
    var answerList: [JSON]
    var answer: Int
    
    init(text: String, answerList: [JSON], answer: Int) {
        self.text = text
        self.answerList = answerList
        self.answer = answer
    }
}