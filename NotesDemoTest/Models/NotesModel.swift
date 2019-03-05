//
//  NotesModel.swift
//  NotesDemoTest
//
//  Created by Bhagya on 06/09/2018.
//  Copyright © 2018 Bhagya. All rights reserved.
//

import Foundation
import ObjectMapper

class NotesModel: Mappable {
    
    var message: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
    }
}
