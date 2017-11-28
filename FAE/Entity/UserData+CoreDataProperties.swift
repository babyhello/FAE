//
//  UserData+CoreDataProperties.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/14.
//  Copyright © 2017年 俞兆. All rights reserved.
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
