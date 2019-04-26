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
    var textViewInteraction = 0
    var flagUpdate = 0
    var indexNo:Int?
    var flag = 0
    @IBOutlet weak var contentTextViewBottomConst: NSLayoutConstraint!
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let index = indexNo {
            nameTextField.text = DataModel.shared.name[index]
            contentTextView.text = DataModel.shared.content[index]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
        if flag == 0 {
            flag = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.contentTextViewBottomConst.constant =  self.view.frame.height/2.58 + 20
                self.view.layoutIfNeeded()
        })
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if flag == 0 {
            flag = 1
            saveButton.isEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.contentTextViewBottomConst.constant =  self.view.frame.height/2.58 + 20
                self.view.layoutIfNeeded()
            })
            }
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
    }
    
    @objc func saveButtonAction(_ sender: UIBarButtonItem) {
    if flagUpdate == 0 {
        if (nameTextField.text != "") && (contentTextView.text != "" ) {
            if  DataOperations.shared.saveData(contentData: contentTextView.text!, nameData: nameTextField.text!) {
                alertPopUp(title: "Success", message: "File Saved", isSuccess: true)
            }else {
                    alertPopUp(title: "Failed", message: "Failed to save data. Try Again", isSuccess: false)
            }
        }
            else {
            alertPopUp(title: "Failed", message: "Please Enter Name and Content of the File", isSuccess: false)
            }
        }
    else if (flagUpdate == 1) {
        if (nameTextField.text != "") && (contentTextView.text != "" ) {
            if  DataOperations.shared.updateData(name: nameTextField.text!, content: contentTextView.text!, index: indexNo!) {
                alertPopUp(title: "Success", message: "File Updated", isSuccess: true)
            }else {
                alertPopUp(title: "Failed", message: "Failed to update data. Try Again", isSuccess: false)

            }
        }
        else {
                alertPopUp(title: "Failed", message: "Please Enter Name and Content of the File", isSuccess: false)

                    }
        }
        saveButton.isEnabled = false
    }

    func alertPopUp(title: String, message: String, isSuccess: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if isSuccess {
                contentTextView.resignFirstResponder()
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
        }else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if flag == 1 {
            flag = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.contentTextViewBottomConst.constant = 20
                self.view.layoutIfNeeded()
            })
        }
    }
}
