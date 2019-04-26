//
//  AddNewFileViewController.swift
//  Notes
//
//  Created by Soumil on 25/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit

class AddNewFileViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var textFieldFlag = 0
    var textViewInteraction = 0
    var flagUpdate = 0
    var indexNo:Int?
    var keyboardheight: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        nameTextField.delegate = self
        saveButton.isEnabled = false
        nameTextField.layer.borderWidth = 3
        nameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        contentTextView.layer.borderWidth = 3
        contentTextView.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        if let index = indexNo {
            nameTextField.text = DataModel.shared.name[index]
            contentTextView.text = DataModel.shared.content[index]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
//        UIView.animate(withDuration: 0.5, animations: {
//            self.view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - self.keyboardheight)
//        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textFieldFlag = 1
        if textViewInteraction == 0 {
            saveButton.isEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - self.keyboardheight)
            })
        }
        textViewInteraction += 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//      view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
        nameTextField.resignFirstResponder()
        return false
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        textViewInteraction = 0
    if flagUpdate == 0 {
        if (nameTextField.text != "") && (contentTextView.text != "" ) {
            if  DataOperations.shared.saveData(contentData: contentTextView.text!, nameData: nameTextField.text!) {
                let alert = UIAlertController(title: "Success", message: "File Saved", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    let ShowFilesVC : ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowFilesVC") as! ViewController
                    self.present(ShowFilesVC, animated: true, completion: nil)
                }))
                contentTextView.resignFirstResponder()
                view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
                self.present(alert, animated: true, completion: nil)
            }else {
                if textFieldFlag == 1 {
                    let alert = UIAlertController(title: "Failed", message: "Failed to save data. Try Again", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
                                    contentTextView.resignFirstResponder()
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
            else {
            let alert = UIAlertController(title: "Failed", message: "Please Enter Name and Content of the File", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
                        contentTextView.resignFirstResponder()
            self.present(alert, animated: true, completion: nil)
        }
        }
    else if (flagUpdate == 1) {
        if (nameTextField.text != "") && (contentTextView.text != "" ) {
            if  DataOperations.shared.updateData(name: nameTextField.text!, content: contentTextView.text!, index: indexNo!) {
                let alert = UIAlertController(title: "Success", message: "File Updated", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    let ShowFilesVC : ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowFilesVC") as! ViewController
                    self.present(ShowFilesVC, animated: true, completion: nil)
                }))
                contentTextView.resignFirstResponder()
                view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Failed", message: "Failed to update data. Try Again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                contentTextView.resignFirstResponder()
                view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            if textFieldFlag == 1 {
                let alert = UIAlertController(title: "Failed", message: "Please Enter Name and Content of the File", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                contentTextView.resignFirstResponder()
                view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
                self.present(alert, animated: true, completion: nil)
                    }
                }
        }
        saveButton.isEnabled = false
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardheight = keyboardSize.height
        }
    }
    
    func setTextViewHeight() {
        contentTextView.frame.size = CGSize(width: contentTextView.frame.width, height: contentTextView.frame.height - keyboardheight)
    }
}
