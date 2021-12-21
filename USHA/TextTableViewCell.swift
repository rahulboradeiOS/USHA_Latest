//
//  TextTableViewCell.swift
 
//
//  Created by Kav Interactive on 29/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var textview:UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textview.clipsToBounds = true
        self.textview.layer.cornerRadius = 5
        self.textview.layer.borderColor = UIColor.black.cgColor
        self.textview.layer.borderWidth = 1
    }
    private func textViewDidEndEditing(_ textView: UITextView) {
    print("we are done editing")
    }
    private func textFieldDidEndEditing(_ textView: UITextView) {
        print("save value")
    }

}

