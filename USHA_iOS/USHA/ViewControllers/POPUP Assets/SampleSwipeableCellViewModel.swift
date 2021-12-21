//
//  SampleSwipeableCellViewModel.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

struct SampleSwipeableCellViewModel : Codable{
        
        let bIsActive : Bool?
        let dFromdate : String?
        let dTodate : String?
        let isAutoPopup : Bool?
        let sAttachementPath : String?
        let sAttachmentType : String?
        let sTextMessage : String?
        let sTitile : String?
        
        enum CodingKeys: String, CodingKey {
            case bIsActive = "b_IsActive"
            case dFromdate = "d_Fromdate"
            case dTodate = "d_Todate"
            case isAutoPopup = "IsAutoPopup"
            case sAttachementPath = "s_AttachementPath"
            case sAttachmentType = "s_AttachmentType"
            case sTextMessage = "s_TextMessage"
            case sTitile = "s_Titile"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            bIsActive = try values.decodeIfPresent(Bool.self, forKey: .bIsActive)
            dFromdate = try values.decodeIfPresent(String.self, forKey: .dFromdate)
            dTodate = try values.decodeIfPresent(String.self, forKey: .dTodate)
            isAutoPopup = try values.decodeIfPresent(Bool.self, forKey: .isAutoPopup)
            sAttachementPath = try values.decodeIfPresent(String.self, forKey: .sAttachementPath)
            sAttachmentType = try values.decodeIfPresent(String.self, forKey: .sAttachmentType)
            sTextMessage = try values.decodeIfPresent(String.self, forKey: .sTextMessage)
            sTitile = try values.decodeIfPresent(String.self, forKey: .sTitile)
        }
        
   
}
