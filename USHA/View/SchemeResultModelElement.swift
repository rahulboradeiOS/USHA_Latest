//
//  any.swift
 
//
//  Created by Apple on 11/02/20.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import Foundation


// MARK: - SchemeResultModelElement
class SchemeResultModelElement: Codable {
    var head, mobileno: String
    var accumulation: Int
    var toDate, stateName, businessName, closingMonth: String
    var branchName: String
    var netSamparkPointUnderSTBScheme: Double
    var ruleCode: String
    var closingBAL, redemption, netPointUnderScheme, redfromSchemePeriod: Int
    var ruleName, fromDate: String
    var totalSamparkAccumulationDuringSTBPeriod: Int
    var fullName: String
    var slabStatus: String
    var attachmentPath: String
    var notification : String?
    var samparkACPointBalance: Int
    
    enum CodingKeys: String, CodingKey {
        case head = "Head"
        case mobileno = "Mobileno"
        case accumulation = "Accumulation"
        case toDate = "ToDate"
        case stateName = "StateName"
        case businessName = "BusinessName"
        case closingMonth = "ClosingMonth"
        case branchName = "BranchName"
        case netSamparkPointUnderSTBScheme = "Net_Sampark_Point_Under_STB_Scheme"
        case ruleCode = "RuleCode"
        case closingBAL = "closingBal"
        case redemption = "Redemption"
        case netPointUnderScheme = "NetPointUnderScheme"
        case redfromSchemePeriod = "RedfromSchemePeriod"
        case ruleName = "RuleName"
        case slabStatus = "SlabStatus"
        case fromDate = "FromDate"
        case totalSamparkAccumulationDuringSTBPeriod = "Total_Sampark_Accumulation_During_STB_Period"
        case fullName = "FullName"
        case notification = "Notification"
        case attachmentPath = "AttachmentPath"
        case samparkACPointBalance = "Sampark_A_C_Point_Balance"
    }
    
    init(head: String, mobileno: String, accumulation: Int, toDate: String, stateName: String, businessName: String, closingMonth: String, branchName: String, netSamparkPointUnderSTBScheme: Double, ruleCode: String, closingBAL: Int, redemption: Int, netPointUnderScheme: Int, redfromSchemePeriod: Int, ruleName: String, fromDate: String, totalSamparkAccumulationDuringSTBPeriod: Int, fullName: String, samparkACPointBalance: Int,slabStatus:String,notification:String,attachmentPath: String) {
        self.head = head
        self.mobileno = mobileno
        self.accumulation = accumulation
        self.toDate = toDate
        self.stateName = stateName
        self.businessName = businessName
        self.closingMonth = closingMonth
        self.branchName = branchName
        self.netSamparkPointUnderSTBScheme = netSamparkPointUnderSTBScheme
        self.ruleCode = ruleCode
        self.closingBAL = closingBAL
        self.slabStatus = slabStatus
        self.redemption = redemption
        self.netPointUnderScheme = netPointUnderScheme
        self.redfromSchemePeriod = redfromSchemePeriod
        self.ruleName = ruleName
        self.fromDate = fromDate
        self.totalSamparkAccumulationDuringSTBPeriod = totalSamparkAccumulationDuringSTBPeriod
        self.fullName = fullName
        self.samparkACPointBalance = samparkACPointBalance
        self.notification = notification
        self.attachmentPath = attachmentPath
    }
}

typealias SchemeResultModel = [SchemeResultModelElement]


// MARK: - GiftSlabModelElement
class GiftSlabModelElement: Codable {
    var slabID: Int?
    var sGift: String?
    var sGiftSlabPoints: Int?
    var sFile: String?
    var fromDate: String?
    var toDate: String?
    var isActive: Bool?
    var eligibleGift: Bool?
    var isSelected : Bool?
    var filePath : String?
  
    enum CodingKeys: String, CodingKey {
        case slabID = "SlabId"
        case sGift = "s_Gift"
        case sGiftSlabPoints = "s_GiftSlabPoints"
        case sFile = "s_File"
        case isActive = "IsActive"
        case isSelected = "isSelected"
        case eligibleGift = "EligibleGift"
        case fromDate = "FromDate"
        case toDate = "ToDate"
        case filePath = "s_FilePath"
    }
    
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slabID = try values.decodeIfPresent(Int.self, forKey: .slabID)
        sGift = try values.decodeIfPresent(String.self, forKey: .sGift)
        sGiftSlabPoints = try values.decodeIfPresent(Int.self, forKey: .sGiftSlabPoints)
        sFile = try values.decodeIfPresent(String.self, forKey: .sFile)
        isActive =  try values.decodeIfPresent(Bool.self, forKey: .isActive)
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected)
        eligibleGift = try values.decodeIfPresent(Bool.self, forKey: .eligibleGift)
        fromDate = try values.decodeIfPresent(String.self, forKey: .fromDate)
        toDate = try values.decodeIfPresent(String.self, forKey: .toDate)
        filePath = try values.decodeIfPresent(String.self, forKey: .filePath)
    }
}

typealias GiftSlabModel = [GiftSlabModelElement]
