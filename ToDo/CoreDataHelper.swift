//
//  CoreDataHelper.swift
//  ToDo
//
//  Created by STH on 2017/6/23.
//  Copyright © 2017年 STH. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper
{
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: managedContext) as! Note
        return note
    }
    
    static func newComplete() -> Complete {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Complete", into: managedContext) as! Complete
        return note
    }
    
    static func saveNote() {
        do {
            try managedContext.save()
        }
            
        catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(note: Note) {
        managedContext.delete(note)
        saveNote()
    }
    
    static func delete(note: Complete) {
        managedContext.delete(note)
        saveNote()
    }
    
    static func retrieveNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        }
            
        catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func retrieveComplete() -> [Complete] {
        let fetchRequest = NSFetchRequest<Complete>(entityName: "Complete")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        }
            
        catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
