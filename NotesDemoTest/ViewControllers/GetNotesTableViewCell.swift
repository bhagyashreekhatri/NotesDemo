//
//  GetNotesTableViewCell.swift
//  NotesDemoTest
//
//  Created by Bhagya on 06/09/2018.
//  Copyright © 2018 Bhagya. All rights reserved.
//

import UIKit

class GetNotesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var noteId: UILabel!
    @IBOutlet weak var notesDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
