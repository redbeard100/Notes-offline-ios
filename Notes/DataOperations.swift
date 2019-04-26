//
//  DataOperations.swift
//  Notes
//
//  Created by Soumil on 25/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit
import CoreData
class DataOperations: NSObject {
    static let shared = DataOperations()
    
    /* Description: Saving Data to Core Data
     - Parameter keys: No Parameter
     - Returns: No Parameter
     */
    func saveData(contentData: String, nameData: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)!
        let newfile = NSManagedObject(entity: entity, insertInto: context)
        newfile.setValue(nameData, forKey: "name")
        newfile.setValue(contentData, forKey: "content")
        do {
            try context.save()
            return true
        } catch let error as NSError{
            print(error)
            return false
        }
    }


    /* Description: Fetching Data from Core Data
     - Parameter keys: No Parameter
     - Returns: No Parameter
     */
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DataModel.shared.name.removeAll()
        DataModel.shared.content.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let context = appDelegate.persistentContainer.viewContext
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                DataModel.shared.name.append(data.value(forKey: "name") as! String)
            }
            for data in result as! [NSManagedObject] {
                DataModel.shared.content.append(data.value(forKey: "content") as! String)
            }
        } catch {
            print("Failed fetching Data")
        }
    }
    
    /* Description: Updating Data to Core Data
     - Parameter keys: No Parameter
     - Returns: No Parameter
     */
    func updateData(name: String, content: String, index: Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let context = appDelegate.persistentContainer.viewContext
        do {
            let notes = try context.fetch(request)
            if notes.count > 0 {
                let note = notes[index] as! NSManagedObject
                note.setValue(name, forKey: "name")
                note.setValue(content, forKey: "content")
                try context.save()
                return true
            }
            else {
                print("Note not Found")
                return false
            }
        } catch  {
            print("Failed to Update")
            return false
        }
    }
}
