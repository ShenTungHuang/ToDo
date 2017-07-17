//
//  DisplayNoteViewController.swift
//  ToDo
//
//  Created by STH on 2017/6/23.
//  Copyright © 2017年 STH. All rights reserved.
//

import UIKit

class DisplayNoteViewController: UIViewController
{
    var note: Note?
    var complete: Complete?
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteContentTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier
        {
            if identifier == "cancel"
            {
                print("Cancel button tapped")
            }
            else if identifier == "save"
            {
                // if note exists, update title and content
                if ( note == nil )
                {
                    let note = self.note ?? CoreDataHelper.newNote()
                    note.title = noteTitleTextField.text ?? ""
                    note.content = noteContentTextView.text ?? ""
                    note.modificationTime = Date().convertToString()// as NSDate
                }
                else if ( complete == nil )
                {
                    let note = self.complete ?? CoreDataHelper.newComplete()
                    note.title = noteTitleTextField.text ?? ""
                    note.content = noteContentTextView.text ?? ""
                    note.modificationTime = Date().convertToString()// as NSDate
                }
                CoreDataHelper.saveNote()
                
                print("Save button tapped")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        // 1
        if let note = note
        {
            // 2
            noteTitleTextField.text = note.title
            noteContentTextView.text = note.content
        }
        else if let complete = complete
        {
            noteTitleTextField.text = complete.title
            noteContentTextView.text = complete.content
        }
        else
        {
            // 3
            noteTitleTextField.text = ""
            noteContentTextView.text = ""
        }
    }
}
