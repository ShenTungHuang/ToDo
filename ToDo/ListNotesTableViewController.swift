//
//  ListNotesTableViewController.swift
//  ToDo
//
//  Created by STH on 2017/6/23.
//  Copyright © 2017年 STH. All rights reserved.
//

import UIKit

class ListNotesTableViewController: UITableViewController {
    var notes = [Note]() {
        didSet {
//            tableView.reloadData()
            notes.reverse()
            self.feedBack += 1
        }
    }
    
    var complete = [Complete]() {
        didSet {
//            tableView.reloadData()
            complete.reverse()
            self.feedBack += 1
        }
    }
    
    var status: Int = 0
    var listIndex: Int = 0
    
    var feedBack: Int = 0 {
        didSet {
            if ( status == 2 && feedBack == 2 ) {
                listIndex = 0
                self.tableView.reloadData()
                status = 0
                feedBack = 0
            } else if ( status == 0 ) {
                feedBack = 0
            }
        }
    }
    
    var sectionHeaders: [String] = ["ToDo List", "Complete List"]
    var sectionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = 0
        notes = CoreDataHelper.retrieveNotes()
        complete = CoreDataHelper.retrieveComplete()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if ( notes.count > 0 && complete.count > 0 ) {
            return 2
        } else if ( notes.count == 0 && complete.count == 0 ) {
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ( notes.count == 0 && complete.count == 0 ) {
            return nil
        } else if ( section == 0 && notes.count > 0 ) {
            self.sectionIndex = 0
            return self.sectionHeaders[0]
        } else if ( section == 0 && complete.count > 0 ) {
            self.sectionIndex = 1
            return self.sectionHeaders[1]
        } else {
            self.sectionIndex = section
            return self.sectionHeaders[section]
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( self.sectionIndex == 0 ) {
            return notes.count
        } else if ( self.sectionIndex == 1 ) {
            return complete.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        
        let row = indexPath.row
        if ( listIndex < notes.count ) {
            let note = notes[row]
            cell.noteTitleLabel.text = note.title
            cell.noteModificationTimeLabel.text = note.modificationTime
            cell.notecontentlabel.text = note.content
            
            cell.completeButton.setTitle("Complete", for: .normal)
            cell.backgroundColor = UIColor.clear
            
            cell.tapAction = { (cell) in
                self.showAlertForRow(selectRor: row, celltitle: note.title, type: 1)
            }
        } else {
            let note = complete[row]
            cell.noteTitleLabel.text = note.title
            cell.noteModificationTimeLabel.text = note.modificationTime
            cell.notecontentlabel.text = note.content
            
            cell.completeButton.setTitle("Add In", for: .normal)
            cell.backgroundColor = UIColor.clear
            
            cell.tapAction = { (cell) in
                self.showAlertForRow(selectRor: row, celltitle: note.title, type: 2)
            }
        }
        self.listIndex += 1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            if ( indexPath.section == 0 && self.notes.count > 0 ) {
                CoreDataHelper.delete(note: notes[row])
            } else if ( indexPath.section == 0 && self.notes.count == 0 ) {
                CoreDataHelper.delete(note: complete[row])
            } else if ( indexPath.section == 1 ) {
                CoreDataHelper.delete(note: complete[row])
            }
            
            self.status = 2
            self.notes = CoreDataHelper.retrieveNotes()
            self.complete = CoreDataHelper.retrieveComplete()
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label : UILabel = UILabel()
//        label.text = self.sectionHeaders[section]
//        
//        return label
//    }
//    
//    func insertSections(_ sections: NSIndexSet,withRowAnimation animation: UITableViewRowAnimation) {
//    }
//    
//    func deleteSections(_ sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
//    }
    
    // MARK: - Extracted method
    func showAlertForRow(selectRor row: Int, celltitle listName: String?, type: Int) {
        if ( type == 1 ) {
            if let task = listName {
                let alertController: UIAlertController
                if task != "" {
                    alertController = UIAlertController(title: "Great !", message: "Are you complete \"\(task)\"?", preferredStyle: UIAlertControllerStyle.alert)
                } else {
                    alertController = UIAlertController(title: "Great !", message: "Are you complete this no title task?", preferredStyle: UIAlertControllerStyle.alert)
                }
                
                let deleteAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                    print("No button tapped")
                })
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                    let note = CoreDataHelper.newComplete()
                    note.title = self.notes[row].title ?? ""
                    note.content = self.notes[row].content ?? ""
                    note.modificationTime = self.notes[row].modificationTime ?? ""
                    CoreDataHelper.delete(note: self.notes[row])
                    CoreDataHelper.saveNote()
                    self.status = 2
                    self.notes = CoreDataHelper.retrieveNotes()
                    self.complete = CoreDataHelper.retrieveComplete()
                    print("Yes button tapped")
                })
                alertController.addAction(okAction)
                alertController.addAction(deleteAction)
                
                present(alertController, animated: true, completion: nil)
            }
        } else if ( type == 2 ) {
            if let task = listName
            {
                let alertController: UIAlertController
                if task != "" {
                    alertController = UIAlertController(title: "Oh !", message: "Add \"\(task)\" in list again?", preferredStyle: UIAlertControllerStyle.alert)
                } else {
                    alertController = UIAlertController(title: "Oh !", message: "Add this no title task in list again?", preferredStyle: UIAlertControllerStyle.alert)
                }
                
                let deleteAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                    print("No button tapped")
                })
                
                let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                    let note = CoreDataHelper.newNote()
                    note.title = self.complete[row].title ?? ""
                    note.content = self.complete[row].content ?? ""
                    note.modificationTime = self.complete[row].modificationTime ?? ""
                    CoreDataHelper.delete(note: self.complete[row])
                    CoreDataHelper.saveNote()
                    self.status = 2
                    self.notes = CoreDataHelper.retrieveNotes()
                    self.complete = CoreDataHelper.retrieveComplete()
                    print("Yes button tapped")
                })
                alertController.addAction(okAction)
                alertController.addAction(deleteAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayNote" {
                let indexPath = tableView.indexPathForSelectedRow!
                var row: Int = indexPath.row
                if ( row < notes.count ) {
                    let note = notes[row]
                    let displayNoteViewController = segue.destination as! DisplayNoteViewController
                    displayNoteViewController.note = note
                } else if ( row >= notes.count ) {
                    row = row - notes.count
                    
                    let note = complete[row]
                    let displayNoteViewController = segue.destination as! DisplayNoteViewController
                    displayNoteViewController.complete = note
                }
                
                print("Table view cell tapped")
            } else if identifier == "addNote" {
                print("+ button tapped")
            }
        }
    }
    
    @IBAction func unwindToListNotesViewController(_ segue: UIStoryboardSegue) {
        if ( segue.identifier == "save" ) {
            self.status = 2
        }
        self.notes = CoreDataHelper.retrieveNotes()
        self.complete = CoreDataHelper.retrieveComplete()
    }

}
