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
    
    var saveButton: UIBarButtonItem!
    var textFieldFlag = 0
    var textViewInteraction = 0
    var flagUpdate = 0
    var indexNo:Int?
    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        nameTextField.delegate = self
       saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonAction(_:)))
        self.navigationItem.rightBarButtonItem  = saveButton
        saveButton.isEnabled = false
        nameTextField.layer.borderWidth = 3
        nameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        contentTextView.layer.borderWidth = 3
        contentTextView.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
//        contentTextViewHeight = contentTextView.frame.height
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let index = indexNo {
            nameTextField.text = DataModel.shared.name[index]
            contentTextView.text = DataModel.shared.content[index]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
        if flag == 0 {
            flag = 1
            contentTextView.frame.size = CGSize(width: contentTextView.frame.width, height: contentTextView.frame.height - view.frame.height/2.58)
        }
//        UIView.animate(withDuration: 0.5, animations: {
//            self.view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - self.keyboardheight)
//        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        textFieldFlag = 1
//        if textViewInteraction == 0 {
//            saveButton.isEnabled = true
//            UIView.animate(withDuration: 0.5, animations: {
//                self.view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - self.keyboardheight)
//            })
//        }
//        textViewInteraction += 1
        if flag == 0 {
            flag = 1
            saveButton.isEnabled = true
            contentTextView.frame.size = CGSize(width: contentTextView.frame.width, height: contentTextView.frame.height - view.frame.height/2.58)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//      view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
        nameTextField.resignFirstResponder()
        return false
    }
    
    @objc func saveButtonAction(_ sender: UIBarButtonItem) {
        textViewInteraction = 0
    if flagUpdate == 0 {
        if (nameTextField.text != "") && (contentTextView.text != "" ) {
            if  DataOperations.shared.saveData(contentData: contentTextView.text!, nameData: nameTextField.text!) {
                alertPopUp(title: "Success", message: "File Saved", isSuccess: true)
//                contentTextView.resignFirstResponder()
//                view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
            }else {
                if textFieldFlag == 1 {
                    alertPopUp(title: "Failed", message: "Failed to save data. Try Again", isSuccess: false)
//                                    view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
//                                    contentTextView.resignFirstResponder()
                }
            }
        }
            else {
//                        view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
//                        contentTextView.resignFirstResponder()
            alertPopUp(title: "Failed", message: "Please Enter Name and Content of the File", isSuccess: false)
            }
        }
    else if (flagUpdate == 1) {
        if (nameTextField.text != "") && (contentTextView.text != "" ) {
            if  DataOperations.shared.updateData(name: nameTextField.text!, content: contentTextView.text!, index: indexNo!) {
                alertPopUp(title: "Success", message: "File Updated", isSuccess: true)
//                contentTextView.resignFirstResponder()
//                view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
            }else {
                alertPopUp(title: "Failed", message: "Failed to update data. Try Again", isSuccess: false)
//                view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
            }
        }
        else {
            if textFieldFlag == 1 {
                alertPopUp(title: "Failed", message: "Please Enter Name and Content of the File", isSuccess: false)
//                contentTextView.resignFirstResponder()
//                view.frame.size = CGSize(width:view.frame.width, height: view.frame.height + self.keyboardheight)
                    }
                }
        }
        saveButton.isEnabled = false
    }

    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            keyboardheight = keyboardSize.height
//        }
//    }
    
//    func setTextcontentTextViewHeight() {
//        contentTextView.frame.size = CGSize(width: contentTextView.frame.width, height: contentTextView.frame.height - keyboardheight)
//    }
    
    func alertPopUp(title: String, message: String, isSuccess: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if isSuccess {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
        }else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            keyboardheight = keyboardSize.height
//            }
//        }
////
    @objc func keyboardWillHide(notification: NSNotification) {
        if flag == 1 {
            contentTextView.frame.size = CGSize(width: contentTextView.frame.width, height: contentTextView.frame.height + view.frame.height/2.58)
        }
        flag = 0
    }
}
