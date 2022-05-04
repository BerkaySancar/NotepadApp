//
//  ViewController.swift
//  NotepadApp
//
//  Created by Berkay Sancar on 4.05.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var selectedTitle = ""
    var selectedID = UUID()
    
    var titleArr = [String]()
    var idArr = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(didTappedAddButton))
        
        getData()
        loadLogo()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "dataEntered"), object: nil)
        
    }
    
    func loadLogo() {
        
        let logo = UIImage(named: "notDefterim2")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    @objc func didTappedAddButton() {
        
        selectedTitle = ""
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    @objc func getData() {
        
        titleArr.removeAll(keepingCapacity: false)  //iki kere getirmemesi için
        idArr.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notepad")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let title = result.value(forKey: "title") {
                        titleArr.append(title as! String)
                    }
                    if let id = result.value(forKey: "id") {
                        idArr.append(id as! UUID)
                    }
                }
                tableView.reloadData()
            }
            
        } catch {
            print("getData failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = titleArr[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTitle = titleArr[indexPath.row]
        selectedID = idArr[indexPath.row]
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC" {
            
            let destinationVC = segue.destination as! DetailsViewController
            
            destinationVC.tappedTitle = selectedTitle
            destinationVC.tappedID = selectedID
        }
    }
    


}

