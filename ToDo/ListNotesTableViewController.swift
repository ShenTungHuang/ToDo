//
//  ListNotesTableViewController.swift
//  ToDo
//
//  Created by STH on 2017/6/23.
//  Copyright © 2017年 STH. All rights reserved.
//

import UIKit

class ListNotesTableViewController: UITableViewController
{
    var notes = [Note]()
    {
        didSet
        {
            tableView.reloadData()
            notes.reverse()
        }
    }
    
    var complete = [Complete]()
    {
        didSet
        {
            tableView.reloadData()
            complete.reverse()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        notes = CoreDataHelper.retrieveNotes()
        complete = CoreDataHelper.retrieveComplete()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notes.count + complete.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        
        var row = indexPath.row
        if ( row < notes.count )
        {
            let note = notes[row]
            cell.noteTitleLabel.text = note.title
            cell.noteModificationTimeLabel.text = note.modificationTime
            cell.notecontentlabel.text = note.content
            
            cell.completeButton.setTitle("Complete", for: .normal)
            cell.backgroundColor = UIColor.clear
            
            cell.tapAction = { (cell) in
                self.showAlertForRow(selectRor: row, celltitle: note.title, type: 1)
            }
        }
        else if ( row >= notes.count )
        {
            row = row - notes.count
            let note = complete[row]
            cell.noteTitleLabel.text = note.title
            cell.noteModificationTimeLabel.text = note.modificationTime
            cell.notecontentlabel.text = note.content
            
            cell.completeButton.setTitle("Add In", for: .normal)
            cell.backgroundColor = UIColor.lightGray
            
            cell.tapAction = { (cell) in
                self.showAlertForRow(selectRor: row, celltitle: note.title, type: 2)
            }
        }
        
        return cell
    }
    
    // MARK: - Extracted method
    func showAlertForRow(selectRor row: Int, celltitle listName: String?, type: Int)
    {
        if ( type == 1 )
        {
            if let task = listName
            {
                let alertController: UIAlertController
                if task != ""
                {
                    alertController = UIAlertController(title: "Great !", message: "Are you complete \"\(task)\"?", preferredStyle: UIAlertControllerStyle.alert)
                }
                else
                {
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
                    self.notes = CoreDataHelper.retrieveNotes()
                    self.complete = CoreDataHelper.retrieveComplete()
                    print("Yes button tapped")
                })
                alertController.addAction(okAction)
                alertController.addAction(deleteAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
        else if ( type == 2 )
        {
            if let task = listName
            {
                let alertController: UIAlertController
                if task != ""
                {
                    alertController = UIAlertController(title: "Oh !", message: "Add \"\(task)\" in list again?", preferredStyle: UIAlertControllerStyle.alert)
                }
                else
                {
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            var row = indexPath.row
            if ( row < notes.count )
            {
                CoreDataHelper.delete(note: notes[indexPath.row])
            }
            else if ( row >= notes.count )
            {
                row = row - notes.count
                CoreDataHelper.delete(note: complete[row])
            }

            self.notes = CoreDataHelper.retrieveNotes()
            self.complete = CoreDataHelper.retrieveComplete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier
        {
            if identifier == "displayNote"
            {
                let indexPath = tableView.indexPathForSelectedRow!
                var row: Int = indexPath.row
                if ( row < notes.count )
                {
                    let note = notes[row]
                    let displayNoteViewController = segue.destination as! DisplayNoteViewController
                    displayNoteViewController.note = note
                }
                else if ( row >= notes.count )
                {
                    row = row - notes.count
                    
                    let note = complete[row]
                    let displayNoteViewController = segue.destination as! DisplayNoteViewController
                    displayNoteViewController.complete = note
                }
                
                print("Table view cell tapped")
            }
            else if identifier == "addNote"
            {
                print("+ button tapped")
            }
        }
    }
    
    @IBAction func unwindToListNotesViewController(_ segue: UIStoryboardSegue)
    {
        self.notes = CoreDataHelper.retrieveNotes()
        self.complete = CoreDataHelper.retrieveComplete()
    }

}
