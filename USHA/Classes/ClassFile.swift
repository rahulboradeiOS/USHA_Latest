//
//  OrderDivision.swift
 
//
//  Created by Apple.Inc on 18/12/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation
import UIKit
class Division:NSObject, Codable
{
    var code:String?
    var name:String?
    private enum CodingKeys: String, CodingKey
    {
        case code = "codes"
        case name = "Names"
    }
}

class ProductProfile:NSObject, Codable
{
    var DivCode:String?
    var Category:String?
    var S_Usercode:String?
    var companyAssociate:String?
    var s_SKUCategoryCode:String?
    var s_DealerCode:String?
    var s_SalesOfficeCode:String?
    var s_class:String?
    var dealerName:String?
    
    private enum CodingKeys: String, CodingKey
    {
        case DivCode = "DivCode"
        case Category = "Category"
        case S_Usercode = "S_Usercode"
        case companyAssociate = "companyAssociate"
        case s_SKUCategoryCode = "s_SKUCategoryCode"
        case s_DealerCode = "s_DealerCode"
        case s_SalesOfficeCode = "s_SalesOfficeCode"
        case s_class = "s_class"
        case dealerName = "dealerName"
    }
}

class ServerProductProfile:NSObject, Codable
{
    var Divcode:String?
    var Category:String?
    var S_Usercode:String?
    var companyAssociate:String?
    var s_SKUCategoryCode:String?
    var s_DealerCode:String?
    var s_SalesOfficeCode:String?
    var s_class:String?
    var dealerName:String?
    
    private enum CodingKeys: String, CodingKey
    {
        case Divcode = "Divcode"
        case Category = "Category"
        case S_Usercode = "S_Usercode"
        case companyAssociate = "companyAssociate"
        case s_SKUCategoryCode = "s_SKUCategoryCode"
        case s_DealerCode = "s_DealerCode"
        case s_SalesOfficeCode = "s_SalesOfficeCode"
        case s_class = "s_class"
        case dealerName = "dealerName"
    }
}

class AreaPincode:NSObject, Codable
{
    var s_PinCode:String?
    var s_RegionCode:String?
    var s_RegionName:String?
    var s_BranchCode:String?
    var s_BranchName:String?
    var s_SalesOfficeCode:String?
    var s_SalesOfficeName:String?
    private enum CodingKeys: String, CodingKey
    {
        case s_PinCode = "s_PinCode"
        case s_RegionCode = "s_RegionCode"
        case s_RegionName = "s_RegionName"
        case s_BranchCode = "s_BranchCode"
        case s_BranchName = "s_BranchName"
        case s_SalesOfficeCode = "s_SalesOfficeCode"
        case s_SalesOfficeName = "s_SalesOfficeName"
    }
}

class Product:NSObject, Codable
{
    var code:String?
    var name:String?
    var CatCode:String?
    var CatName:String?
    var price:Double?
    var discount:String?
    var unit:String?
    var categoryCode:String?
    var categoryName:String?
    var qty = 0
    var amount = 0.0
    var dealerName:String?
    var dealDate:String?
    var remark:String?
    var dealerNO:String?
    var dealerCode:String?
    var userCode:String?
    var orderType:String?
    var divisionName:String?
    var productArr:[Product]?
    var SubCategoryCode:String?
    var SubCategoryName:String?
    
    private enum CodingKeys: String, CodingKey
    {
        case code = "codes"
        case name = "Names"
        case CatCode = "CatCode"
        case CatName = "CatName"
        case price = "Price"
        case discount = "Discount"
        case unit = "Unit"
        case categoryCode = "CategoryCode"
        case categoryName = "CategoryName"
        case dealerName = "dealerName"
        case dealDate = "dealDate"
        case remark = "remark"
        case divisionName = "divisionName"
//        case dealerNo = "dealerNo"
//        case dealerCode = "dealerCode"
        case userCode = "userCode"
        case orderType = "orderType"
        case productArr = "productArr"
        case SubCategoryName = "SubCategoryName"
        case SubCategoryCode = "SubCategoryCode"
    }
    
}
//{
//    var code:String?
//    var name:String?
//    var price:Double?
//    var discount:String?
//    var unit:String?
//    var categoryCode:String?
//    var qty = 0
//    var amount = 0.0
//
//    private enum CodingKeys: String, CodingKey
//    {
//        case code = "codes"
//        case name = "Names"
//        case price = "Price"
//        case discount = "Discount"
//        case unit = "Unit"
//        case categoryCode = "CategoryCode"
//    }
//
//}

class Dealer:NSObject, Codable
{
    var s_RetailerSapCode:String?
    var s_FullName:String?
    var TotalCount:Double?
    var MobileNo:String?
    var OrderType:String?
    var FinalMsg:String?
    var categoryCode:String?
    var categoryName:String?
}
//{
//    var s_RetailerSapCode:String?
//    var s_FullName:String?
//    var TotalCount:Double?
//    var MobileNo:String?
//    var OrderType:String?
//}

class Order:NSObject, Codable
{
    var SkuCategory:String?
    var IsDivisinMaterial:String?
    var SkuSubCategory:String?
    var SearchCategory:String?
    var DealerCodeName:String?
    var DealerMobile:String?
    var ExpDeliveryDate:String?
    var skucode:String?
    var QTY:String?
    var AMT:String?
    var MobileNo:String?
    var DealerCode:String?
    var Dates:String?
    var ActionType:String?
    var CreatedBy:String?
    var OrderNo:String?
    var EmpCode:String?
    var SalesOfficeCode:String?
    var UserCode:String?
    var Remark:String?
    var OrderType:String?
    var Source:String?
}

class Area:NSObject, Codable
{
    var stateCode:String?
    var stateName:String?
    var districtCode:String?
    var districtName:String?
    var cityCode:String?
    var cityName:String?
    var areaCode:String?
    var areaName:String?
    var regionCode:String?
    var regionName:String?
    var salesOfficeCode:String?
    var salesOfficeName:String?
    var branchCode:String?
    var branchName:String?
    var pinCode:String?
    
    private enum CodingKeys: String, CodingKey
    {
        case stateCode = "s_StateCode"
        case stateName = "s_StateName"
        case districtCode = "s_DistrictCode"
        case districtName = "s_DistrictName"
        case cityCode = "s_CityCode"
        case cityName = "s_CityName"
        case areaName = "s_AreaName"
        case areaCode = "s_AreaCode"
        case regionCode = "s_RegionCode"
        case regionName = "s_RegionName"
        case salesOfficeCode = "s_SalesOfficeCode"
        case salesOfficeName = "s_SalesOfficeName"
        case branchCode = "s_BranchCode"
        case branchName = "s_BranchName"
        case pinCode = "s_PinCode"
    }
}

class Generic {
    var TotalCount:String?
    var PKID:String?
    var FlashCode:String?
    var SCPM0113:String?
    var Title:String?
    var Messages:String?
    var AttachmentType:String?
    var Types:String?
    var FileAttachment:String?
    var fromDate:String?
    var ToDate:String?
    var Active:String?
    var FileExt:String?
    
    private enum CodingKeys: String, CodingKey
    {
        case TotalCount = "TotalCount"
        case PKID = "PKID"
        case FlashCode = "FlashCode"
        case SCPM0113 = "SCPM0113"
        case Title = "Title"
        case Messages = "Messages"
        case AttachmentType = "AttachmentType"
        case Types = "Types"
        case FileAttachment = "FileAttachment"
        case fromDate = "fromDate"
        case ToDate = "ToDate"
        case Active = "Active"
        case FileExt = "FileExt"
        
    }
}


class Files:NSObject
{
    var fileName:String?
    var documentName:String?
    var documentNo:String?
    var image:UIImage?
}


class Document:NSObject, Codable
{
    var s_DocumnetMasterCode:String?
    var s_DocumentName:String?
    var s_DocumnetNo:String?
    var DocIsActive:Bool?
    var s_FileName:String?
}

class Profile:NSObject, Codable
{
    var s_UserTypeCode:String?
    var s_UserSubTypeCode:String?
    var UserCategoryCode:String?
    var s_UserCode:String?
    var s_FirmCode:String?
    var s_MobileNo:String?
    var s_FullName:String?
    var d_DOB:String?
    var s_EmailID:String?
    var s_Education:String?
    var b_IsActive:String?
    var s_UserCurrentStatus:String?
    var s_ShopName:String?
    var s_ShopAddress1:String?
    var s_ShopAddress2:String?
    var s_ShopAddress3:String?
    var s_ResdAddress1:String?
    var s_ResdAddress2:String?
    var s_RetailerSapCode:String?
    var s_IsVerified:String?
    var RegionCode:String?
    var StateCode:String?
    var DistrictCode:String?
    var CityCode:String?
    var AreaCode:String?
    var PinCode:String?
    var BranchName:String?
    var SalesOfficeName:String?
    var SalesOfficeCode:String?
    var s_GSTType:String?
    var s_GSTNo:String?
    var s_RetailerParentCode:String?
    var s_StatusParentChild:String?
    var s_EmployeeCode:String?
    var s_AccountStatus:String?
    var s_MdmCode:String?
    var s_CreatedSource:String?
    var Documents:String?
    var EmpName:String?
    var RegistrationDate:String?
    var KAMName:String?
    var KAMMobileNo:String?
    var VerifiedBy:String?
    var arr_Documents:[Document]?
    var ModifyDate:String?
    var s_WeeklyOff:String?
    var ProductProfile:String?
}
