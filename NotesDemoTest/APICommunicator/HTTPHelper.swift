
//
//  Created by Bhagya on 06/09/2018.
//  Copyright © 2018 Bhagya. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class HTTPHelper: NSObject, NSURLConnectionDelegate {
    class func request(_ url: String,
                       method: HTTPMethod!,
                       body: Parameters? = nil,
                       completion:@escaping([String : Any])->Void){
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        
       
        
        Alamofire.request(url, method: method, parameters: body, encoding: URLEncoding.default).responseJSON { (response) in
            if response.response?.statusCode == 500 {
                completion(["status" : "fail"])
            }
            else if response.response?.statusCode != 200 {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate!
                let vc = appDelegate?.window?.rootViewController
                if let msg = response.response?.statusCode.description.localizedCapitalized {
                    displayDialogBox(title: "NotesDemoTest App", message: msg, vc: vc!)
                }
                else {
                    displayDialogBox(title: "NotesDemoTest App", message: "Something went wrong", vc: vc!)
                }
                completion(["status" : "fail"])
                // showWarning(msg: "Problem in header response from API", vc: vc!)
            }
            
            
            if response.result.value is NSDictionary {
                completion(response.result.value as! [String : Any])
            }
            else if response.result.value is NSArray {
                let array = response.result.value as! [[String : Any]]
                let dic = ["responseKey": array ]
                completion(dic)
            }
        }
    }
}
