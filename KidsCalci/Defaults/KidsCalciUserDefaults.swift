//
//  KidsCalciUserDefaults.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 03/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit

class KidsCalciUserDefaults: NSObject {
    
    
    class func setTheme(_ themeName:String){
        UserDefaults.standard.set(themeName, forKey: USER_DEFAULT_THEME_KEY)
        UserDefaults.standard.synchronize()
    }

    class func getTheme() -> String{
        var tempStr = UserDefaults.standard.object(forKey: USER_DEFAULT_THEME_KEY)
        if (tempStr == nil) {
            tempStr = ""
        }
        return tempStr as! String
    }
    
    class func removeCustomeTheme() {
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_THEME_KEY)
        UserDefaults.standard.synchronize()
    }
    
    
    //USER_DEFAULT_DEVICE_TYPE_KEY
    
    class func setDeviceType(){
        UserDefaults.standard.set( "ios" ,forKey: USER_DEFAULT_DEVICE_TYPE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    class func getDeviceType() -> String{
        var tempStr = UserDefaults.standard.object(forKey: USER_DEFAULT_DEVICE_TYPE_KEY)
        if (tempStr == nil) {
            tempStr = "ios"
        }
        return tempStr as! String
    }
    
    //USER_DEFAULT_DEVICE_DETAIL_KEY
    
    class func setDeviceDetail(){
        
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        let modelName = UIDevice.modelName
        jsonObject.setValue(modelName, forKey: "HARDWARE")
        jsonObject.setValue("Apple", forKey: "BRAND")
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
           // let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
           // print("json string = \(jsonString)")
            
            UserDefaults.standard.set( jsonData, forKey: USER_DEFAULT_DEVICE_DETAIL_KEY)
            UserDefaults.standard.synchronize()
            
            
        } catch _ {
            print ("JSON Failure")
        }

    }
    
    class func getDeviceDetail() -> String{
        if let jsonData = UserDefaults.standard.value(forKey: USER_DEFAULT_DEVICE_DETAIL_KEY) as? Data {
            
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
           //  print("json string = \(jsonString)")
            
            return jsonString
        }
        
        return ""
        
}
    
    
    
    
    class func setContinue(){
        UserDefaults.standard.set(true, forKey: USER_DEFAULT_CONTINUE)
        UserDefaults.standard.synchronize()
    }
    
    class func getContinue() -> Bool{
        var tempStr = false
        tempStr = UserDefaults.standard.bool(forKey: USER_DEFAULT_CONTINUE)
        return tempStr
    }
    
    
    class func setTellUsMore(){
        UserDefaults.standard.set(true, forKey: USER_DEFAULT_TellUsMore)
        UserDefaults.standard.synchronize()
    }
    
    class func getTellUsMore() -> Bool{
        var tempStr = false
        tempStr = UserDefaults.standard.bool(forKey: USER_DEFAULT_TellUsMore)
        return tempStr
    }
    
    class func setHowManyTimeOpenApp(){
        var  val  = 0
        val = self.getHowManyTimeOpenApp()
        UserDefaults.standard.set((val + 1), forKey: USER_DEFAULT_IncreaseNo)
        UserDefaults.standard.synchronize()
    }
    
    class func getHowManyTimeOpenApp() -> Int{
        var tempStr = 0
        tempStr = UserDefaults.standard.integer(forKey:  USER_DEFAULT_IncreaseNo)
        return tempStr
    }
    
    
    
    
}
