//
//  MessageAndError.swift
 
//
//  Created by Apple.Inc on 25/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation

struct MessageAndError
{
    static let userNotFound = "USER NOT FOUND! PLEASE CONTACT TO BRANCH!"
    static let notRetailer = "YOU ARE NOT REGISTERED AS RETAILER! PLEASE REGISTER!"
    static let notElectrician = "NOT A VERIFIED ELECTRICIAN!"
    static let alreadyDeler = "YOU ARE ALREADY REGISTERED DEALER!"
    static let alreadyOFFICE = "YOU ARE ALREADY REGISTERED AS OFFICE!"
    static let alreadyWAREHOUSE = "YOU ARE ALREADY REGISTERED AS WAREHOUSE!"
    static let alreadyHEADOFFICE = "YOU ARE ALREADY REGISTERED AS HEAD OFFICE!"
    static let alreadyRURALDISTRIBUTOR = "YOU ARE ALREADY REGISTERED AS RURAL DISTRIBUTOR!"
    static let alreadyElectrician = "YOU ARE ALREADY REGISTERED ELECTRICIAN!"
    static let enterMobileNumber = "PLEASE ENTER MOBILE NUMBER!"
    static let enterValidMobileNumber = "PLEASE ENTER VALID MOBILE NUMBER!"
    static let enterOtp = "PLEASE ENTER OTP!"
    static let enterValidOtp = "PLEASE ENTER CORRECT OTP!"
    static let noInternetConnection_OTP = "NEED INTERNET CONNECTIVITY TO PERFORM OTP!"
    static let noInternetConnection_SUBMITOTP = "NEED INTERNET CONNECTIVITY TO SUBMIT OTP!"
    static let noInternetConnection_ABOUT = "NEED INTERNET CONNECTIVITY TO VIEW ABOUT RETAILER APP!"
    static let enterPassword = "PLEASE ENTER PASSWORD!"
    static let enterValidPassword = "PLEASE SET PASSWORD AS PER POLICY MENTIONED BELOW!"
    static let confirmPassword = "PASSWORD DOES NOT MATCHES"
    static let noInternetConnection_SETPASSWORD = "NEED INTERNET CONNECTIVITY TO SAVE PASSWORD"
    static let noInternetConnection_RESETPASSWORD = "NEED INTERNET CONNECTIVITY TO RESET THE PASSWORD"
//    static let noInternetConnection_SETPASSWORD = "NEED INTERNET CONNECTIVITY TO SET PASSWORD"
//    static let noInternetConnection_RESETPASSWORD = "NEED INTERNET CONNECTIVITY TO RESET PASSWORD"
    static let selectScheme = "PLEASE SELECT SCHEME!"
    static let loginFailed = "LOGIN FAILED!"
    static let dataNotFound = "DATA NOT FOUND!"
    static let somethingWentWrong = "SOMETHING WENT WRONG!"
    static let credentailStatusNotFound = "AppCredentail service status not found, try agin leater!"
    static let  sessionExpired = "SESSION HAS EXPIRED, PLEASE TRY AGAIN!"
    static let noInternetConnectivityGallery = "NEED INTERNET CONNECTIVITY TO VIEW GALLERY DATA!"
    
    static let uididNotMatchPassword = "YOUR MOBILE NUMBER IS ALREADY REGISTERED ON ANOTHER DEVICE PLEASE UNINSTALL AND REINSTALL THE APP, IF YOU WANTED TO REGISTER THE MOBILE NUMBER AGAIN ON THIS DEVICE"
    //YOU ARE NOT AUTHORIZED TO PERFORM THIS ACTIVITY ON THIS DEVICE AS MOBILE ALREADY REGISTERED ON ANOTHER DEVICE!
    static let uididNotMatch = "YOU ARE NOT AUTHORIZED TO PERFORM THIS ACTIVITY ON THIS DEVICE AS MOBILE ALREADY REGISTERED ON ANOTHER DEVICE!"
    
   // YOUR MOBILE NUMBER IS ALREADY REGISTERED ON ANOTHER DEVICE.IF WANTED TO REGISTER MOBILE NUMBER AGAIN ON THIS DEVICE PLEASE CLICK YES.THEN YOU ARE NOT AUTHORIZED TO PERFORM ANY ACTIVITY ON PREVIOUS DEVICE
    
    static let noAlreadyOnAnotherDevice = "YOUR MOBILE NUMBER IS ALREADY REGISTERED ON ANOTHER DEVICE.IF WANTED TO REGISTER MOBILE NUMBER AGAIN ON THIS DEVICE PLEASE CLICK YES. THEN YOU ARE NOT AUTHORIZED TO PERFORM ANY ACTIVITY ON PREVIOUS DEVICE!"
    static let userNotVerified = "YOUR PROFILE IS NOT YET VERIFIED. PLEASE CONTACT YOUR BRANCH OR SALES PERSON TO VERIFY YOUR PROFILE OR FOR FURTHER INFORMATION CALL 18002660077!"
    static let serviceUnavailable = "THE SERVICE IS UNAVAILABLE!"
    
    static let userNotActive = "YOUR CURRENT STATUS IS INACTIVE! PLEASE CONTACT TO BRANCH!"
    
    static let noInternetConnection = "NO INTERNET CONNECTION! PLEASE CONNECT TO INTERNET AND TRY AGAIN!"
    static let noInternetConnection_SchemeLISTING = "NEED INTERNET CONNECTIVITY TO DOWNLOAD SCHEME DETAILS!"
    static let noInternetConnection_SchemeDETAILS = "NEED INTERNET CONNECTIVITY TO VIEW SCHEME DETAILS!"
    
    static let pointRedeem = "PLEASE ENTER POINTS TO BE REDEEM!"
    static let lessbalance = "ENTER AMOUNT SHOULD BE LESS THAN BALANCE!"
    static let amountbetween = "ENTER AMOUNT BETWEEN 10.00 TO 10000.00!"
    
    static let savePendingTransaction = "YOUR PINS HAVE BEEN STORED OFFLINE. NEED INTERNET CONNECTIVITY TO SUBMIT!"
    static let noBankAccount = "YOU EITHER HAVE NOT ADDED THE BANK DETAILS YET OR YOUR BANK DETAILS ARE UNDER APPROVAL PROCESS PLEASE ADD THE BANK DETAILS OR CHECK THE STATUS FROM BANK DETAILS TAB!"
    static let noApprovedBankAccount = "NO APPROVED BANK ACCOUNT FOUND! PLEASE CONTACT TO BRANCH!"

    static let noInternetConnection_REDEMPTION = "NEED INTERNET CONNECTIVITY TO PERFORM REDEMPTION!"

    static let noInternetConnection_ACCUMULATION = "NEED INTERNET CONNECTIVITY TO PERFORM ACCUMULATION!"
    static let noInternetConnection_DASHBOARD = "NEED INTERNET CONNECTIVITY TO VIEW DASHBOARD!"
    static let noInternetConnection_BANKDETAILS = "NEED INTERNET CONNECTIVITY TO VIEW/ADD BANK DETAILS!"
    static let noInternetConnection_TRANSACTIONHISTORY = "NEED INTERNET CONNECTIVITY TO VIEW TRANSACTION HISTORY!"
    static let noInternetConnection_PRICELIST = "NEED INTERNET CONNECTIVITY TO VIEW/DOWNLOAD PRICE LIST!"
    
    static let noInternetConnection_ABOUTLOYALTY = "NEED INTERNET CONNECTIVITY TO VIEW ABOUT LOYALTY!"
    
    static let noInternetConnection_ViewNotInSystem = "NEED INTERNET CONNECTIVITY TO VIEW PINSWISE SUMMARY"

    static let noInternetConnection_SyncNotification = "NEED INTERNET CONNECTIVITY TO SYNC NOTIFICATION!"

    static let noInternetConnection_SAMPARKWEB = "NEED INTERNET CONNECTIVITY TO GO AT RETAILER WEB!"
    static let noInternetConnection_SCEHEMERESULT = "NEED INTERNET CONNECTIVITY TO VIEW SCHEME DETAILS!"

    static let noInternetConnection_SCEHEMERESULT_DOWNLOAD = "NEED INTERNET CONNECTIVITY TO DOWNLOAD SCHEME DETAILS!"

    static let noInternetConnection_PROFILE = "NEED INTERNET CONNECTIVITY TO VIEW/EDIT PROFILE!"
    static let edit_PROFILE = "DO YOU REALLY WANT TO EDIT THE PROFILE!"

    
    static let noInternetConnection_SERVICEREQUEST = "NEED INTERNET CONNECTIVITY TO VIEW/RAISE CUSTOMER SERVICE!"
    static let noInternetConnection_REFRESHBALANCE = "NEED INTERNET CONNECTIVITY TO REFRESH THE BALANCE!"
    static let noInternetConnection_SUAREY = "NEED INTERNET CONNECTIVITY TO PERFORM THE SURVEY!"
    static let noInternetConnection_ORDER = "NEED INTERNET CONNECTIVITY TO PLACE ORDER!"
    static let noInternetConnection_GALLERY = "NEED INTERNET CONNECTIVITY TO VIEW GALLERY!"
    static let noInternetConnection_CHANGELANGUAGE = "NEED INTERNET CONNECTIVITY TO PERFORME THE CHANGE LANGUAGE!"
   static let noInternetConnection_DMSBILLING = "NEED INTERNET CONNECTIVITY TO PERFORM THE DMSBILLING!"
   static let noInternetConnection_PROFOLIO = "NEED INTERNET CONNECTIVITY TO VIEW RETAILER PROFOLIO!"
    
    static let noDataAvailable = "NO DATA AVAILABLE!"
    static let bankAccountEmpty = "BANK ACCOUNT NUMBER SHOULD  NOT BE EMPTY!"
    static let bankAccountNo10_25 = "ENTER 10-25 DIGIT BANK ACCOUNT N0!"
    static let ifscEmpty = "BANK IFSC CODE SHOULD NOT BE EMPTY!"
    static let invalidIFSC = "INVALID IFSC FORMAT!"
    static let ifsc11Digit = "BANK IFSC CODE SHOULD BE 11 DIGIT!"
    static let bankNameEmpty = "BANK NAME SHOULD NOT BE EMPTY!"
    static let bankAddressEmpty = "BANK ADDRESS SHOULD NOT BE EMPTY!"
    static let accountHolderNameEmpty = "ACCOUNT HOLDER NAME SHOULD NOT BE EMPTY!"
    static let resetPassword = "YOUR PASSWORD IS NOT RESET FROM LAST 90 DAYS. YOU HAVE NEED TO RESET PASSWORD TO ACCESS THE RETAILER PROGRM!"
    static let pendingPinToAccumulate = "YOU HAVE PINS TO ACCUMULATE ONLINE YET! KINDLY SYNC DATA ONLINE!"
    static let server_is_Busy = "WEAK INTERNET CONNECTION. PLEASE TRY AGAIN"
    static let notConnectedInternet = "NEED INTERNET CONNECTIVITY TO SEND THE OTP"
    
    static let selectStartDate = "SELECT START DATE!"
    static let selectEndDate = "SELECT END DATE!"
    static let selectChequesImage = "PLEASE SELECT CHEQUE IMAGE!"
    static let imageSize = "IMAGE SIZE SHOULD BE 3MB OR LESS!"
    static let imageUploaded = "IMAGE UPLOADED SUSSESSFULLY!"
    static let enterCorrectPassword = "PLEASE ENTER CORRECT PASSWORD!"
    static let chqName = "CHQ NAME SHOULD BE IN THE NAME OF BUSINESS NAME IN CASE FIRM TYPE IS COMPANY/PARTNERSHIP ELSE SHOULD BE IN THE NAME OF OWNER NAME OR BUSINESS NAME!"
    static let pendingPinsToAccumulate = "YOU HAVE PENDING PINS TO ACCUMULATE! PLEASE CLICK ON SUBMIT!"
    static let enterElectricalMobileNo = "ENTER ELECTRICIAN MOBILE NO!"
    static let enterValidElectricalMobileNo = "ENTER VALID ELECTRICAL MOBILE NO!"
    static let enterPin = "PLEASE ENTER PIN!"
    static let sendSMS = "ACCUMULATION SUMMARY SMS HAS BEEN SENT TO YOUR MOBILE NO. SAVE/SHARE THE ACCUMULATION SUMMARY FOR YOUR RECORDS IF NEEDED. ONCE EXIT FROM SCREEN TRANSACTION DETAILS CAN NOT BE VIEWED!"// BACK!"
    static let noHistory = "NO TRANSACTION FOUND BETWEEN SELECTED DATES!"
    static let switchScheme = "DO YOU REALLY WANT TO SELECT OTHER SCHEME"
//    "DO YOU REALLY WANT TO SWITCH SCHEME!"
    static let doYouWantExit = "DO YOU REALLY WANT TO EXIT!"
    
    static let doYouWantLogout = "DO YOU REALLY WANT TO EXIT!" // LOGOUT!"
    static let appUpdate = "NEW VERSION OF RETAILER APP IS AVAILABLE. KINDLY UPDATE!"
    static let notificationNoAttachment = "NO ATTACHMENT FOUND"
    static let schemeResultDataNotFound = "DATA NOT FOUND!"
    static let pendingsurvey = "YOU HAVE PENDING SURVAY,DO YOU WANT TO FILL?"
    
    //order
    static let addProduct = "PRODUCT NOT FOUND! PLEASE ADD PRODUCT TO PROCESSED"
    static let valueNotFound = "VALUE NOT FOUND!"
    static let productNotFound = "PRODUCT NOT FOUND"
    static let selectDealer = "PLEASE SELECT PARTNER!"
    static let enterDealerName = "PLEASE ENTER DEALER NAME/CODE"
    static let enterDealerMobile = "PLEASE ENTER DEALER MOBILE NUMBER"
    static let dealerNotFound = "DEALER NOT FOUND PLEASE SELECT ANOTHER!"
    static let enterRemark = "PLEASE ENTER REMARK"
    static let enterDate = "PLEASE ENTER DATE"

    static let productListErrorMsg = "IF YOU HAVE ITEMS IN ORDER CART, THEN CART WILL BE EMPTY!"
    static let productListPreviousPage = "DO YOU WANT TO GO TO PREVIOUS PAGE!"
    static let doyouwanttodelete = "DO YOU REALLY WANT TO REMOVE THIS ITEM FROM CART!"
    
    //Regitration
    static let selectFirmType = "PLEASE SELECT FIRM TYPE"
    static let selectRetailerType = "PLEASE SELECT RETAILER TYPE"
    static let selectRetailerCategory = "PLEASE SELECT RETAILER CATAGORY"

    static let enterFirmName = "PLEASE ENTER FIRM NAME!"
    static let enterOwnerName = "PLEASE ENTER OWNER FULL NAME!"
    static let enterAddress = "ENTER FIRM ADDRESS!"
    static let selectSate = "PLEASE SELECT STATE!"
    static let selectDistrict = "PLEASE SELECT DISTRICT!"
    static let selectCity = "PLEASE SELECT CITY!"
    static let selectArea = "PLEASE SELECT AREA!"
    static let enterPinCode = "PLEASE ENTER PINCODE!"
    static let validPinCode = "ENTER VALID PINCODE!"
    static let selectBranchName = "PLEASE SELECT BRANCH NAME!"
    static let selectBranch = "PLEASE SELECT BRANCH NAME!"
    static let enterEmail = "PLEASE ENTER EMAIL ADDRESS!"
    static let enterValidEmail = "ENTER VALID EMAIL ADDRESS!"
    static let enterRetailerSapCode = "PLEASE ENTER RETAILER SAP CODE!"
    static let enterAadharNo = "PLEASE ENTER AADHER NUMBER!"
    static let validAadherNo = "ENTER VALID AADHER NUMBER!"
    static let enterPanNo = "PLEASE ENTER PAN CARD NUMBER!"
    static let validPanNO = "ENTER VALID PAN NUMBER!"
    static let selectGstType = "PLEASE SELECT GST TYPE!"
    static let enterGstNO = "PLEASE ENTER GST NUMBER!"
    static let enterValidGstNO = "PLEASE ENTER VALID GST NUMBER!"
    static let selectParentChildStaus = "PLEASE SELECT PARENT CHILD STAUS"
    static let enterParentMobileNo = "PLEASE ENTER PARENT MOBILE NUMBER!"
    static let selectOwnerImage = "PLEASE SELECT OWNER IMAGE!"
    static let selectAadherImage = "PLEASE SELECT AADHAR IMAGE!"
    static let selectPanImage = "PLEASE SELECT PAN IMAGE!"
    static let selectGstIamge = "PLEASE SELECT GST IMAGE!"
    static let selectShopImage = "PLEASE SELECT SHOP IMAGE!"
    static let selectOtherImage = "PLEASE SELECT OTHER IMAGE!"
    static let enterBizz = "PLEASE ENTER MONTHLY BIZZ!"

    
    static let noInternetConnection_REDEEMVOUCHER = "NEED INTERNET CONNECTIVITY TO REDEEM VOUCHER!"
    static let noInternetConnection_MOBILETOPUP = "NEED INTERNET CONNECTIVITY TO DO MOBILE TOPUP!"
     static let noInternetConnection_BANKTRANSFER = "NEED INTERNET CONNECTIVITY TO PERFORM BANK TRANSFER!"
    static let selectOpretor = "PLEASE SELECT OPERATOR!"
    static let rechargeAmountBetween = "ENTERED AMOUNT BETWEEN 1.00 TO 1000.00!"
    static let voucherAdded = "VOUCHER ADDED IN CART SUSSESSFULLY!"
    static let voucherAddedFailed = "VOUCHER ADDED IN CART FAILD!"
    static let voucherDelete = "DO YOU REALLY WANT TO DELETE VOUCHER FROM CART!"


}
