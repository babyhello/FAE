//
//  Setting+CoreDataClass.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/14.
//  Copyright © 2017年 俞兆. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Setting)
public class Setting: NSManagedObject {
    
    class func addSetting(_ moc:NSManagedObjectContext,id:Int64,fontsize:Double,notification:Bool) {
        
        
        let _Setting = NSEntityDescription.insertNewObject(forEntityName: "Setting", into: moc) as! Setting
        
        _Setting.id = id
        
        _Setting.fontsize = fontsize
        
        _Setting.notification = notification
        
        
        do {
            try moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }
    
    
    class func Get_Setting(_ moc:NSManagedObjectContext)-> [Setting] {
        
        var request: NSFetchRequest<Setting>
        
        if #available(iOS 10.0, *) {
            request = Setting.fetchRequest() as! NSFetchRequest<Setting>
            
            
            
        } else {
            //request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person") as! NSFetchRequest<DB_Member>
            request = NSFetchRequest(entityName: "Setting")
        }
        
        
        do {
            
            return try moc.fetch(request)
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
    }
    
    class func Update_Setting(_ moc:NSManagedObjectContext,id:Int64,fontsize:Double,notification:Bool) {
        
        
        // update
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Setting")
        request.predicate = nil
        
        request.predicate =
            NSPredicate(format: "id = \(id)")
        
        do {
            let results =
                try moc.fetch(request)
                    as! [Setting]
            
            if results.count > 0 {
                results[0].fontsize = fontsize
                results[0].notification = notification
                try moc.save()
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    class func Delete_Setting(_ moc:NSManagedObjectContext) {
        
        
        let request = NSFetchRequest<Setting>()
        do {
            let results = try moc.fetch(request)
            for result in results {
                moc.delete(result)
            }
            do {
                try moc.save()
            }catch{
                fatalError("Failure to save context: \(error)")
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
}
