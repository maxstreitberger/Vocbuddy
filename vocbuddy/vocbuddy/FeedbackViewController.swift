//
//  FeedbackViewController.swift
//  vocbuddy
//
//  Created by Max Streitberger on 25.11.19.
//  Copyright © 2019 Max Streitberger. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Objects
    
    //Feedback
    let feedbackLabel: UILabel = {
        let label = UILabel()
        label.text = "Dein Feedback"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Montserrat-Bold", size: 29)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    //Back
    let backTextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Zurück", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    //Information
    let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Ich freue mich auf dein Feedback und deine Wünsche!"
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    //Feedback Text
    let feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Montserrat-Regular", size: 16)
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor(r: 255, g: 114, b: 0)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 2
        textView.returnKeyType = .send
        textView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let feedbackSymbolsCounterLabel: UILabel = {
        let attributedText = NSMutableAttributedString(string: "Zeichen Anzahl: ", attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15)!])
        
        attributedText.append(NSAttributedString(string: "0", attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 15)!]))
        
        let label = UILabel()
        label.attributedText = attributedText
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //Send Feedback
    let sendFeedbackButton: UIButton = {
        let button = UIButton()
        button.setTitle("Feedback senden", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(r: 0, g: 127, b: 255)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(sendMail), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var feedbackText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 255, g: 114, b: 0)
        
        //Feddback
        view.addSubview(feedbackLabel)
        
        //Back
        view.addSubview(backImageButton)
        view.addSubview(backTextButton)
        
        //Information
        view.addSubview(informationLabel)
        
        //Feedback text
        view.addSubview(feedbackTextView)
        
        //Feedback Symbols Counter Label
        view.addSubview(feedbackSymbolsCounterLabel)
        
        //Send Feedback
        view.addSubview(sendFeedbackButton)
        
        setUpFeedbackLabel()
        setUpBackTextImageButton()
        setUpInformationLabel()
        setUpFeedbackTextView()
        setUpFeedbackSymbolsCounterLabel()
        setUpSendFeedbackButton()
        
        
        //Delegate
        feedbackTextView.delegate = self
    }
    
    //MARK: - Functions
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendMail() {
        if feedbackText.count < 20 || feedbackText.isEmpty {
            let alert = UIAlertController(title: "Fehler", message: "Bitte gebe mindestens 20 Zeichen ein.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            Database.database().reference().child("Feedback").childByAutoId().setValue(feedbackText)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - TextView
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.feedbackText = textView.text
        
        let attributedText = NSMutableAttributedString(string: "Zeichen Anzahl: ", attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 15)!])
        
        attributedText.append(NSAttributedString(string: "\(self.feedbackText.count)", attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 15)!]))
        
        feedbackSymbolsCounterLabel.attributedText = attributedText
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.feedbackText = textView.text
        sendMail()
        return true
    }
    
    //MARK: - SetUps
    
    func setUpSendFeedbackButton() {
        sendFeedbackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendFeedbackButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 100).isActive = true
        sendFeedbackButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        sendFeedbackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setUpFeedbackSymbolsCounterLabel() {
        feedbackSymbolsCounterLabel.rightAnchor.constraint(equalTo: feedbackTextView.rightAnchor).isActive = true
        feedbackSymbolsCounterLabel.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 10).isActive = true
    }
    
    func setUpFeedbackTextView() {
        feedbackTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        feedbackTextView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 33).isActive = true
        feedbackTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        feedbackTextView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
    }
    
    func setUpInformationLabel() {
        informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        informationLabel.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: 16).isActive = true
        informationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
    }
    
    func setUpBackTextImageButton() {
        //Image
        backImageButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        backImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        backImageButton.widthAnchor.constraint(equalToConstant: 9).isActive = true
        backImageButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        //Text
        backTextButton.leftAnchor.constraint(equalTo: backImageButton.rightAnchor, constant: 10).isActive = true
        backTextButton.centerYAnchor.constraint(equalTo: backImageButton.centerYAnchor).isActive = true
        
    }
    
    func setUpFeedbackLabel() {
        feedbackLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        feedbackLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 99).isActive = true
    }
}
