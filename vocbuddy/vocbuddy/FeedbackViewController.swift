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
        textView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    
    var feedbackText: String?

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
        
        //Send Feedback
        view.addSubview(sendFeedbackButton)
        
        setUpFeedbackLabel()
        setUpBackTextImageButton()
        setUpInformationLabel()
        setUpFeedbackTextView()
        setUpSendFeedbackButton()
        
        
        //Delegate
        feedbackTextView.delegate = self
    }
    
    //MARK: - Functions
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendMail() {
        guard let text = feedbackText, !text.isEmpty else {
            let alert = UIAlertController(title: "Fehler", message: "Du musst noch dein Feedback eingeben.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        Database.database().reference().child("Feedback").childByAutoId().setValue(text)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - TextView
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.feedbackText = textView.text
    }
    
    //MARK: - SetUps
    
    func setUpSendFeedbackButton() {
        sendFeedbackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendFeedbackButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 33).isActive = true
        sendFeedbackButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        sendFeedbackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
