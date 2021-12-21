//
//  SurveyModal.swift
 
//
//  Created by Naveen on 10/04/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Survey{
    var surveyName:String?
    var SurveyCode:String?
    var Question:String?
    var QueCode:String?
    var sequence:Int?
    var IsMandatory:Int?
    var AnswerType:String?
    var AnswerOption:Array<Any>?

    func setValues(json:[String:Any]) {
        self.AnswerType = json["s_AnswerType"] as? String ?? ""
        self.sequence = json["n_sequence"] as? Int
        self.IsMandatory = json["b_IsMandatory"] as? Int
        self.QueCode = json["s_QueCode"]  as? String ?? ""
        self.Question = json["s_Question"] as? String ?? ""
        self.SurveyCode = json["s_SurveyCode"] as? String ?? ""
        self.surveyName = json["s_surveyName"] as? String ?? ""
        self.AnswerOption = json["AnswerOption"] as? Array
        
    }
    class AnswerOption {
        var sequence:Int?
        var AnswerOption:String?
        var Answercode:String?
       
        func setValues(json:[String:Any])  {
            self.sequence = json["n_sequence"]as? Int
            self.AnswerOption = json["s_AnswerOption"] as? String ?? ""
            self.Answercode = json["s_Answercode"] as? String ?? ""
        }
    }
    
    
    
    
}


//["s_surveyName": Contracters question, "s_SurveyCode": SURM0005, "s_Question": What is Your Product Name?, "s_QueCode": QUEM0041, "s_AnswerType": TextBox, "n_sequence": 2, "AnswerOption": <__NSSingleObjectArrayI 0x600002127c30>(
//    {
//    "n_sequence" = 1;
//    "s_AnswerOption" = TextBox;
//    "s_Answercode" = ANOP0170;
//    }
//    )
//    , "b_IsMandatory": 1]
