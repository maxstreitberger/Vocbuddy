//
//  PlayViewController.swift
//  vocbuddy
//
//  Created by Max Streitberger on 24.11.19.
//  Copyright © 2019 Max Streitberger. All rights reserved.
//

import UIKit
import AVFoundation

protocol ResultDelegate {
    func result(rightWordsInt: Int, learnedWordsList: [Word], rightWords: [Word], wrongWords: [Word], alreadyKnownWords: [Word])
}

class PlayViewController: UIViewController, AVAudioPlayerDelegate {
    
    //MARK: - Objects
    
    //Number of Questions Indicator View
    let questionIndicatorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 114, b: 0)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let questionIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    //Number Of Question
    let numberOfQuestion: UILabel = {
        let label = UILabel()
        label.text = "Abfrage 1 von 10"
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    //SeparationLine
    let separationLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    //Question
    let originalWord: UILabel = {
        let label = UILabel()
        label.text = "perilous"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Montserrat-Bold", size: 29)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let translatedWord: UILabel = {
        let label = UILabel()
        label.text = "gefährlich"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let questionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let helpView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    //Answers
    let answer1Button: UIButton = {
        let button = UIButton()
        button.setTitle("Nächstes Wort", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        button.setTitleColor(UIColor(r: 255, g: 144, b: 0), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(chooseAnswer(_:)), for: .touchUpInside)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let answer2Button: UIButton = {
        let button = UIButton()
        button.setTitle("Abfrage abbrechen", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        button.setTitleColor(UIColor(r: 255, g: 144, b: 0), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(chooseAnswer(_:)), for: .touchUpInside)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let answer3Button: UIButton = {
        let button = UIButton()
        button.setTitle("Nächstes Wort", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        button.setTitleColor(UIColor(r: 255, g: 144, b: 0), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(chooseAnswer(_:)), for: .touchUpInside)
        button.tag = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let answerButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    //Correct & Wrong Answer
    let resultAnswerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    //Already Known
    let alreadyKnownButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ich kenne die Vokabel bereits", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        button.addTarget(self, action: #selector(iKnowItAlready), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    //Already Known Button Background
    let alreadyKnownButtonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 147, b: 61)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //LayoutConstraints
    var questionIndicatorViewWidthAnchor: NSLayoutConstraint?
    
    var answerImageViewRightAnchor: NSLayoutConstraint?
    var answerImageViewCenterYAnchor: NSLayoutConstraint?

    

    var preview = true
    
    var question = 1
    
    var resultDelegate: ResultDelegate?
    
    var audioPlayer: AVAudioPlayer?
    
    var words = [Word]()
    
    var answers = [Word]()
    
    var rightWords = [Word]()
    var wrongWords = [Word]()
    var alreadyKnown = [Word]()
    
    var correctAnswerButton: Int?
    
    var numberOfCorrectAnswers = 0
    
    var highestPhase = 1


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 255, g: 114, b: 0)
        
        //Top Spacing
        view.addSubview(helpView)
        
        //Indicator
        view.addSubview(questionIndicatorBackgroundView)
        
        //Number Of Question
        view.addSubview(numberOfQuestion)
        
        //Separation
        view.addSubview(separationLine)
        
        //Question
        view.addSubview(questionStackView)
        
        //Answers
        view.addSubview(answerButtonStackView)
        
        //ImageViews
        view.addSubview(resultAnswerImageView)
        
        //Already Known
        view.addSubview(alreadyKnownButtonBackgroundView)
        
        
        if preview {
            numberOfQuestion.text = "Vorschau \(question) von 10"
            originalWord.text = words[question-1].original
            translatedWord.text = words[question-1].translated
            answer3Button.alpha = 0
        }
        
        
        setUpIndicator()
        setUpNumberOfQuestion()
        setUpSeparationLine()
        setUpAnswers()
        setUpQuestion()
        setUpAlreadyKnown()
    }
    
    //MARK: - Functions
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.view.isUserInteractionEnabled = true
        question += 1
        updateView(currentQuestion: question, previewState: preview)
    }
    
    @objc func iKnowItAlready() {
        var randomNumber = Int(arc4random_uniform(UInt32(allWords.count)))
        var newWord = allWords[randomNumber]
        
        while words.contains(where: {$0.original == newWord.original}) && newWord.phase != "1" {
            randomNumber = Int(arc4random_uniform(UInt32(allWords.count)))
            newWord = allWords[randomNumber]
        }
        
        let allWordsIndex = allWords.firstIndex(where: {$0.original == words[question-1].original})
        allWords.remove(at: allWordsIndex!)
        allWords.append(newWord)

        
        let currentWordIndex = words.firstIndex(where: {$0.original == words[question-1].original})
        words.remove(at: currentWordIndex!)
        words.insert(newWord, at: currentWordIndex!)

        
        if alreadyKnown.contains(where: {$0.original == words[question-1].original}) == false {
            alreadyKnown.append(words[question-1])
        }
        
        originalWord.text = words[question-1].original
        translatedWord.text = words[question-1].translated
    }
    
    @objc func chooseAnswer(_ sender: UIButton) {
        answers = allWords
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        switch sender.tag {
        case 0:
                    
            if sender.titleLabel?.text == "Nächstes Wort" || sender.titleLabel?.text == "Abfrage Starten" {
                question += 1
                if (question == 11) && (preview == true) {
                    question = 1
                    preview = false
                }
                updateView(currentQuestion: question, previewState: preview)
            } else {

                if (preview == false) && (question >= 1) && (question <= 11) {
                    self.view.isUserInteractionEnabled = false

                    sender.setTitleColor(UIColor.white, for: .normal)
                    
                    words[question-1].lastQuery = dateFormatter.string(from: date)

                    if (sender.titleLabel?.text == words[question-1].original) {
                        
                        sender.backgroundColor = UIColor(r: 106, g: 203, b: 176)
                        
                        
                        //SetUp ImageView Constraints
                        setUpImageViewConstraints(tag: sender.tag, result: true, correctAnswer: nil)
                        
                        //Count Correct Answers up
                        numberOfCorrectAnswers += 1
                        
                        //Check phase
                        if words[question-1].learned == false {
                            //Move word one phase up
                            let newPhase = Int(words[question-1].phase)! + 1
                            words[question-1].phase = "\(newPhase)"
                            words[question-1].lastQuery = updateQueryDate(Int(words[question-1].phase)!)
                            words[question-1].learned = true
                            rightWords.append(words[question-1])
                        }
                        
                        playSound(answer: "correct")
                        
                    } else {
                        sender.backgroundColor = UIColor(r: 225, g: 72, b: 110)
                        
                        //Move word back to first phase
                        words[question-1].phase = "1"
                        words[question-1].lastQuery = updateQueryDate(Int(words[question-1].phase)!)
                        
                        wrongWords.append(words[question-1])

                        //SetUp ImageView Constraints
                        setUpImageViewConstraints(tag: sender.tag, result: false, correctAnswer: correctAnswerButton!)
                        
                        playSound(answer: "wrong")
                    }
                }
            }
            
        case 1:
            
            if sender.titleLabel?.text == "Vorheriges Wort" {
                question -= 1
                updateView(currentQuestion: question, previewState: preview)
            } else if sender.titleLabel?.text == "Abfrage abbrechen" {
                dismiss(animated: true, completion: nil)
            } else {
                self.view.isUserInteractionEnabled = false
                sender.setTitleColor(UIColor.white, for: .normal)
                
                words[question-1].lastQuery = dateFormatter.string(from: date)

                if (sender.titleLabel?.text == words[question-1].original) {
                    sender.backgroundColor = UIColor(r: 106, g: 203, b: 176)
                                        
                    //SetUp ImageView Constraints
                    setUpImageViewConstraints(tag: sender.tag, result: true, correctAnswer: nil)
                    
                    //Count Correct Answers up
                    numberOfCorrectAnswers += 1
                
                    //Check phase
                    if words[question-1].learned == false {
                        //Move word one phase up
                        let newPhase = Int(words[question-1].phase)! + 1
                        words[question-1].phase = "\(newPhase)"
                        words[question-1].lastQuery = updateQueryDate(Int(words[question-1].phase)!)
                        words[question-1].learned = true
                        rightWords.append(words[question-1])
                    }
                    
                    playSound(answer: "correct")
                    
                } else {
                    sender.backgroundColor = UIColor(r: 225, g: 72, b: 110)

                    //Move word back to first phase
                    words[question-1].phase = "1"
                    words[question-1].lastQuery = updateQueryDate(Int(words[question-1].phase)!)
                    
                    wrongWords.append(words[question-1])
                    
                    //SetUp ImageView Constraints
                    setUpImageViewConstraints(tag: sender.tag, result: false, correctAnswer: correctAnswerButton!)
                    
                    playSound(answer: "wrong")
                }
            }
            
        case 2:

            sender.setTitleColor(UIColor.white, for: .normal)
            
            words[question-1].lastQuery = dateFormatter.string(from: date)

            if (sender.titleLabel?.text == words[question-1].original) {
                self.view.isUserInteractionEnabled = false

                sender.backgroundColor = UIColor(r: 106, g: 203, b: 176)
                
                
                //SetUp ImageView Constraints
                setUpImageViewConstraints(tag: sender.tag, result: true, correctAnswer: nil)
                
                //Count Correct Answers up
                numberOfCorrectAnswers += 1
                
                //Check phase
                if words[question-1].learned == false {
                    //Move word one phase up
                    let newPhase = Int(words[question-1].phase)! + 1
                    words[question-1].phase = "\(newPhase)"
                    words[question-1].lastQuery = updateQueryDate(Int(words[question-1].phase)!)
                    words[question-1].learned = true
                    rightWords.append(words[question-1])
                }
                
                playSound(answer: "correct")
                
            } else {
                sender.backgroundColor = UIColor(r: 225, g: 72, b: 110)

                //Move word back to first phase
                words[question-1].phase = "1"
                words[question-1].lastQuery = updateQueryDate(Int(words[question-1].phase)!)
                
                wrongWords.append(words[question-1])
                
                //SetUp ImageView Constraints
                setUpImageViewConstraints(tag: sender.tag, result: false, correctAnswer: correctAnswerButton!)
                
                playSound(answer: "wrong")
            }

        default:
            break
        }
    }
    
    func setUpImageViewConstraints(tag: Int, result: Bool, correctAnswer: Int?) {
        if result {
            resultAnswerImageView.image = UIImage(named: "correct_icon")
        } else {
            resultAnswerImageView.image = UIImage(named: "wrong_icon")
        }
        
        answerImageViewRightAnchor?.isActive = false
        answerImageViewCenterYAnchor?.isActive = false
        
        switch tag {
        case 0:
            answerImageViewCenterYAnchor = resultAnswerImageView.centerYAnchor.constraint(equalTo: answer1Button.centerYAnchor)
            answerImageViewRightAnchor = resultAnswerImageView.rightAnchor.constraint(equalTo: answer1Button.rightAnchor, constant: -24)
        case 1:
            answerImageViewCenterYAnchor = resultAnswerImageView.centerYAnchor.constraint(equalTo: answer2Button.centerYAnchor)
            answerImageViewRightAnchor = resultAnswerImageView.rightAnchor.constraint(equalTo: answer2Button.rightAnchor, constant: -24)
        case 2:
            answerImageViewCenterYAnchor = resultAnswerImageView.centerYAnchor.constraint(equalTo: answer3Button.centerYAnchor)
            answerImageViewRightAnchor = resultAnswerImageView.rightAnchor.constraint(equalTo: answer3Button.rightAnchor, constant: -24)
        default:
            break
        }
        
        answerImageViewRightAnchor?.isActive = true
        answerImageViewCenterYAnchor?.isActive = true
        
        switch correctAnswerButton! {
        case 0:
            answer1Button.backgroundColor = UIColor(r: 106, g: 203, b: 176)
            answer1Button.setTitleColor(UIColor.white, for: .normal)
               
        case 1:
            answer2Button.backgroundColor = UIColor(r: 106, g: 203, b: 176)
            answer2Button.setTitleColor(UIColor.white, for: .normal)
        case 2:
            answer3Button.backgroundColor = UIColor(r: 106, g: 203, b: 176)
            answer3Button.setTitleColor(UIColor.white, for: .normal)
        default:
            break
        }
        
        view.layoutIfNeeded()
    }
    
    func updateQueryDate(_ phase: Int) -> String {
        var newQueryDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        switch phase {
        case 1:
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            newQueryDate = dateFormatter.string(from: newDate)
        case 2:
            let newDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
            newQueryDate = dateFormatter.string(from: newDate)
        case 3:
            let newDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
            newQueryDate = dateFormatter.string(from: newDate)
        case 4:
            let newDate = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
            newQueryDate = dateFormatter.string(from: newDate)
        case 5:
            let newDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
            newQueryDate = dateFormatter.string(from: newDate)
        default:
            break
        }
        
        return newQueryDate
    }
        
    func updateView(currentQuestion: Int, previewState: Bool) {
        //Reset Buttons
        answer1Button.backgroundColor = UIColor.white
        answer1Button.setTitleColor(UIColor(r: 255, g: 114, b: 0), for: .normal)
        
        answer2Button.backgroundColor = UIColor.white
        answer2Button.setTitleColor(UIColor(r: 255, g: 114, b: 0), for: .normal)
        
        answer3Button.backgroundColor = UIColor.white
        answer3Button.setTitleColor(UIColor(r: 255, g: 114, b: 0), for: .normal)
        
        
        
        //End
        if (currentQuestion == 11) && (previewState == false) {
            resultDelegate?.result(rightWordsInt: numberOfCorrectAnswers, learnedWordsList: words, rightWords: rightWords, wrongWords: wrongWords, alreadyKnownWords: alreadyKnown)
            dismiss(animated: true, completion: nil)
        } else {
            //Change View
            if previewState {
                numberOfQuestion.text = "Vorschau \(currentQuestion) von 10"
                originalWord.text = words[question-1].original
                translatedWord.text = words[question-1].translated
                answer3Button.alpha = 0
            } else {
                numberOfQuestion.text = "Abfrage \(currentQuestion) von 10"
                originalWord.text = "Was heißt?"
                translatedWord.text = words[question-1].translated
                answer3Button.alpha = 1
                alreadyKnownButton.alpha = 0
                alreadyKnownButtonBackgroundView.alpha = 0
                
                
                //SetUp answers
                correctAnswerButton = Int(arc4random_uniform(3))
                var wrongAnswers = [String]()
                let original = words[question-1].original
                wrongAnswers.removeAll()
                
                
                //Wrong answers
                for _ in 1...3 {
                    var wrongAnswerIndex = Int(arc4random_uniform(UInt32(answers.count)))
                    var wrongAnswer = answers[wrongAnswerIndex]
                    answers.remove(at: wrongAnswerIndex)

                    if wrongAnswer.original == original {
                        wrongAnswerIndex = Int(arc4random_uniform(UInt32(answers.count)))
                        wrongAnswer = answers[wrongAnswerIndex]
                        answers.remove(at: wrongAnswerIndex)
                    }
                    
                    wrongAnswers.append(wrongAnswer.original)
                }

                
                answer1Button.setTitle(wrongAnswers[0], for: .normal)
                answer2Button.setTitle(wrongAnswers[1], for: .normal)
                answer3Button.setTitle(wrongAnswers[2], for: .normal)

                
                //Correct answer
                switch correctAnswerButton {
                case 0:
                    answer1Button.setTitle(words[question-1].original, for: .normal)
                case 1:
                    answer2Button.setTitle(words[question-1].original, for: .normal)
                case 2:
                    answer3Button.setTitle(words[question-1].original, for: .normal)
                default:
                    break
                }
                        
                originalWord.font = UIFont(name: "Montserrat-Medium", size: 16)
                translatedWord.font = UIFont(name: "Montserrat-Bold", size: 29)
            }
                 
            
            //Check if question == 1
            if (currentQuestion == 1) && (previewState == true) {
                answer2Button.setTitle("Abfrage abbrechen", for: .normal)
            }
                    
                    
            //Check if in beginning or ending state
            if (currentQuestion > 1) && (previewState == true) {
                answer2Button.setTitle("Vorheriges Wort", for: .normal)
            }
            if (currentQuestion == 10) && (previewState == true) {
                answer1Button.setTitle("Abfrage Starten", for: .normal)
            }
                    
                    
            //Change Question Indicator Width
            questionIndicatorViewWidthAnchor?.isActive = false
            
            if currentQuestion == 10 {
                questionIndicatorViewWidthAnchor = questionIndicatorView.widthAnchor.constraint(equalTo: questionIndicatorBackgroundView.widthAnchor, constant: -2)
            } else {
                questionIndicatorViewWidthAnchor = questionIndicatorView.widthAnchor.constraint(equalTo: questionIndicatorBackgroundView.widthAnchor, multiplier: CGFloat(Double(currentQuestion) * 0.1))
            }
             
            questionIndicatorViewWidthAnchor?.isActive = true
             
            
            //Load View
            self.loadViewIfNeeded()
        }
    }
    
    @objc func playSound(answer: String) {
        let url = Bundle.main.url(forResource: answer, withExtension: "mp3")
        
        guard url != nil else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
//            DispatchQueue.global().async {
//                self.audioPlayer?.play()
//            }
            audioPlayer?.delegate = self
            audioPlayer?.play()
                        
        } catch {
            print("error")
        }
    }
    
    
    
    //MARK: - Setup
    
    func setUpAlreadyKnown() {
        alreadyKnownButtonBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        alreadyKnownButtonBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        alreadyKnownButtonBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        alreadyKnownButtonBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -53).isActive = true
        
        alreadyKnownButtonBackgroundView.addSubview(alreadyKnownButton)
        alreadyKnownButton.topAnchor.constraint(equalTo: alreadyKnownButtonBackgroundView.topAnchor).isActive = true
        alreadyKnownButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        alreadyKnownButton.centerXAnchor.constraint(equalTo: alreadyKnownButtonBackgroundView.centerXAnchor).isActive = true
    }
    
    func setUpAnswers() {
        answerButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        answerButtonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -62).isActive = true
        answerButtonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        answerButtonStackView.addArrangedSubview(answer1Button)
        answer1Button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        answerButtonStackView.addArrangedSubview(answer2Button)
        answer2Button.heightAnchor.constraint(equalToConstant: 50).isActive = true

        answerButtonStackView.addArrangedSubview(answer3Button)
        answer3Button.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
    }
    
    func setUpQuestion() {
        helpView.topAnchor.constraint(equalTo: separationLine.bottomAnchor).isActive = true
        helpView.bottomAnchor.constraint(equalTo: answerButtonStackView.topAnchor).isActive = true
        helpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        questionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        questionStackView.topAnchor.constraint(equalTo: separationLine.bottomAnchor, constant: 123).isActive = true
//        questionStackView.topAnchor.constraint(equalTo: separationLine.bottomAnchor, constant: 50).isActive = true
        questionStackView.centerYAnchor.constraint(equalTo: helpView.centerYAnchor).isActive = true
        questionStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        questionStackView.addArrangedSubview(originalWord)
        questionStackView.addArrangedSubview(translatedWord)
    }
    
    func setUpSeparationLine() {
        separationLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separationLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        separationLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separationLine.topAnchor.constraint(equalTo: numberOfQuestion.bottomAnchor, constant: 16).isActive = true
    }
    
    func setUpNumberOfQuestion() {
        numberOfQuestion.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        numberOfQuestion.topAnchor.constraint(equalTo: questionIndicatorBackgroundView.bottomAnchor, constant: 16).isActive = true
    }
    
    func setUpIndicator() {
        //Background
        questionIndicatorBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23).isActive = true
        questionIndicatorBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionIndicatorBackgroundView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        questionIndicatorBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        //Indicator
        questionIndicatorBackgroundView.addSubview(questionIndicatorView)
        questionIndicatorView.leftAnchor.constraint(equalTo: questionIndicatorBackgroundView.leftAnchor, constant: 1).isActive = true
        questionIndicatorView.centerYAnchor.constraint(equalTo: questionIndicatorBackgroundView.centerYAnchor).isActive = true
        questionIndicatorView.heightAnchor.constraint(equalTo: questionIndicatorBackgroundView.heightAnchor, constant: -2).isActive = true
        questionIndicatorViewWidthAnchor = questionIndicatorView.widthAnchor.constraint(equalTo: questionIndicatorBackgroundView.widthAnchor, multiplier: 0.1)
        questionIndicatorViewWidthAnchor?.isActive = true
        

    }
}
