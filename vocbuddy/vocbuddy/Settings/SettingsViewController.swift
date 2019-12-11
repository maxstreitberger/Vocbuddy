//
//  FilterViewController.swift
//  vocbuddy
//
//  Created by Max Streitberger on 24.11.19.
//  Copyright © 2019 Max Streitberger. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol SettingsDelegate {
    func selectSettings(level: String)
}

class SettingsViewController: UIViewController {

    //MARK: - Objects
    
    //Level
    let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 29)
        label.text = "Dein Niveau"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //Beginner Level
    let beginnerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.text = "Anfänger"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let beginnerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unselected_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = 0
        button.addTarget(self, action: #selector(selectLevel(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let beginnerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    //Advanced Level
    let advancedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.text = "Fortgeschritten"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let advancedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unselected_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = 1
        button.addTarget(self, action: #selector(selectLevel(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let advancedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    //Profi Level
    let profiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.text = "Profi"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profiButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unselected_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = 2
        button.addTarget(self, action: #selector(selectLevel(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let profiStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    //Level StackView
    let levelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    //Topics
//    let topicsLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Montserrat-Bold", size: 29)
//        label.text = "Deine Themen"
//        label.textColor = UIColor.white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let topicsTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = UIColor(r: 255, g: 114, b: 0)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
    
    
    //Select Filter
    let selectFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filter anwenden", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        button.setTitleColor(UIColor(r: 255, g: 114, b: 0), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(selectFilter), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //Spinner Activity
    let spinnerActivity = UIActivityIndicatorView(style: .large)
    
    
    var settingsDelegate: SettingsDelegate?
    
    var level = ""
//    var topic = ""
//    var allTopics = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 255, g: 114, b: 0)
        
        //Level
        view.addSubview(levelLabel)
        view.addSubview(levelStackView)
        
        //Topics
//        view.addSubview(topicsLabel)
//        view.addSubview(topicsTableView)
        
        //Select Filter
        view.addSubview(selectFilterButton)
        
        //Spinner Activity
        view.addSubview(spinnerActivity)
        
//        topic = currentTopic
        
        setUpLevel()
//        setUpTopics()
        setUpSelectFilterButton()
//        fetchTopics()
        setUpSpinnerActivity()
        
        //Register Cell
//        topicsTableView.register(TopicsTableViewCell.self, forCellReuseIdentifier: "topicsCell")
        
        //Delegate + DataSource
//        topicsTableView.delegate = self
//        topicsTableView.dataSource = self
        
        
        
        //Check current level
        print(currentLevel)
        switch currentLevel {
        case "1":
            beginnerButton.setImage(UIImage(named: "selected_icon"), for: .normal)
            
        case "2":
            advancedButton.setImage(UIImage(named: "selected_icon"), for: .normal)
            
        case "3":
            profiButton.setImage(UIImage(named: "selected_icon"), for: .normal)
            
        default:
            break
        }
    }
    
    //MARK: - Functions
    
    @objc func selectLevel(_ sender: UIButton) {
        beginnerButton.setImage(UIImage(named: "unselected_icon"), for: .normal)
        advancedButton.setImage(UIImage(named: "unselected_icon"), for: .normal)
        profiButton.setImage(UIImage(named: "unselected_icon"), for: .normal)
        
        switch sender.tag {
        case 0:
            beginnerButton.setImage(UIImage(named: "selected_icon"), for: .normal)
            
        case 1:
            advancedButton.setImage(UIImage(named: "selected_icon"), for: .normal)
            
        case 2:
            profiButton.setImage(UIImage(named: "selected_icon"), for: .normal)
            
        default:
            break
        }
    }
    
    @objc func selectFilter() {
        if beginnerButton.imageView?.image == UIImage(named: "selected_icon") {
            level = "1"
        } else if advancedButton.imageView?.image == UIImage(named: "selected_icon") {
            level = "2"
        } else {
            level = "3"
        }
        
        if level == "" {
            let alert = UIAlertController(title: "Fehler", message: "Du musst ein Level auswählen", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            currentLevel = level
            settingsDelegate?.selectSettings(level: level)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
//    func fetchTopics() {
//        view.isUserInteractionEnabled = false
//        spinnerActivity.startAnimating()
//        Database.database().reference().child("Words").observe(.childAdded) { (snapshot) in
//            self.allTopics.append(snapshot.key)
//
//            DispatchQueue.main.async {
//                self.view.isUserInteractionEnabled = true
//                self.spinnerActivity.stopAnimating()
//                self.topicsTableView.reloadData()
//            }
//        }
//    }
    
    
    
    //MARK: - Setup
    
    func setUpSpinnerActivity() {
        spinnerActivity.color = UIColor(r: 255, g: 114, b: 0)
        let x = view.frame.width / 2 - 44
        let y = view.frame.height / 2 - 50.25
        spinnerActivity.frame = CGRect(x: x, y: y, width: 88, height: 105)
        spinnerActivity.backgroundColor = UIColor.white
        spinnerActivity.layer.cornerRadius = 10
    }
    
    func setUpSelectFilterButton() {
        selectFilterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectFilterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        selectFilterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        selectFilterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
//    func setUpTopics() {
//        topicsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
//        topicsLabel.topAnchor.constraint(equalTo: levelStackView.bottomAnchor, constant: 35).isActive = true
//
//        topicsTableView.topAnchor.constraint(equalTo: topicsLabel.bottomAnchor, constant: 20).isActive = true
//        topicsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
//        topicsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        topicsTableView.bottomAnchor.constraint(equalTo: selectFilterButton.topAnchor, constant: -20).isActive = true
//    }
    
    func setUpLevel() {
        levelLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        levelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        levelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        levelStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        levelStackView.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 22).isActive = true
        
        //Beginner
        levelStackView.addArrangedSubview(beginnerStackView)
        beginnerStackView.addArrangedSubview(beginnerLabel)
        beginnerStackView.addArrangedSubview(beginnerButton)
        beginnerButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        beginnerButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        //Advanced
        levelStackView.addArrangedSubview(advancedStackView)
        advancedStackView.addArrangedSubview(advancedLabel)
        advancedStackView.addArrangedSubview(advancedButton)
        advancedButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        advancedButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        //Profi
        levelStackView.addArrangedSubview(profiStackView)
        profiStackView.addArrangedSubview(profiLabel)
        profiStackView.addArrangedSubview(profiButton)
        profiButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        profiButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    
    
    //MARK: - TableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allTopics.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 48
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.reloadData()
//        let cell = tableView.cellForRow(at: indexPath) as! TopicsTableViewCell
//
//        if cell.selectionIndicator.image == UIImage(named: "unselected_icon") {
//            cell.selectionIndicator.image = UIImage(named: "selected_icon")
//            topic = cell.topicNameLabel.text!
//        } else {
//            cell.selectionIndicator.image = UIImage(named: "unselected_icon")
//            topic = ""
//        }
//    }
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        topic = ""
//        tableView.reloadData()
//
//        let cell = tableView.cellForRow(at: indexPath) as! TopicsTableViewCell
//
//        if cell.selectionIndicator.image == UIImage(named: "unselected_icon") {
//            cell.selectionIndicator.image = UIImage(named: "selected_icon")
//            topic = cell.topicNameLabel.text!
//        } else {
//            cell.selectionIndicator.image = UIImage(named: "unselected_icon")
//            topic = ""
//        }
//    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "topicsCell", for: indexPath) as! TopicsTableViewCell
//        cell.topicNameLabel.text = allTopics[indexPath.row]
//        cell.selectionStyle = .none
//
//        if cell.topicNameLabel.text == topic {
//            print("gleich")
//            cell.selectionIndicator.image = UIImage(named: "selected_icon")
//        } else {
//            cell.selectionIndicator.image = UIImage(named: "unselected_icon")
//        }
//
//        return cell
//    }
}
