//
//  ViewFilesVC.swift
//  Notes
//
//  Created by Soumil on 24/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit

class ViewFilesVC: UIViewController {
    @IBOutlet weak var AddNewButton: UIButton!
    @IBOutlet weak var filesTable: UITableView!
    @IBOutlet weak var themeChangeButton: UIBarButtonItem!
    @IBOutlet weak var filesCollection: UICollectionView!
    let addNewFileViewController = AddNewFileViewController()
    var isDeleteButtonVisible = false
    var isshaking = false
    var cancelButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataOperations.shared.fetchData()
        AddNewButton.layer.masksToBounds = true
        AddNewButton.layer.cornerRadius = AddNewButton.frame.width/2
        if UserDefaults.standard.object(forKey: "Theme") as? String == "Dark" {
            currentTheme = .dark
        }else {
            UserDefaults.standard.set("Light", forKey: "Theme")
            currentTheme = .light
        }
        if UserDefaults.standard.object(forKey: "CurrentView") as? String == "CollectionView" {
            filesTable.isHidden = true
            filesCollection.isHidden = false
            customizeCollectionViewLayout()
        }else {
            filesTable.isHidden = false
            filesCollection.isHidden = true
        }
        themeChangeButton.title = UserDefaults.standard.object(forKey: "Theme") as? String
        filesTable.applyTheme()
        filesCollection.applyTheme()
        view.backgroundColor = currentTheme.superViewColor
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DataOperations.shared.fetchData()
        filesTable.reloadData()
        filesCollection.reloadData()
    }
    
    @IBAction func themeChangeButtonAction(_ sender: UIBarButtonItem) {
        if UserDefaults.standard.object(forKey: "Theme") as? String == "Light" {
            UserDefaults.standard.set("Dark", forKey: "Theme")
            sender.title = "Dark"
            currentTheme = .dark
            view.backgroundColor = currentTheme.superViewColor
            filesTable.reloadData()
        }else {
            UserDefaults.standard.set("Light", forKey: "Theme")
            sender.title = "Light"
            currentTheme = .light
            view.backgroundColor = currentTheme.superViewColor
            filesTable.reloadData()
        }
        filesCollection.reloadData()
    }
    
    @IBAction func ChangeFilesViewAction(_ sender: UIBarButtonItem) {
        if filesTable.isHidden == false {
            filesTable.isHidden = true
            filesCollection.isHidden = false
            customizeCollectionViewLayout()
            UserDefaults.standard.set("CollectionView", forKey: "CurrentView")
        }else {
            filesTable.isHidden = false
            filesCollection.isHidden = true
            UserDefaults.standard.set("TableView", forKey: "CurrentView")
        }
    }
}

extension ViewFilesVC: UITableViewDelegate, UITableViewDataSource {
    
    //    MARK:- Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.shared.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.applyTheme()
        cell.textLabel?.text = DataModel.shared.name[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let AddFileVC : AddNewFileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFileVC") as! AddNewFileViewController
        AddFileVC.indexNo = indexPath.row
        AddFileVC.flagUpdate = 1
        navigationController?.pushViewController(AddFileVC, animated: true)
    }
    
    //    MARK:- Delete Table rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DataOperations.shared.deleteData(index: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension ViewFilesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    //    MARK:- Collection View Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataModel.shared.name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! allFilesCollectionViewCell
        cell.nameLbl.text = DataModel.shared.name[indexPath.row]
        cell.contentsLbl.text = DataModel.shared.content[indexPath.row]
        cell.contentsLbl.lineBreakMode = .byWordWrapping
        cell.contentsLbl.numberOfLines = 0
        cell.nameLbl.applyTheme()
        cell.contentsLbl.applyTheme()
        cell.layer.borderWidth = 2
        cell.layer.borderColor = currentTheme.seperatorColor
        deleteButtonCustomization(deleteButton: cell.deleteButton, index: indexPath.row)
        cell.bringSubviewToFront(cell.deleteButton)
        if isshaking == true {
            cell.shake()
        }
        let lpGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell))
        cell.addGestureRecognizer(lpGestureRecognizer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let AddFileVC : AddNewFileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFileVC") as! AddNewFileViewController
        AddFileVC.indexNo = indexPath.row
        AddFileVC.flagUpdate = 1
        navigationController?.pushViewController(AddFileVC, animated: true)
    }
    
//    MARK:- Only two cells in a row
    func customizeCollectionViewLayout() {
        let itemsize = (UIScreen.main.bounds.width - 32)/2 - 2
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemsize, height: itemsize)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        filesCollection.collectionViewLayout = layout
    }
    
    //    MARK:- Reload Layout to adjust device rotation
    @objc func deviceOrientationDidChange(_ notification: Notification) {
               customizeCollectionViewLayout()
    }
    
//    MARK:- LongPress Gesture Action
    @objc func didLongPressCell (recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            isDeleteButtonVisible = true
            isshaking = true
            filesCollection.reloadData()
                cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonAction(_:)))
                self.navigationItem.leftBarButtonItem  = cancelButton
        default:
            print("Any other action?")
        }
    }
    
    //    MARK:- Navigation bar Button Cancel Button Action to stop deletion
     @objc func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItems?.remove(at: 0)
        isDeleteButtonVisible = false
        isshaking = false
        filesCollection.reloadData()
    }
    
    //    MARK:- Delete Button on the cell action to delete the cell
    @objc func deleteButtonAction(_ sender: UIButton) {
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure to delete this file ?", preferredStyle: UIAlertController.Style.alert)
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DataOperations.shared.deleteData(index: sender.tag)
            self.filesCollection.reloadData()
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func deleteButtonCustomization(deleteButton: UIButton, index: Int) {
        let image = UIImage(named: "crossButton.png")
        deleteButton.setImage(image, for: .normal)
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = deleteButton.frame.width/2
        deleteButton.tag = index
        deleteButton.addTarget(self, action: #selector(deleteButtonAction(_:)), for: .touchUpInside)
        if isDeleteButtonVisible == true {
            deleteButton.isHidden = false
        }else {
            deleteButton.isHidden = true
        }
    }
}

extension UIView {
//    MARK:- To shake the Views
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1.2
        animation.values = [-5.0, 5.0, -5.0, 5.0, -3.0, 3.0, -1.5, 1.5, 0.0 ]
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "shake")
    }
}
