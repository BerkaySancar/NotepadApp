//
//  DetailsViewController.swift
//  NotepadApp
//
//  Created by Berkay Sancar on 4.05.2022.
//

import UIKit
import CoreData


class DetailsViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var tappedTitle : String = ""
    var tappedID : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLogo()

        if tappedTitle != "" {
            
            saveButton.isHidden = true
            titleLabel.isHidden = true
            noteLabel.isHidden = true
            
            
            if let uuidString = tappedID?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notepad")
                
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        
                        for result in results as! [NSManagedObject] {
                            
                            if let title = result.value(forKey: "title"){
                                titleTextView.text = (title as! String)
                            }
                            if let note = result.value(forKey: "note"){
                                noteTextView.text = (note as! String)
                            }
                            
                        }
                        
                    }
                } catch{
                    print("data not came")
                }
            }
        }
        else {
        
            titleLabel.isHidden = false
            noteLabel.isHidden = false
            saveButton.isHidden = false
            titleTextView.text! = ""
            noteTextView.text! = ""
            
        }
            
    }
    func loadLogo() {
        
        let logo = UIImage(named: "notDefterim2")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
   
    
    @IBAction func didTappedSaveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let Notepad = NSEntityDescription.insertNewObject(forEntityName: "Notepad", into: context)
        
        Notepad.setValue(titleTextView.text!, forKey: "title")
        Notepad.setValue(noteTextView.text!, forKey: "note")
        Notepad.setValue(UUID(), forKey: "id")
        
        
        do {
            try context.save()
            print("DataLoaded")
        } catch {
            print("DataNotLoaded")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataEntered"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
}
