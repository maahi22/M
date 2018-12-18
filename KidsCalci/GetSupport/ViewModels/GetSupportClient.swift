//
//  GetSupportClient.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 08/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import Alamofire
import Reachability


class GetSupportClient: NSObject {
    // MARK: - Injections
    internal let networkClient = NetworkClient.shared
    
    func sendSupportQuery(_ supportQuery:String, name:String, email:String, completion:@escaping (Bool,String)->())  {
        
        let reachability = Reachability()!
        if !reachability.isReachable {
            completion(true, connectionProb)
        }
        
        let deviceType = KidsCalciUserDefaults.getDeviceType()
        let deviceDetail = KidsCalciUserDefaults.getDeviceDetail()
        let appName = AppName.VoiceCal.rawValue
        
        
        let apiname = BASE_URL + GET_SupportCreate_Url
        let headers = ["clientid": clientId,"clientsecret":clientSecret,"Content-Type":"application/x-www-form-urlencoded"] as [String:String]
        let params = ["device_type": deviceType,
                      "device_details":deviceDetail,
                      "name": name,
                      "email" :email,
                      "app_name" :appName,
                      "issue" :supportQuery] as [String:Any]
        
        Alamofire.request(apiname, method: .post, parameters: params, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case.success(let data):
               // print("success",data)
                
                guard let value = response.result.value else {
                    completion(false, ThereIsSomeproble )
                    return
                }
                
                guard let json = value as? [String: AnyObject] else {
                    completion(false, ThereIsSomeproble )
                    return
                }
                
              //  print("json",json)
                guard let status :Bool = json["status"] as? Bool else{ return }
                
                if !status{
                    guard let errdict = json["error"] else{
                        completion(false, ThereIsSomeproble )
                        return
                    }
                    
                    guard let errorMessage = errdict["error_message"] as? [String: AnyObject] else{
                        completion(false, ThereIsSomeproble )
                        return
                    }
                    
                    guard let messageArr = errorMessage["message"]  as? [String] else {
                        completion(false, ThereIsSomeproble )
                        return
                    }
                    
                    if messageArr.count > 0 {
                        guard let messageString = messageArr[0] as? String else {
                            completion(false, ThereIsSomeproble )
                            return
                        }
                        
                        completion(false, messageString )
                    }else{
                        completion(false, ThereIsSomeproble )
                    }
                }else{
                    guard let dict = json["data"] else{
                        completion(false, ThereIsSomeproble )
                        return
                    }
                    completion(true, dict["message"] as! String )
                }
                
                
                
               
                
            case.failure(let error):
                //if let messageModel = decodeJSON(type: MessModel.self, from: data as! Data) {
                completion(false, ThereIsSomeproble )
                //}
                print("Not Success",error)
                
            }
            
        }
        
      /*  networkClient.callAPIWithAlamofire(apiname: apiname,
                                           requestType: .post,
                                           params: params,
                                           headers: headers,
                                           success: { (data, httpResponse) in
                                            
                                            if httpResponse.statusCode == 201 {
                                                
                                                
                                                if let messageModel = decodeJSON(type: MessageModel.self, from: data) {
                                                    completion(true, messageModel.Message ?? "")
                                                }
                                                
                                            }
                                            else if let messageModel = decodeJSON(type: MessModel.self, from: data) {
                                                
                                                let str = "Try again"
                                                completion(false, str)
                                            }
                                                
                                            else{
                                                completion(false,"failed")
                                            }
                                            
        }) { (error, message) in
            
            completion(false,message)
            
        }
        */
        
        
    }
    
    
    
    
}
