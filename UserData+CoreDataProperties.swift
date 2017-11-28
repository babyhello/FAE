//
//  UserData+CoreDataProperties.swift
//  
//
//  Created by 俞兆 on 2017/11/14.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var fontsize: NSDecimalNumber?
    @NSManaged public var notification: Bool

}
