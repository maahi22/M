//
//  HelperMethods.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 02/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import Foundation
import UIKit


func removeSpecialCharsFromString(_ str: String) -> String {
    struct Constants {
        static let validChars = Set("0123456789+-/*=%.")
    }
    return String(str.filter { Constants.validChars.contains($0) })
}


/*func deleteFileAtPath(_ filepath:String) {
    let fileManager = FileManager.default
    let tempFolderPath = NSTemporaryDirectory()
    
    do {
        let filePath = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
        for filePath in filePaths {
            try fileManager.removeItem(atPath: NSTemporaryDirectory() + filePath)
        }
    } catch let error as NSError {
        print("Could not clear temp folder: \(error.debugDescription)")
    }
}*/


func removeFileIfExist(_ filePath:URL) {
//    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//    if paths.count > 0 {
//        let dirPath = paths[0]
//        let fileName = "filename.jpg"
//        let filePath = NSString(format:"%@/%@", dirPath, fileName) as String
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
                print("User photo has been removed")
            } catch {
                print("an error during a removing")
            }
        }
   // }
}



func clearTempFolder() {
    let fileManager = FileManager.default
    let tempFolderPath = NSTemporaryDirectory()
    do {
        let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
        for filePath in filePaths {
            try fileManager.removeItem(atPath: NSTemporaryDirectory() + filePath)
        }
    } catch let error as NSError {
        print("Could not clear temp folder: \(error.debugDescription)")
    }
}




//List of all folder inside a foldername
func listFilesFromDocumentsFolder() -> [String]?{
    let fileManager = FileManager.default
    let dirs = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    if dirs.count > 0 {
        let dir = dirs[0] as String
        do {
        let fileList = try fileManager.contentsOfDirectory(atPath: dir )
            return fileList as [String]
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
        }
        
    }else{
        return nil
    }
    
    return nil
}

//Check folder exist or not
func checkFolderExist(_ foldername:String) ->Bool{
    var exist = false
    let folderlist = listFilesFromDocumentsFolder()
    if (folderlist?.count)! > 0{
        if (folderlist?.contains(foldername))!{
        exist = true
    }
    }
    return exist
}


//***** Load image from doc dir
func loadImageFromThemeFolder(_ imgName:String , folderPath:String) -> UIImage{
    
    let fileManager = FileManager.default
    let imagePath = NSString(format:"%@/%@.png", folderPath, imgName) as String
    if fileManager.fileExists(atPath: imagePath){
        let image    = UIImage(contentsOfFile: imagePath)
        if let img = image{
           return img
        }else{
          
//            if let img2 = convertPDFPageToImage(filePath: imagePath){
//                return img2
//            }else{
                return UIImage(named: imgName)!
          //  }
            
            
            
        }
        return UIImage(named: imgName)!
    }
    return UIImage(named: imgName)!
}





func convertPDFPageToImage(filePath:String)-> UIImage? {
    
//    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    let filePath = documentsURL.appendingPathComponent("pathLocation").path
    
    do {
        
        let pdfdata = try NSData(contentsOfFile: filePath, options: NSData.ReadingOptions.init(rawValue: 0))
        
        let pdfData = pdfdata as CFData
        let provider:CGDataProvider = CGDataProvider(data: pdfData)!
        let pdfDoc:CGPDFDocument = CGPDFDocument(provider)!
        
        let pdfPage:CGPDFPage = pdfDoc.page(at: 1)!
        var pageRect:CGRect = pdfPage.getBoxRect(.mediaBox)
        pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)
        
//        print("\(pageRect.width) by \(pageRect.height)")
        
        UIGraphicsBeginImageContext(pageRect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
        context.drawPDFPage(pdfPage)
        context.restoreGState()
        let pdfImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return pdfImage
        
    }
    catch {
        
    }
    
    return UIImage()
}


func displayNumber(number: Float) -> String{
  
    /*if number - Float(Int(number)) == 0 {
        return ("\(Int(number))")
    } else {
        return ("\(number)")
    }*/
    
    
    
    return number.cleanValue
}



//Save image in Doc dir
func saveImageInDocDir(_ image:UIImage , fileURL:URL){
    
    if let data = UIImagePNGRepresentation(image),
        !FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            // writes the image data to disk
            try data.write(to: fileURL)
            //print("file saved")
        } catch {
            print("error saving file:", error)
        }
    }
    
    
    
}

//doc path by name
func DocumentDirectoryPath(_ fileName:String)-> String{
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    if paths.count > 0 {
        let dirPath = paths[0]
        let filePath = NSString(format:"%@/%@", dirPath, fileName) as String
        return filePath
    }
    
    return ""
}
//END

//get Image by path
func getImagebyPath(_ imagePath:String) -> UIImage {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: imagePath){
        let image    = UIImage(contentsOfFile: imagePath)
        if let img = image{
            return img
        }else{
            if let img2 = convertPDFPageToImage(filePath: imagePath){
                return img2
            }else{
                return UIImage(named: "background")!
            }
        }
        return UIImage(named: "background")!
    }
    return UIImage(named: "background")!
}
//END


//Directory Operations
//Delete Directory :
func deleteDirectory(_ dirName: String){
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dirName)
    if fileManager.fileExists(atPath: paths){
        try! fileManager.removeItem(atPath: paths)
    }else{
        print("Something wronge.")
    }
}


func checkDirectoryExist(_ dirName: String) -> Bool{
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dirName)
    if fileManager.fileExists(atPath: paths){
        return true
    }else{
        return false
    }
}




// Create Directory :
 func createDirectory(_ dirName: String){
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(dirName)
    if !fileManager.fileExists(atPath: paths){
        try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
    }else{
        print("Already dictionary created.")
    }
}

 func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}


//Image Calculation
func saveImageDocumentDirectory(_ name :String , imageData: NSData){
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
    fileManager.createFile(atPath: paths as String, contents: imageData as Data, attributes: nil)
}


 func deleteImageDocumentDirectory(_ name :String ){
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
    if fileManager.fileExists(atPath: paths){
        try! fileManager.removeItem(atPath: paths)
    }
    
    
}

func SaveImageFromUrlToFileAtPtah(_ filePath :NSURL , urlString : String) -> Bool {
    var success = false
    let url = URL(string:urlString)
    let data = try? Data(contentsOf: url!)
    let image: UIImage = UIImage(data: data!)!
    
    do {
        try UIImagePNGRepresentation(image)!.write(to: filePath as URL)
        //print("Image Added Successfully")
        success = true
    } catch {
        print(error)
        success = false
    }
    return success
}



func getImageFromDocDir(_ fileName: String , completion:@escaping ( _ image :UIImage , _ Status:Bool) -> Void ){
    
    let fileManager = FileManager.default
    let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent(fileName)
    if fileManager.fileExists(atPath: imagePAth){
        let img = UIImage(contentsOfFile: imagePAth)
        completion(img!, true)
    }else{
        //print("No Image")
        completion(UIImage(), false)
    }
}



func CreateDIRWithName(_ folderName:String) -> Bool {
    var success = false
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let dataPath = documentsDirectory.appendingPathComponent(folderName)
    
    if !FileManager.default.fileExists(atPath: dataPath.path) {
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)
            success = true
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
            success = false
            
        }
    }
    
    return success
}


func returnDynamicFont(_ font:CGFloat) -> CGFloat{
   
    let deviceType = UIDevice.DeviceType.self
    var returnRatio = 1.0
    if deviceType.IS_IPHONE_5 {
        returnRatio = 558.0/558
    }else if deviceType.IS_IPHONE_6{
        returnRatio = 667.0/558.0
    }else if deviceType.IS_IPHONE_6P {
        returnRatio = 736.0/558.0
    }else if deviceType.IS_IPHONE_X {
        returnRatio = 812.0/558.0
    }
    
    let myFloat = NSNumber.init(value: returnRatio).floatValue
    let myCGFloat = CGFloat(myFloat)
    
    return (font * myCGFloat)
}



