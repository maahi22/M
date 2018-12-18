//
//  DbHelper.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 08/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation


func savePlistdata( _ themeArray:[ThemeModel]){
    
    
    let fileNameToDelete = "myThemes.plist"
    var filePath = ""
    
    // Fine documents directory on device
    let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    
    if dirs.count > 0 {
        let dir = dirs[0] //documents directory
        filePath = dir.appendingFormat("/" + fileNameToDelete)
        print("Local path = \(filePath)")
    } else {
        print("Could not find local directory to store file")
        return
    }
    
    
    let fileManager = FileManager.default
    
    // Check if file exists
    if fileManager.fileExists(atPath: filePath) {
        print("File exists")
    
    
        let dict : NSMutableDictionary = ["themeDic": themeArray]
        dict.write(toFile: filePath, atomically: false)
    
    } else {
        print("File does not exist")
   
        let dict : NSMutableDictionary = ["themeDic": themeArray]
        dict.write(toFile: filePath, atomically: false)
        
    
    }
    
}


func writePlist(namePlist: String, key: String, data: AnyObject , path:String){
    
    
    if let dict = NSMutableDictionary(contentsOfFile: path){
        dict.setObject(data, forKey: key as NSCopying)
        if dict.write(toFile: path, atomically: true){
            print("plist_write")
        }else{
            print("plist_write_error")
        }
    }else{
        /*if let privPath = NSBundle.mainBundle().pathForResource(namePlist, ofType: "plist"){
            if let dict = NSMutableDictionary(contentsOfFile: privPath){
                dict.setObject(data, forKey: key)
                if dict.writeToFile(path, atomically: true){
                    print("plist_write")
                }else{
                    print("plist_write_error")
                }
            }else{
                print("plist_write")
            }
        }else{*/
            print("error_find_plist")
        //}
    }
}




/*
func fetchPlistData() -> [ThemeModel] {
    
    
    let fileNameToDelete = "myThemes.plist"
    var filePath = ""
    
    // Fine documents directory on device
    let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    
    if dirs.count > 0 {
        let dir = dirs[0] //documents directory
        filePath = dir.appendingFormat("/" + fileNameToDelete)
        print("Local path = \(filePath)")
    } else {
        print("Could not find local directory to store file")
        return [ThemeModel]
    }
    
    
    let fileManager = FileManager.default
    
    // Check if file exists
    if fileManager.fileExists(atPath: filePath) {
        print("File exists")
        
        if let tempArr: [ThemeModel] = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [ThemeModel] {
            themeArray = tempArr
            return themeArray
        }
            
    } else {
    
        return [ThemeModel]
    }
    
   
    return [ThemeModel]
}
*/











