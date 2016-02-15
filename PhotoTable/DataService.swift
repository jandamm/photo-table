//
//  DataService.swift
//  PhotoTable
//
//  Created by Jan Dammshäuser on 14.02.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import UIKit

class DataService {
    static let inst = DataService()
    
    private var _dataList = [Pics]()
    
    var dataList: [Pics] {
        return _dataList
    }
    
    func addPic(img: UIImage, title: String, description: String) {
        
        let imgName = getImageAndSave(img)
        let entry = Pics(img: imgName, title: title, description: description)
        _dataList.append(entry)
        
        saveData()
        loadData()
    }
    
    private func saveData() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(_dataList)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "data")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadData() {
        guard let data = NSUserDefaults.standardUserDefaults().objectForKey("data") as? NSData else {
            return
        }
        guard let array = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Pics] else {
            return
        }
        
        _dataList = array
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: nil)
    }
    
    private func getImageAndSave(img: UIImage) -> String {
        let imgData = UIImagePNGRepresentation(img)
        let imgPath = "img\(NSDate.timeIntervalSinceReferenceDate()).png"
        let fullPath = getPathForImage(imgPath)
        
        imgData?.writeToFile(fullPath, atomically: true)
        return imgPath
    }
    
    func getPathForImage(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)
        let fullPath = paths[0] as NSString
        return fullPath.stringByAppendingPathComponent(name)
    }
    
}
