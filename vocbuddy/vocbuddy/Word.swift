//
//  Word.swift
//  vocbuddy
//
//  Created by Max Streitberger on 26.11.19.
//  Copyright © 2019 Max Streitberger. All rights reserved.
//

import Foundation


struct Word: Codable {
    var original: String
    var translated: String
    var level: String
    var phase: String
    var lastQuery: String
    var learned: Bool
}


struct FailableDecodable<Base : Decodable> : Decodable {

    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}


//func save(level: String) {
//    for word in allWords {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let  entityName = level
//        
//        guard let newEntity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
//            return
//        }
//        
//        let newWord = NSManagedObject(entity: newEntity, insertInto: context)
//        
//        let original = word.original
//        let translated = word.translated
//        let level = word.level
//
//        newWord.setValue(original, forKey: "original")
//        newWord.setValue(translated, forKey: "translated")
//        newWord.setValue(level, forKey: "level")
//
//        do {
//            try context.save()
//            print("Gespeichtert: \(original)")
//            self.setUpLoading(false)
//            self.spinnerActivity.stopAnimating()
//        } catch {
//            print(error)
//        }
//    }
//}
