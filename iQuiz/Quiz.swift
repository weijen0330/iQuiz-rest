//
//  Quiz.swift
//  iQuiz
//
//  Created by Wei-Jen Chiang on 5/13/16.
//  Copyright © 2016 Wei-Jen Chiang. All rights reserved.
//

import Foundation
import UIKit // for UIImage

class Quiz {
    var name: String
    var shortDescription: String
    var image: UIImage?
    var questionList: [Question]
    
    convenience init() {
        self.init(name: "", shortDescription: "", questionList: [])
    }
    
    init(name: String, shortDescription: String, questionList: [Question]) {
        self.name = name
        self.shortDescription = shortDescription
        self.questionList = questionList
    }
}