//
//  WebAPIManager.swift
//  OnlineBPI
//
//  Created by Sachin on 30/12/16.
//  Copyright © 2016 Sachin Kadam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebAPIClient: NSObject {
    
    enum Result {
        case Success (JSON, statusCode: Int)
        case Failure (errorMessage: String, httpStatusCode: Int)
    }
    
    typealias completionHandlerType = (Result) -> Void
    
    
    static let shared = WebAPIClient()
    private override init() {}
    
    
    func parsingDataJSON(_ paraInfo:Parameters, completionHandler:@escaping completionHandlerType) {
        
        let requestURL: String = mainUrl + "/api/AdminMaster/GetGalleryDetailList"
        print("WebService URL : \(requestURL)")
        
        Alamofire.request(requestURL, method: .post, parameters: paraInfo,encoding: URLEncoding.default, headers: getParsingRequestHeader()).responseJSON { (response) in
            
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // URL response
            print(response.result)   // result of response serialization
            
            print("Status Code : \(String(describing: response.response?.statusCode))")
            
            if (response.result.isSuccess) {
                
                let httpStatusCode = response.response?.statusCode
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                completionHandler(Result.Success(swiftyJsonVar, statusCode: httpStatusCode!))
            }
            else {
                
                print("Error Description : \(String(describing: response.result.error))")
                
                let currentHttpStatusCode:Int?
                
                print("Status Code : \(String(describing: response.response?.statusCode))")
                currentHttpStatusCode = response.response?.statusCode
                
                let (message, statusCode) = self.getRequestFailureStatus(requestStatusCode: currentHttpStatusCode)
                completionHandler(Result.Failure(errorMessage: message, httpStatusCode: statusCode))
            }
        }
    }
    
    func parsingYoutubeJSON(_ paraInfo:Parameters, completionHandler:@escaping completionHandlerType) {
        
        
        //
        //        Alamofire.request(requestURL, method: .post, parameters: paraInfo,encoding: URLEncoding.default, headers: getParsingRequestHeader()).responseJSON { (response) in
        //
        //            print(response.request ?? "")  // original URL request
        //            print(response.response ?? "") // URL response
        //            print(response.result)   // result of response serialization
        //
        //            print("Status Code : \(String(describing: response.response?.statusCode))")
        //
        //            if (response.result.isSuccess) {
        //
        //                let httpStatusCode = response.response?.statusCode
        //                let swiftyJsonVar = JSON(response.result.value!)
        //                print(swiftyJsonVar)
        //
        //                completionHandler(Result.Success(swiftyJsonVar, statusCode: httpStatusCode!))
        //            }
        //            else {
        //
        //                print("Error Description : \(String(describing: response.result.error))")
        //
        //                let currentHttpStatusCode:Int?
        //
        //                print("Status Code : \(String(describing: response.response?.statusCode))")
        //                currentHttpStatusCode = response.response?.statusCode
        //
        //                let (message, statusCode) = self.getRequestFailureStatus(requestStatusCode: currentHttpStatusCode)
        //                completionHandler(Result.Failure(errorMessage: message, httpStatusCode: statusCode))
        //            }
        //        }
    }
    
    func parsingBannerData(completionHandler:@escaping completionHandlerType) {
                
        let requestURL: String = getBannerLink
        print("WebService URL : \(requestURL)")
        
        Alamofire.request(requestURL, method: .get, parameters: nil,encoding: URLEncoding.default, headers: getParsingRequestHeader()).responseJSON { (response) in
            
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // URL response
            print(response.result)   // result of response serialization
            
            print("Status Code : \(String(describing: response.response?.statusCode))")
            
            if (response.result.isSuccess) {
                
                let httpStatusCode = response.response?.statusCode
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                completionHandler(Result.Success(swiftyJsonVar, statusCode: httpStatusCode!))
            }
            else {
                
                print("Error Description : \(String(describing: response.result.error))")
                
                let currentHttpStatusCode:Int?
                
                print("Status Code : \(String(describing: response.response?.statusCode))")
                currentHttpStatusCode = response.response?.statusCode
                
                let (message, statusCode) = self.getRequestFailureStatus(requestStatusCode: currentHttpStatusCode)
                completionHandler(Result.Failure(errorMessage: message, httpStatusCode: statusCode))
            }
        }
    }
    
    //MARK:- Delete Service User
    
    func DMSBillingScheme(viewcontroller :UIViewController,api :String ,_ paraInfo:Parameters, completionHandler:@escaping completionHandlerType) {
        
        let url = baseUrl + api
        viewcontroller.view.makeToastActivity(message: "Processing...")
        
        
        
        Alamofire.request(url, method: .post, parameters: [:],encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            
            viewcontroller.view.hideToastActivity()
            
            print(response.request ?? "")  // original URL request
            print(response.response ?? "") // URL response
            print(response.result)   // result of response serialization
            
            print("Status Code : \(String(describing: response.response?.statusCode))")
            
            
            if (response.result.isSuccess) {
                
                let httpStatusCode = response.response?.statusCode
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                completionHandler(Result.Success(swiftyJsonVar, statusCode: httpStatusCode!))
            }
            else {
                
                print("Error Description : \(String(describing: response.result.error))")
                
                let currentHttpStatusCode:Int?
                
                print("Status Code : \(String(describing: response.response?.statusCode))")
                currentHttpStatusCode = response.response?.statusCode
                
                let (message, statusCode) = self.getRequestFailureStatus(requestStatusCode: currentHttpStatusCode)
                completionHandler(Result.Failure(errorMessage: message, httpStatusCode: statusCode))
            }
        }
    }
    
    
    
    // MARK: - REQUEST HEADER
    func getRequestHeader() -> [String:String] {
        return ["Content-Type":"application/x-www-form-urlencoded",
                "MobileNo":"8080975252",
                "DeviceID":"11442"]
        
    }
    
    // MARK: - REQUEST HEADER
    func getParsingRequestHeader() -> [String:String] {
        return ["Clientid" : "qBd/jix0ctU=" ,
                "SecretId":"7Whc1QzyT1Pfrtm88ArNaQ=="]
        
    }
    
    func getRequestFailureStatus(requestStatusCode: Int?) -> (errorMessage: String, httpStatusCode: Int) {
        
        var statusCode:Int?
        var message = ""
        
        
        return(message, statusCode!)
    }
}


extension String {
    func toBoolValue() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}


