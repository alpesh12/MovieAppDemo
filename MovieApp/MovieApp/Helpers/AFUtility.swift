//
//  AFUtility.swift
//  GolfPassport
//
//  Created by Jayesh on 03/09/17.
//  Copyright © 2017 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import UIKit
import Alamofire
import Reachability

let key_Failure_Error = "Something went wrong."

typealias CompletionHandler = (_ response: NSDictionary?, _ statusCode: Int?, _ error: NSError?) -> Void

public struct NetworkReachablity {
    private init(){}
    static func isNetwork() -> Bool {
        let host = Reachability()
        return !(host!.connection == Reachability.Connection.none)
    }
}

@objcMembers class AFUtility: NSObject {
    
    func doRequestFor(_ url : String, method: HTTPMethod, dicsParams : [String: Any]?, dicsHeaders : [String: String]?, completionHandler:@escaping CompletionHandler) {
        
        if !NetworkReachablity.isNetwork() {
            return
        }
        if (dicsParams != nil) {print(">>>>>>>>>>>>>>>\nRequest info url: \(url)\nRequest info Param: \(dicsParams!)\n<<<<<<<<<<<<<<<")}
        else {print(">>>>>>>>>>>>>>>\nRequest info url: \(url)\n<<<<<<<<<<<<<<<")}
        
        Alamofire.request(url, method: method, parameters: dicsParams, encoding:
            URLEncoding.default, headers: dicsHeaders)
            
            .responseJSON { response in
                self.handleResponse(response: response, completionHandler: completionHandler)
        }
    }
    
    func requestMultipartFormDataWithImageAndVideo(_ url : String, dicsParams : [String: Any]?, dicsHeaders : [String: String]?, completionHandler:@escaping CompletionHandler) {
        if !NetworkReachablity.isNetwork() {
            return
        }
        
        if (dicsParams != nil) {print(">>>>>>>>>>>>>>>\nRequest info url: \(url)\nRequest info Param: \(dicsParams!)\n<<<<<<<<<<<<<<<")}
        else {print(">>>>>>>>>>>>>>>\nRequest info url: \(url)\n<<<<<<<<<<<<<<<")}
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in dicsParams! {
                
                if value is UIImage {
                    if let imageData = UIImageJPEGRepresentation(value as! UIImage, 1.0) {
                        multipartFormData.append(imageData, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
                } else if key.contains("audios") {
                    
                    print("path: \(value)")
                    do {
                        let audioData = try Data.init(contentsOf: value as! URL)
                        multipartFormData.append(audioData, withName: key, fileName: "file.m4a", mimeType: "audio/mp4")
                        
                    } catch  {
                        
                    }
                    
                } else {
                    let dt = String(describing: value).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    multipartFormData.append(dt!, withName: key)
                }
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: dicsHeaders) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    self.handleResponse(response: response, completionHandler: completionHandler)
                }
            case .failure(let encodingError):
                debugPrint(encodingError)
                completionHandler(nil, nil, encodingError as NSError?)
            }
            
        }
    }
    
    func handleResponse(response: DataResponse<Any>, completionHandler:@escaping CompletionHandler) {
        
        debugPrint(response)
        if (response.result.isSuccess) {
            
            if response.result.value is NSNull {
                let editedResponse = ["message" : (response.result.error! as NSError).localizedDescription]
                completionHandler(editedResponse as NSDictionary?, response.response?.statusCode, nil)
            } else if response.result.value is NSArray {
                let arrResponse = response.result.value as! NSArray
                let dictResponse:NSDictionary? = NSDictionary.init(dictionary: ["data" as NSCopying : arrResponse])
                completionHandler(dictResponse, response.response?.statusCode, nil)
            } else if response.result.value is NSDictionary {
                let dictResponse:NSDictionary? = response.result.value as! NSDictionary?
                completionHandler(dictResponse,  response.response?.statusCode, nil)
            } else {
                completionHandler(response.result.value as! NSDictionary?, response.response?.statusCode,response
                    .result.error as NSError?)
            }
            
        } else {
            let editedResponse = ["message" : (response.result.error! as NSError).localizedDescription]
            completionHandler(editedResponse as NSDictionary?, (response.result.error! as NSError).code, nil)
        }
    }
}

