//
//  SaveNoteViewController.swift
//  NotesDemoTest
//
//  Created by Bhagya on 06/09/2018.
//  Copyright © 2018 Bhagya. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire



class SaveNoteViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var noteIdTxtview: UITextView!
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var editTxtView: UITextView!
    
    let hud = JGProgressHUD(style: JGProgressHUDStyle.dark)
    var notesArray : [[String: Any]]? = nil
    var deleteId  : String!
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Custom Functions
    
    func setUpLayout(){
        noteTextView.delegate = self
        noteIdTxtview.delegate = self
        editTxtView.delegate = self
        updateView.isHidden = true
    }
    
    
    //MARK: IBActions
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if noteTextView.text!.isEmpty{
            displayDialogBox(title: "Error!", message: "Enter Some Notes To Save", vc: self)
        }
        else{
            saveNotesAPI()
        }
    }
    
    
    @IBAction func getNotesBtnTapped(_ sender: Any) {
        
            self.getNotesAPI()
        
    }
    
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Delete Action", message: "Enter Id which is to be delete", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.deleteId = textField!.text
            self.deleteNoteAPI()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    

    @IBAction func backBtnTapped(_ sender: Any) {
        self.updateView.isHidden = true
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        updateView.isHidden = false
        
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        if editTxtView.text!.isEmpty || noteIdTxtview.text!.isEmpty{
            displayDialogBox(title: "Error!", message: "Enter Some All Fields", vc: self)
        }
        else{
             editNoteAPI()
        }

    }
    
    //MARK: TextView Delegates
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            
            textView.resignFirstResponder()
        
            return false
        }
        return true
    }
    
    
    //MARK: API CALL
    
    func saveNotesAPI(){
        hud.show(in: self.view, animated: true)
        
        var param: Parameters = [:]
        param["text"] = "\(noteTextView.text)"
        
        let parameters = [
            "title": noteTextView.text as String
        ]
        
        let url: String = "\(Constants.APIURLs.baseURL)\(Constants.APIURLs.apiURL)\(Constants.APIURLs.saveNotesURL)"
        
        HTTPHelper.request(url, method: .post, body: parameters) { response in
            self.hud.dismiss()
            let model = NotesModel(JSON: response)
            if let status = model?.message {
                if status == "Note Saved Successfully" {
                    displayDialogBox(title: "Success!", message: status, vc: self)
                    self.noteTextView.text = ""
                }
                else{
                    displayDialogBox(title: "Failure!", message: status, vc: self)
                }
            }
            else{
                displayDialogBox(title: "Invalid!!", message: "something went wrong", vc: self)
            }
        }
    }
    
    func getNotesAPI(){
        hud.show(in: self.view, animated: true)

        
        guard let url = URL(string: Constants.APIURLs.baseURL + Constants.APIURLs.apiURL + Constants.APIURLs.saveNotesURL) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.hud.dismiss()
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                self.notesArray = jsonArray
                DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let myController = storyBoard.instantiateViewController(withIdentifier: "GetNotesViewController") as! GetNotesViewController
                myController.notesArray = self.notesArray!
                self.present(myController, animated: true, completion: nil)
                }
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
       
    }
    
    func editNoteAPI(){
        hud.show(in: self.view, animated: true)
        let id  = noteIdTxtview.text as String
        
        
        let parameters = [
            "title": editTxtView.text as String
        ]
        
        let url: String = "\(Constants.APIURLs.baseURL)\(Constants.APIURLs.apiURL)\(Constants.APIURLs.saveNotesURL)\(id)"
        
        HTTPHelper.request(url, method: .put, body: parameters) { response in
            self.hud.dismiss()
            let model = NotesModel(JSON: response)
            if let status = model?.message {
                if status == "Note Updated Successfully" {
                    displayDialogBox(title: "Success!", message: status, vc: self)
                    self.noteIdTxtview.text = ""
                    self.editTxtView.text = ""
                    self.updateView.isHidden = true
                }
                else{
                    displayDialogBox(title: "Failure!", message: status, vc: self)
                    self.updateView.isHidden = true
                }
            }
            else{
                displayDialogBox(title: "Invalid!!", message: "something went wrong", vc: self)
                self.updateView.isHidden = true
            }
        }
    }
    
    func deleteNoteAPI(){
        hud.show(in: self.view, animated: true)
        
        if (deleteId != ""){
        
        let id = deleteId as String
        let url: String = "\(Constants.APIURLs.baseURL)\(Constants.APIURLs.apiURL)\(Constants.APIURLs.saveNotesURL)\(id)"
        
        HTTPHelper.request(url, method: .delete, body: nil) { response in
            self.hud.dismiss()
            let model = NotesModel(JSON: response)
            if let status = model?.message {
                if status == "Note Deleted Successfully" {
                    displayDialogBox(title: "Success!", message: status, vc: self)
                    
                }
                else{
                    displayDialogBox(title: "Failure!", message: status, vc: self)
                    
                }
            }
            else{
                displayDialogBox(title: "Invalid!!", message: "something went wrong", vc: self)
                self.updateView.isHidden = true
            }
        }
    }
}
}
