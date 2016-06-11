//
//  ViewController.swift
//  iQuiz
//
//  Created by Wei-Jen Chiang on 5/11/16.
//  Copyright © 2016 Wei-Jen Chiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var quizTableView: UITableView!
    
    var images : [UIImage] = [UIImage(named: "mathematics.jpg")!, UIImage(named: "marvel.jpeg")!, UIImage(named: "science.png")!]
    
    var localStorage = NSUserDefaults.standardUserDefaults()
    
    var quizzes: [Quiz] = [Quiz]()
    var json: JSON = ""
    var refreshControl: UIRefreshControl!
    var currentUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.quizTableView.delegate = self
        self.quizTableView.dataSource = self
        self.quizTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "quizCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizzes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = self.quizTableView.dequeueReusableCellWithIdentifier("quizCell")! as UITableViewCell
        
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        if (quizzes.count != 0) {
            let quiz = quizzes[indexPath.row]
            cell!.textLabel!.text = quiz.name
            cell!.detailTextLabel!.text = quiz.shortDescription
            cell!.imageView?.image = quiz.image
        }
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("question", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0;
    }
    
    @IBAction func showSettings(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter URL", message: "Enter the URL to load quiz from", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        /* process the URL */
        alert.addTextFieldWithConfigurationHandler { (url : UITextField!) in
            url.placeholder = "URL"
        }
        
        let urlProcessor : UIAlertAction = UIAlertAction(title: "Check Now", style: .Default, handler: { (action) -> Void in
            self.currentUrl = (alert.textFields?.first?.text!)!
            self.fetchData((alert.textFields?.first?.text)!)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(urlProcessor)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fetchData(urlInput: String) {
        Alamofire.request(.GET, urlInput).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.json = JSON(value)
                    self.localStorage.setValue(self.json.rawString()!, forKey: "quizData")
                    self.parseJson(self.json)
                }
                /* the rest */
            case.Failure:
                let failureAlertController: UIAlertController = UIAlertController(title: "Can't download quiz data", message: "Fetching quiz data from local storage", preferredStyle: .Alert)
                let okAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { (_) in }
                failureAlertController.addAction(okAction)
                self.presentViewController(failureAlertController, animated: true, completion: nil)
                //checking to see if NSDefaults have anything
                print((self.localStorage.valueForKey("quizData") as? String))
                if ((self.localStorage.valueForKey("quizData") as? String) != nil) {
                    self.json = JSON.parse((self.localStorage.valueForKey("quizData") as! String)
                    )
                    self.parseJson(self.json)
                } else {
                    self.presentedViewController!.dismissViewControllerAnimated(true, completion: {
                        let emptyAlertController: UIAlertController = UIAlertController(title: "No quiz data on local storage", message: "Guess no iQuiz for you today :(", preferredStyle: .Alert)
                        emptyAlertController.addAction(okAction)
                        self.presentViewController(emptyAlertController, animated: true, completion: nil)
                    
                    })
                }
            }
        }
    }
    
    /* Using non-optional getter for simplicity.
     If scaled in the futture, use optional getter to prevent toxic data. */
    func parseJson(input: JSON) {
        var quizBuilder = [Quiz]()
        for (_, subJson):(String, JSON) in input {
            let newQuiz: Quiz = Quiz()
            newQuiz.name = subJson["title"].stringValue
            newQuiz.shortDescription = subJson["desc"].stringValue
            for (_, questions):(String, JSON) in subJson {
                for (_, question):(String, JSON) in questions {
                    let newQuestion: Question = Question(text: question["text"].stringValue, answerList: question["answers"].arrayValue, answer: question["answer"].intValue)
                    newQuiz.questionList.append(newQuestion)
                }
            }
            quizBuilder.append(newQuiz)
        }
        self.quizzes = quizBuilder
        generateQuizzes()
        self.quizTableView.reloadData()
    }
    
    func generateQuizzes() {
        if (quizzes.count != 0) {
            quizzes[0].image = images[0]
            quizzes[1].image = images[1]
            quizzes[2].image = images[2]
            self.quizTableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "question") {
            let questionsViewController = segue.destinationViewController as! QuestionViewController
            questionsViewController.quizzes = self.quizzes
            questionsViewController.quiz = quizzes[(quizTableView.indexPathForSelectedRow!.row)]
        }
    }
}

