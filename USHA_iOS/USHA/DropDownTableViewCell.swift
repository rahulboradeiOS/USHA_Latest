//
//  DropDownTableViewCell.swift
 
//
//  Created by Naveen on 04/04/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SQLite

protocol DropDownDataPassing {
    func selectedData(section:Int, index:Int, selectedText:String)
}
var txt_responder:UITextField?

class DropDownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtfield_dropdown: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectDropdown: UIButton!
    var arr_dropdown: [String] = []
    var selectDropDown = DropDown()
    var delegate: DropDownDataPassing?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectDropDown.selectionAction = {(index, item) in
            self.txtfield_dropdown.text = item
            print("Index===\(index) Item===\(item)==TAG===\(self.selectDropDown.tag)")
            if let del = self.delegate {
                del.selectedData(section: self.selectDropDown.tag, index: index, selectedText: item)
            }
        }
        txtfield_dropdown.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btn_select_pressed(_ sender: UIButton){
        _ = txtfield_dropdown.becomeFirstResponder()

    }
}

extension DropDownTableViewCell: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if(textField == txtfield_dropdown)
        {
            txt_responder = txtfield_dropdown
            selectDropDown.dataSource = arr_dropdown
            selectDropDown.anchorView = txtfield_dropdown
            selectDropDown.show()
            return false
        }
        return true
    }
}
