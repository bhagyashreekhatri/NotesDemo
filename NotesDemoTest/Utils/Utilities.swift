//
//  Utilities.swift
//  NotesDemoTest
//
//  Created by Bhagya on 06/09/2018.
//  Copyright © 2018 Bhagya. All rights reserved.
//

import Foundation
import UIKit

func displayDialogBox(title: String, message: String, vc: UIViewController)
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    let ok = UIAlertAction(title: "OK", style: .default, handler: {
        
        (alert: UIAlertAction!) in
    })
    
    alert.addAction(ok)
    vc.present(alert, animated: true, completion: nil)
}
