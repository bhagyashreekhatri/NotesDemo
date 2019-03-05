//
//  GetNotesViewController.swift
//  NotesDemoTest
//
//  Created by Bhagya on 06/09/2018.
//  Copyright © 2018 Bhagya. All rights reserved.
//

import UIKit

class GetNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notesArray = [[String: Any]]()
    
    @IBOutlet weak var notesTableView: UITableView!
   // var notesDesc = [FetchNotesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Custom Functions
    
    func setupLayout(){
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }
    
    @IBAction func backActtion(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : GetNotesTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "GetNotesTableViewCell") as! GetNotesTableViewCell
        
        let note = notesArray[indexPath.row]
        
         let title = note["title"] as? String
        cell.notesDescription.text = title
        
        let id = note["_id"] as? String
        cell.noteId.text = id
        
        return cell
    }

}
