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
    override func viewDidLoad() {
        super.viewDidLoad()
        filesCollection.backgroundColor = .clear
        DataOperations.shared.fetchData()
        AddNewButton.layer.masksToBounds = true
        AddNewButton.layer.cornerRadius = AddNewButton.frame.width/2
        if UserDefaults.standard.object(forKey: "Theme") as? String == "Dark" {
            currentTheme = .dark
        }else {
            UserDefaults.standard.set("Light", forKey: "Theme")
            currentTheme = .light
        }
        themeChangeButton.title = UserDefaults.standard.object(forKey: "Theme") as? String
        filesTable.applyTheme()
        view.backgroundColor = currentTheme.superViewColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DataOperations.shared.fetchData()
        filesTable.reloadData()
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
    }
    
    @IBAction func ChangeFilesViewAction(_ sender: UIBarButtonItem) {
        if filesTable.isHidden == false {
            filesTable.isHidden = true
            filesCollection.isHidden = false
            customizeLayout()
        }else {
            filesTable.isHidden = false
            filesCollection.isHidden = true
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
        if indexPath.row == 0 {
            cell.backgroundColor = .red
        }else {
            cell.backgroundColor = .blue
        }
        cell.nameLbl.text = DataModel.shared.name[indexPath.row]
        cell.contentsLbl.text = DataModel.shared.content[indexPath.row]
        cell.contentsLbl.lineBreakMode = .byWordWrapping
        cell.contentsLbl.numberOfLines = 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let AddFileVC : AddNewFileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFileVC") as! AddNewFileViewController
        AddFileVC.indexNo = indexPath.row
        AddFileVC.flagUpdate = 1
        navigationController?.pushViewController(AddFileVC, animated: true)
    }
    
    func customizeLayout() {
        let itemsize = filesCollection.frame.width/2 - 2
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemsize, height: itemsize)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        filesCollection.collectionViewLayout = layout
    }
}
