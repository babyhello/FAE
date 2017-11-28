//
//  Setting+CoreDataProperties.swift
//  FAE
//
//  Created by 俞兆 on 2017/11/14.
//  Copyright © 2017年 俞兆. All rights reserved.
//
//

import Foundation
import CoreData


extension Setting {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
//        return NSFetchRequest<Setting>(entityName: "Setting")
//    }
    @NSManaged public var id: Int64
    @NSManaged public var fontsize: Double
    @NSManaged public var notification: Bool

}
