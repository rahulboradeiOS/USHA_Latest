//
//  UserProfileViewController.swift
 
//
//  Created by Apple.Inc on 22/12/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//


import UIKit
import Alamofire
import DropDown
import AssetsLibrary
import BEMCheckBox

enum ImageType: String
{
//    case OwnerImage
    case AdharImage
    case PanImage
    case GstImage
    case ShopImage
    case OtherImage
    case UserProfileImage
    case none
}

enum DocType: String
{
    case Adhar = "DOC001"
    case Pan = "DOC002"
    case Gst = "DOC004"
    case Shop = "DOC005"
    case ShopDoc = "DOC057"
    case TinNumber = "DOC065"
    case User =  "DOC076"
}
//MARK: DISTRIBUTOR TABLE DROPDOWNS CLASSES
class fst_collect { //1st dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct fst_check {
    var name : String
}

class sec_collect { //2st dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct sec_check {
    var name : String
}

class third_collect { //3rd dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct third_check {
    var name : String
}

class forth_collect { //4th dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct forth_check {
    var name : String
}

class fifth_collect { //5th dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct fifth_check {
    var name : String
}

class six_collect { //6th dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct six_check {
    var name : String
}

class seven_collect { //7th dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct seven_check {
    var name : String
}

class eight_collect { //8th dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct eight_check {
    var name : String
}

class nine_collect { //9th dropDown

var name: String?

init(name: String?){

    self.name = name
  }
 }
struct nine_check {
    var name : String
}

//MARK: API Dropdown data

struct api_data: Codable { // dropDown data

var Checked: String
var CreatedBy: String
var DealerCode: String
var DivisionCode: String
var ProductName: String
var SalesOfficeCode: String
var UserCode: String
var productCategory: String
    
}


class UserProfileViewController: BaseViewController,UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    
    @IBOutlet var address1TextField: SkyFloatingLabelTextField!
    @IBOutlet var registrationdateTextField: SkyFloatingLabelTextField!
    @IBOutlet var registrationTextField: SkyFloatingLabelTextField!
    @IBOutlet var hevellsIdTextField: SkyFloatingLabelTextField!
    @IBOutlet var userStatusTextField: SkyFloatingLabelTextField!
    @IBOutlet var userSubtypeTextField: SkyFloatingLabelTextField!
    @IBOutlet var userTypeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var LasrActionTextField: SkyFloatingLabelTextField!
    //@IBOutlet var kamNameLabel: UILabel!
    @IBOutlet var labelVerifiedBy: UILabel!
    @IBOutlet var labelCurrentStatus: UILabel!
    @IBOutlet var labelCreatedBy: UILabel!
    @IBOutlet var labelLastActivationDate: UILabel!
    @IBOutlet var verifiedLabel: UILabel!
    @IBOutlet var createdLabel: UILabel!
    //@IBOutlet var profileVerifiedStatusLabel: UILabel!
    //@IBOutlet var profileVerifiedStaticLabel: UILabel!
    //@IBOutlet var profileVerifiedLabel: UILabel!
    @IBOutlet var lastActivationLabel: UILabel!
    @IBOutlet var userCurrentStatusLabel: UILabel!
    @IBOutlet var profileUnderEditLabel: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_edit_top: NSLayoutConstraint!
    @IBOutlet weak var btn_edit_h: NSLayoutConstraint!
    @IBOutlet weak var btn_edit_height: NSLayoutConstraint!
    @IBOutlet weak var view_firmType: UIView!
    @IBOutlet weak var txt_selectFirmType: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectFirmType: UIButton!
    @IBOutlet weak var btn_selectFirmType_width: NSLayoutConstraint!
    
    @IBOutlet weak var txt_firmName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txt_ownerName: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_ownerMobileNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txt_address: SkyFloatingLabelTextField!
    
    @IBOutlet weak var view_state: UIView!
    @IBOutlet weak var txt_selectState: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectState: UIButton!
    @IBOutlet weak var btn_selectState_width: NSLayoutConstraint!
    
    @IBOutlet weak var view_district: UIView!
    @IBOutlet weak var txt_selectDistrict: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectDistrict: UIButton!
    @IBOutlet weak var btn_selectDistrict_width: NSLayoutConstraint!
    
    @IBOutlet weak var view_city: UIView!
    @IBOutlet weak var txt_selectCity: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectCity: UIButton!
    @IBOutlet weak var btn_selectCity_width: NSLayoutConstraint!
    
    @IBOutlet weak var view_pinCode: UIView!
    //@IBOutlet weak var view_KamDetails: UIView!

    @IBOutlet weak var view_area: UIView!
    @IBOutlet weak var txt_selectArea: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectArea: UIButton!
    @IBOutlet weak var btn_selectArea_width: NSLayoutConstraint!
    
    @IBOutlet weak var txt_pincode: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_pincode_width: NSLayoutConstraint!
    
    @IBOutlet weak var btn_PinRefresh: UIButton!
    
    @IBOutlet weak var btn_PinRefresh_width: NSLayoutConstraint!
    @IBOutlet weak var view_branchName: UIView!
    @IBOutlet weak var txt_selectBranchName: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectBranchName: UIButton!
    @IBOutlet weak var btn_selectBranchName_width: NSLayoutConstraint!
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var txt_email: SkyFloatingLabelTextField!
    
    //    @IBOutlet weak var txt_sapCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_retailerSapCode: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txt_aadherNo: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txt_panNo: SkyFloatingLabelTextField!
    
    @IBOutlet weak var view_gstType: UIView!
    @IBOutlet weak var txt_selectGSTType: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectGSTType: UIButton!
    @IBOutlet weak var btn_selectGSTType_width: NSLayoutConstraint!
    @IBOutlet weak var verifyExtraContents: NSLayoutConstraint!
    
    @IBOutlet weak var txt_gstNo: SkyFloatingLabelTextField!
    
    @IBOutlet weak var view_parentChildStatus: UIView!
    @IBOutlet weak var txt_selectParentChildStatus: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectParentChildStatus: UIButton!
    @IBOutlet weak var btn_selectParentChildStatus_width: NSLayoutConstraint!
    
    @IBOutlet weak var txt_parentMobileNo: SkyFloatingLabelTextField!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var view_ownerImage: UIView!
    @IBOutlet weak var lbl_ownerImage: UILabel!
    @IBOutlet weak var img_ownerImage: UIImageView!
    @IBOutlet weak var btn_ownerImage: UIButton!
    
    @IBOutlet weak var view_aadharImage: UIView!
    @IBOutlet weak var lbl_aadharImage: UILabel!
    @IBOutlet weak var img_aadharImage: UIImageView!
    @IBOutlet weak var btn_aadherImage: UIButton!
    
    @IBOutlet weak var view_panImage: UIView!
    @IBOutlet weak var lbl_panImage: UILabel!
    @IBOutlet weak var img_panImage: UIImageView!
    @IBOutlet weak var btn_panImage: UIButton!
    
    @IBOutlet weak var view_gstImage: UIView!
    @IBOutlet weak var lbl_gstImage: UILabel!
    @IBOutlet weak var img_gstImage: UIImageView!
    @IBOutlet weak var btn_gstImage: UIButton!
    
    @IBOutlet weak var view_shopImage: UIView!
    @IBOutlet weak var lbl_shopImage: UILabel!
    @IBOutlet weak var img_shopImage: UIImageView!
    @IBOutlet weak var btn_shopImage: UIButton!
    
    @IBOutlet weak var view_otherImage: UIView!
    @IBOutlet weak var lbl_otherImage: UILabel!
    @IBOutlet weak var img_otherImage: UIImageView!
    @IBOutlet weak var btn_otherImage: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    
    @IBOutlet var vieew:UIView!
    @IBOutlet var imgVw:UIImageView!
    @IBOutlet weak var BTN_OWNER_O: UIButton!
    
    @IBOutlet weak var BTN_AADHAR_O: UIButton!
    @IBOutlet weak var BTN_PAN_O: UIButton!
    
    @IBOutlet weak var BTN_GST_O: UIButton!
    @IBOutlet weak var BTN_SHOPE_O: UIButton!
    @IBOutlet weak var BTN_OTHER_O: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lbl_firmtype: UILabel!
    @IBOutlet weak var lbl_FirmName: UILabel!
    @IBOutlet weak var lbl_OwnerName: UILabel!
    @IBOutlet weak var lbl_mobileNo: UILabel!
    @IBOutlet weak var lbl_address1: UILabel!
    @IBOutlet weak var lbl_address2: UILabel!
    @IBOutlet weak var lbl_state: UILabel!
    @IBOutlet weak var lbl_distric: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_area: UILabel!
    @IBOutlet weak var lbl_pincode: UILabel!
    @IBOutlet weak var lbl_branchname: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_aadhar: UILabel!
    @IBOutlet weak var lbl_gsttype: UILabel!
    @IBOutlet weak var lbl_gstNo: UILabel!
    @IBOutlet weak var lbl_userstatus: UILabel!
    @IBOutlet weak var lbl_userSubType: UILabel!
    @IBOutlet weak var lbl_CurrentStatus: UILabel!
    @IBOutlet weak var lbl_lastActionDate: UILabel!
    @IBOutlet weak var lbl_regDate: UILabel!
    @IBOutlet weak var lbl_pan: UILabel!
    
    
    
    @IBOutlet weak var view_selectRetailer: UIView!
    @IBOutlet weak var view_selectRetailerCategory: UIView!
    
    @IBOutlet weak var btn_retailerType: UIButton!
    @IBOutlet weak var btn_retailerCategory: UIButton!
    
    @IBOutlet weak var txt_selectRetailerType: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_selectRetailerCategory: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var txt_monthlybizz: SkyFloatingLabelTextField!
    
    
    
    var image = UIImage()
    var enteredMobileNo  :String!
    
    var panString : String = ""
    var gstString : String = ""
    var aadharString : String = ""
    var demoURL : URL!
    var flag = 0
    
    var productString = String()
    var retailerTypeString = String()
    var retailerCategoryCode = String()
    
    @IBAction func fstAction(_ sender:UIButton){
        
//        vieew.center = self.view.center
//
//        self.scrollView.inputView?.addSubview(vieew)
        
        vieew.isHidden = false
        imgVw.isHidden = false
        //img_ownerImage.isHidden = true
        if sender.tag == 1{
            image = self.img_ownerImage.image!
            imgVw.image = image
        }else if sender.tag == 2{
            image = self.img_aadharImage.image!
            imgVw.image = image
        }else if sender.tag == 3{
            image = self.img_panImage.image!
            imgVw.image = image
        }else if sender.tag == 4{
            image = self.img_gstImage.image!
            imgVw.image = image
        }else if sender.tag == 5{
            image = self.img_shopImage.image!
            imgVw.image = image
        }else if sender.tag == 6{
            image = self.img_otherImage.image!
            imgVw.image = image
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgVw
    }
    let selectDropDown = DropDown()
    
    let imgPicker : UIImagePickerController = UIImagePickerController()
    
    
    var imageType = ImageType.none
    
    var panFromGSTNo = ""
    var callAction = ""
    
    var txt_responder:UITextField?
    
    var arr_productNameCode = [Division]()
    
//    var arr_productProfile = [ProductProfile]()
    
    var arr_FirmCode = [Division]()
    var arr_State = [Division]()
    var arr_District = [Division]()
    var arr_City = [Division]()
    var arr_Area = [Division]()
    var arr_PinCode = [AreaPincode]()
    var arr_RetailerType = [Division]()
    var arr_RetailerCategory = [Division]()
    //var arr_AreaByPincode = [Area]()
    
    var firm = Division()
    var area = Area()
    var arr_gstType = ["SELECT GST TYPE", "NORMAL", "COMPOSITE"]
    var arr_parentChildStatus = ["PARENT", "CHILD"]
    
    var profilrPincode = ""
    //    var ownerMobile = ""
    var DuplicateNo = ""
    
    var arr_fileUpload = [Files]()
    var files = [Any]()
    var arr_fileUploadToServer = [Files]()
    var productArray = [Any]()

    
    

    var alertTag = 0
    var usercode = ""
    var strLan:String = ""
    
    var isRgistration:Bool!
    var isProfileEditing = false
    var profile:Profile!
    var showPincodeEntering: Bool = false
//MARK: DISTRIBUTER TABLE OUTLETS:RB
    
    var allDropDownData : [api_data] = [api_data]()

    @IBOutlet weak var DistributerTableView: UITableView!
    @IBOutlet weak var secDistributerTableView: UITableView!
    @IBOutlet weak var thirdDistributerTableView: UITableView!
    @IBOutlet weak var forthDistributerTableView: UITableView!
    @IBOutlet weak var fifthDistributerTableView: UITableView!
    @IBOutlet weak var sixDistributerTableView: UITableView!
    @IBOutlet weak var sevenDistributerTableView: UITableView!
    @IBOutlet weak var eightDistributerTableView: UITableView!
    @IBOutlet weak var nineDistributerTableView: UITableView!
    
    
    var items : [String] = []
    var secItems : [String] = []
    var thirdItems : [String] = []
    var forthItems : [String] = []
    var fifthItems : [String] = []
    var sixItems : [String] = []
    var sevenItems : [String] = []
    var eightItems : [String] = []
    var nineItems : [String] = []
    
    var fstCodes : String?
    var secCodes : [String] = []
    var thirdCodes : [String] = []
    var forthCodes : [String] = []
    var fifthCodes : [String] = []
    var sixCodes : [String] = []
    var sevenCodes : [String] = []
    var eightCodes : [String] = []
    var nineCodes : [String] = []
    
    var collection : [fst_check] = [fst_check]()
    var check : [fst_collect] = [fst_collect]()
    
    var secCollection : [sec_collect] = [sec_collect]()
    var secCheck : [sec_check] = [sec_check]()
    
    var thirdCollection : [third_collect] = [third_collect]()
    var thirdCheck : [third_check] = [third_check]()
    
    var forthCollection : [forth_collect] = [forth_collect]()
    var forthCheck : [forth_check] = [forth_check]()
    
    var fifthCollection : [fifth_collect] = [fifth_collect]()
    var fifthCheck : [fifth_check] = [fifth_check]()
    
    var sixCollection : [six_collect] = [six_collect]()
    var sixCheck : [six_check] = [six_check]()
    
    var sevenCollection : [seven_collect] = [seven_collect]()
    var sevenCheck : [seven_check] = [seven_check]()
    
    var eightCollection : [eight_collect] = [eight_collect]()
    var eightCheck : [eight_check] = [eight_check]()
    
    var nineCollection : [nine_collect] = [nine_collect]()
    var nineCheck : [nine_check] = [nine_check]()
    
    
    
    let FstDropDown = DropDown()
    let secDropDown = DropDown()
    let thirdDropDown = DropDown()
    let forthDropDown = DropDown()
    let fifthDropDown = DropDown()
    let sixDropDown = DropDown()
    let sevenDropDown = DropDown()
    let eightDropDown = DropDown()
    let nineDropDown = DropDown()
    
    let fstClass_DropDown = DropDown()
    let secClass_DropDown = DropDown()
    let thirdClass_DropDown = DropDown()
    let forthClass_DropDown = DropDown()
    let fifthClass_DropDown = DropDown()
    let sixClass_DropDown = DropDown()
    let sevenClass_DropDown = DropDown()
    let eightClass_DropDown = DropDown()
    var nineClass_DropDown = DropDown()
    var ninecc_Data = DropDown()
    
    @IBOutlet weak var fstClassDropDown: UIView!
    @IBOutlet weak var secClassDropDown: UIView!
    @IBOutlet weak var thirdClassDropDown: UIView!
    @IBOutlet weak var forthClassDropDown: UIView!
    @IBOutlet weak var fifthClassDropDown: UIView!
    @IBOutlet weak var sixClassDropDown: UIView!
    @IBOutlet weak var sevenClassDropDown: UIView!
    @IBOutlet weak var eightClassDropDown: UIView!
    @IBOutlet weak var nineClassDropDown: UIView!
    
    @IBOutlet weak var fstClassLbl: UILabel!
    @IBOutlet weak var secClassLbl: UILabel!
    @IBOutlet weak var threeClassLbl: UILabel!
    @IBOutlet weak var fourClassLbl: UILabel!
    @IBOutlet weak var fiveClassLbl: UILabel!
    @IBOutlet weak var sixClassLbl: UILabel!
    @IBOutlet weak var sevenClassLbl: UILabel!
    @IBOutlet weak var eightClassLbl: UILabel!
    @IBOutlet weak var nineClassLbl: UILabel!
    
   //checkbox
    @IBOutlet weak var fstCheckbox: BEMCheckBox!
    @IBOutlet weak var secCheckbox: BEMCheckBox!
    @IBOutlet weak var thirdCheckbox: BEMCheckBox!
    @IBOutlet weak var forthCheckbox: BEMCheckBox!
    @IBOutlet weak var fifthCheckbox: BEMCheckBox!
    @IBOutlet weak var sixthCheckbox: BEMCheckBox!
    @IBOutlet weak var seventhCheckbox: BEMCheckBox!
    @IBOutlet weak var eighthCheckbox: BEMCheckBox!
    @IBOutlet weak var ninthCheckbox: BEMCheckBox!
    
    
    
    var index: NSIndexPath?
    var fstListData = [String]()
    var secListData = [String]()
    var threeListData = [String]()
    var fourListData = [String]()
    var fiveListData = [String]()
    var sixListData = [String]()
    var sevenListData = [String]()
    var eightListData = [String]()
    var nineListData = [String]()
    
    var fstCodeListData = [String]()
    var secCodeListData = [String]()
    var threeCodeListData = [String]()
    var fourCodeListData = [String]()
    var fiveCodeListData = [String]()
    var sixCodeListData = [String]()
    var sevenCodeListData = [String]()
    var eightCodeListData = [String]()
    var nineCodeListData = [String]()
    
    var fstClass:String=""
    var secClass:String=""
    var threeClass:String=""
    var fourClass:String=""
    var fiveClass:String=""
    var sixClass:String=""
    var SevenClass:String=""
    var EightClass:String=""
    var NineClass:String=""
    
    var fstDiv:String=""
    var secDiv:String=""
    var threeDiv:String=""
    var fourDiv:String=""
    var fiveDiv:String=""
    var sixDiv:String=""
    var SevenDiv:String=""
    var EightDiv:String=""
    var NineDiv:String=""
    
    var fstDivName:String=""
    var secDivName:String=""
    var threeDivName:String=""
    var fourDivName:String=""
    var fiveDivName:String=""
    var sixDivName:String=""
    var SevenDivName:String=""
    var EightDivName:String=""
    var NineDivName:String=""
    
    var fstCode:String=""
    var secCode:String=""
    var threeCode:String=""
    var fourCode:String=""
    var fiveCode:String=""
    var sixCode:String=""
    var sevenCode:String=""
    var eightCode:String=""
    var nineCode:String=""
    
    var dataFst:api_data?
    var dataSec:api_data?
    var dataThree:api_data?
    var dataFour:api_data?
    var dataFive:api_data?
    var dataSix:api_data?
    var dataSeven:api_data?
    var dataEight:api_data?
    var dataNine:api_data?

    
    var dropdownJson = [Any]()
    
    var zipCode:String=""
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addReginTapGesture()
        vieew.isHidden = true
        imgVw.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        imgVw.isUserInteractionEnabled = true
        imgVw.addGestureRecognizer(tap)
        
        let headerNib = UINib.init(nibName: "HeaderView", bundle: Bundle.main)
        tblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderView")
        
//        self.tblView.reloadData()
        
        self.BTN_OWNER_O.tag = 1
        self.BTN_AADHAR_O.tag = 2
        self.BTN_PAN_O.tag = 3
        self.BTN_GST_O.tag = 4
        self.BTN_SHOPE_O.tag = 5
        self.BTN_OTHER_O.tag = 6
        
        scrolView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
//        let tap2 = UITapGestureRecognizer(target: self, action:#selector(kAMNoCall))
//        kamNameLabel.addGestureRecognizer(tap2)
        
        txt_ownerMobileNumber.text = self.enteredMobileNo
        
        
        labelCreatedBy.clipsToBounds = true
        labelCreatedBy.borderWidth = 1
        labelCreatedBy.borderColor = UIColor.gray
        labelVerifiedBy.clipsToBounds = true
        labelVerifiedBy.borderWidth = 1
        labelVerifiedBy.borderColor = UIColor.gray
        labelCurrentStatus.clipsToBounds = true
        labelCurrentStatus.borderWidth = 1
        labelCurrentStatus.borderColor = UIColor.gray
        labelLastActivationDate.clipsToBounds = true
        labelLastActivationDate.borderWidth = 1
        labelLastActivationDate.borderColor = UIColor.gray
        lastActivationLabel.clipsToBounds = true
        lastActivationLabel.borderColor = UIColor.gray
        lastActivationLabel.borderWidth = 1
        createdLabel.clipsToBounds = true
        createdLabel.borderColor = UIColor.gray
        createdLabel.borderWidth = 1
        verifiedLabel.clipsToBounds = true
        verifiedLabel.borderColor = UIColor.gray
        verifiedLabel.borderWidth = 1
        userCurrentStatusLabel.clipsToBounds = true
        userCurrentStatusLabel.borderColor = UIColor.gray
        userCurrentStatusLabel.borderWidth = 1
        if isProfileEditing == false{
            btn_edit.backgroundColor = UIColor.red
        }else{
            btn_edit.backgroundColor = UIColor.gray
        }
        setupDropDown()
        
//        callAction = ActionType.ProductProfile
//        getData()
        
        if(isRgistration! == true)
        {
            
            verifyExtraContents.constant = 0
           // profileVerifiedStaticLabel.isHidden = true
       
            topView.isHidden = true
            
            self.lbl_Title.text = "New Registration"
            
            btn_edit_top.constant = 0
            btn_edit_height.constant = 0
            btn_edit.isHidden = true
            //kamNameLabel.isHidden = true
            profileUnderEditLabel.isHidden = true
            //profileVerifiedLabel.isHidden = true
            
            self.txt_panNo.isEnabled = true
            self.txt_panNo.textColor = UIColor.black
            
            textfiled(enable: true)
            usercode = ""
            
            callAction = ActionType.ProductProfile
            getData()
            
        }
            
        else
        {
     
            topView.isHidden = false
            verifyExtraContents.constant = 0
           // profileVerifiedStaticLabel.isHidden = false
            txt_ownerMobileNumber.isUserInteractionEnabled = false
            
            textfiled(enable: false)
            btn_submit.isHidden = true
            
            usercode = DataProvider.sharedInstance.userDetails.s_UserCode!
//            callAction = ActionType.Edit
//            getData()
            callAction = ActionType.ProductProfile
            getData()
        }
        
  
        txt_selectFirmType.delegate = self
        txt_selectFirmType.updateLengthValidationMsg(MessageAndError.selectFirmType)
        txt_firmName.delegate = self
        txt_firmName.updateLengthValidationMsg(MessageAndError.enterFirmName)
        txt_ownerName.delegate = self
        txt_ownerName.updateLengthValidationMsg(MessageAndError.enterOwnerName)
        txt_ownerMobileNumber.delegate = self
        txt_ownerMobileNumber.updateLengthValidationMsg(MessageAndError.enterMobileNumber)
        txt_ownerMobileNumber.addRegx(mobileRegEx, withMsg: MessageAndError.enterValidMobileNumber)
        txt_address.delegate = self
        txt_address.updateLengthValidationMsg(MessageAndError.enterAddress)
        txt_selectState.delegate = self
        txt_selectState.updateLengthValidationMsg(MessageAndError.selectSate)
        txt_selectDistrict.delegate = self
        txt_selectDistrict.updateLengthValidationMsg(MessageAndError.selectDistrict)
        txt_selectCity.delegate = self
        txt_selectCity.updateLengthValidationMsg(MessageAndError.selectCity)
        txt_selectArea.delegate = self
        txt_selectArea.updateLengthValidationMsg(MessageAndError.selectArea)
        txt_pincode.delegate = self
        txt_pincode.updateLengthValidationMsg(MessageAndError.enterPinCode)
        txt_pincode.addRegx(pinCodeRegEx, withMsg: MessageAndError.validPinCode)
        txt_selectBranchName.delegate = self
        txt_selectBranchName.updateLengthValidationMsg(MessageAndError.selectBranchName)
        txt_email.delegate = self
        txt_email.updateLengthValidationMsg(MessageAndError.enterEmail)
        txt_email.addRegx(emailRegEx, withMsg: MessageAndError.enterValidEmail)
        txt_aadherNo.delegate = self
        txt_aadherNo.updateLengthValidationMsg(MessageAndError.enterAadharNo)
        //txt_aadherNo.addRegx(aadherRegEx, withMsg: MessageAndError.validAadherNo)
        txt_panNo.delegate = self
        txt_panNo.updateLengthValidationMsg(MessageAndError.enterPanNo)
        txt_panNo.autocapitalizationType = .allCharacters
        txt_selectGSTType.delegate = self
        txt_selectGSTType.updateLengthValidationMsg(MessageAndError.selectGstType)
        txt_gstNo.delegate = self
        txt_gstNo.updateLengthValidationMsg(MessageAndError.enterGstNO)
        txt_gstNo.addRegx(gstRegEx, withMsg: MessageAndError.enterValidGstNO)
        txt_gstNo.autocapitalizationType = .allCharacters
        txt_selectParentChildStatus.delegate = self
        txt_selectParentChildStatus.updateLengthValidationMsg(MessageAndError.selectParentChildStaus)
        txt_parentMobileNo.delegate = self
        txt_parentMobileNo.updateLengthValidationMsg(MessageAndError.enterMobileNumber)
        txt_parentMobileNo.addRegx(mobileRegEx, withMsg: MessageAndError.enterValidMobileNumber)
        txt_panNo.delegate = self
        txt_panNo.updateLengthValidationMsg(MessageAndError.enterPanNo)
        txt_panNo.addRegx(panCardRegEx, withMsg: MessageAndError.validPanNO)
        
        txt_selectRetailerType.delegate = self
        txt_selectRetailerType.updateLengthValidationMsg(MessageAndError.selectRetailerType)
        
        txt_selectRetailerCategory.delegate = self
        txt_selectRetailerCategory.updateLengthValidationMsg(MessageAndError.selectRetailerCategory)
        
        txt_monthlybizz.delegate = self
        txt_monthlybizz.updateLengthValidationMsg(MessageAndError.enterBizz)


        
        setUpDesign()
        //MARK: DISTRIBUTOR TABLE CODE :RB
        
        DistributerTableView.register(UINib(nibName: "FstDistributorTableViewCell", bundle: nil), forCellReuseIdentifier: "FstDistributorTableViewCell")
        secDistributerTableView.register(UINib(nibName: "SecDisTableViewCell", bundle: nil), forCellReuseIdentifier: "SecDisTableViewCell")
        thirdDistributerTableView.register(UINib(nibName: "ThirdDisTableViewCell", bundle: nil), forCellReuseIdentifier: "ThirdDisTableViewCell")
        forthDistributerTableView.register(UINib(nibName: "ForthDisTableViewCell", bundle: nil), forCellReuseIdentifier: "ForthDisTableViewCell")
        fifthDistributerTableView.register(UINib(nibName: "fifthDisTableViewCell", bundle: nil), forCellReuseIdentifier: "fifthDisTableViewCell")
        sixDistributerTableView.register(UINib(nibName: "SixDisTableViewCell", bundle: nil), forCellReuseIdentifier: "SixDisTableViewCell")
        sevenDistributerTableView.register(UINib(nibName: "SevenDisTableViewCell", bundle: nil), forCellReuseIdentifier: "SevenDisTableViewCell")
        eightDistributerTableView.register(UINib(nibName: "EightDisTableViewCell", bundle: nil), forCellReuseIdentifier: "EightDisTableViewCell")
        nineDistributerTableView.register(UINib(nibName: "NineDisTableViewCell", bundle: nil), forCellReuseIdentifier: "NineDisTableViewCell")
        
        self.DistributerTableView.separatorStyle = .none
        self.secDistributerTableView.separatorStyle = .none
        self.thirdDistributerTableView.separatorStyle = .none
        self.forthDistributerTableView.separatorStyle = .none
        self.fifthDistributerTableView.separatorStyle = .none
        self.sixDistributerTableView.separatorStyle = .none
        self.sevenDistributerTableView.separatorStyle = .none
        self.eightDistributerTableView.separatorStyle = .none
        self.nineDistributerTableView.separatorStyle = .none


        let FstDropDown = UITapGestureRecognizer(target: self, action: #selector(firstDistributorDropDown))
        FstDropDown.delegate = self
        DistributerTableView.addGestureRecognizer(FstDropDown)
        
        let SecDropDown = UITapGestureRecognizer(target: self, action: #selector(secDistributorDropDown))
        SecDropDown.delegate = self
        secDistributerTableView.addGestureRecognizer(SecDropDown)
        
        let ThirdDropDown = UITapGestureRecognizer(target: self, action: #selector(thirdDistributorDropDown))
        ThirdDropDown.delegate = self
        thirdDistributerTableView.addGestureRecognizer(ThirdDropDown)
        
        let ForthDropDown = UITapGestureRecognizer(target: self, action: #selector(forthDistributorDropDown))
        ForthDropDown.delegate = self
        forthDistributerTableView.addGestureRecognizer(ForthDropDown)
        
        let FifthDropDown = UITapGestureRecognizer(target: self, action: #selector(fifthDistributorDropDown))
        FifthDropDown.delegate = self
        fifthDistributerTableView.addGestureRecognizer(FifthDropDown)
        
        let SixDropDown = UITapGestureRecognizer(target: self, action: #selector(sixDistributorDropDown))
        SixDropDown.delegate = self
        sixDistributerTableView.addGestureRecognizer(SixDropDown)
        
        let SevenDropDown = UITapGestureRecognizer(target: self, action: #selector(sevenDistributorDropDown))
        SevenDropDown.delegate = self
        sevenDistributerTableView.addGestureRecognizer(SevenDropDown)
        
        let EightDropDown = UITapGestureRecognizer(target: self, action: #selector(eightDistributorDropDown))
        EightDropDown.delegate = self
        eightDistributerTableView.addGestureRecognizer(EightDropDown)
        
        let NineDropDown = UITapGestureRecognizer(target: self, action: #selector(nineDistributorDropDown))
        NineDropDown.delegate = self
        nineDistributerTableView.addGestureRecognizer(NineDropDown)
        
        //Class Drop Down:
        
        let fst_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(fst_Class_DropDown))
        fst_ClassDropDown.delegate = self
        fstClassDropDown.addGestureRecognizer(fst_ClassDropDown)
        
        let Sec_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(sec_Class_DropDown))
        Sec_ClassDropDown.delegate = self
        secClassDropDown.addGestureRecognizer(Sec_ClassDropDown)
        
        let Third_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(third_Class_DropDown))
        Third_ClassDropDown.delegate = self
        thirdClassDropDown.addGestureRecognizer(Third_ClassDropDown)
        
        let Forth_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(forth_Class_DropDown))
        Forth_ClassDropDown.delegate = self
        forthClassDropDown.addGestureRecognizer(Forth_ClassDropDown)
        
        let Fifth_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(fifth_Class_DropDown))
        Fifth_ClassDropDown.delegate = self
        fifthClassDropDown.addGestureRecognizer(Fifth_ClassDropDown)
        
        let Six_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(six_Class_DropDown))
        Six_ClassDropDown.delegate = self
        sixClassDropDown.addGestureRecognizer(Six_ClassDropDown)
        
        let Seven_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(seven_Class_DropDown))
        Seven_ClassDropDown.delegate = self
        sevenClassDropDown.addGestureRecognizer(Seven_ClassDropDown)
        
        let Eight_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(eight_Class_DropDown))
        Eight_ClassDropDown.delegate = self
        eightClassDropDown.addGestureRecognizer(Eight_ClassDropDown)
        
        let Nine_ClassDropDown = UITapGestureRecognizer(target: self, action: #selector(nine_Class_DropDown))
        Nine_ClassDropDown.delegate = self
        nineClassDropDown.addGestureRecognizer(Nine_ClassDropDown)
        
        //checkbox
        fstCheckbox.isEnabled = false
        secCheckbox.isEnabled = false
        thirdCheckbox.isEnabled = false
        forthCheckbox.isEnabled = false
        fifthCheckbox.isEnabled = false
        sixthCheckbox.isEnabled = false
        seventhCheckbox.isEnabled = false
        eighthCheckbox.isEnabled = false
        ninthCheckbox.isEnabled = false
        
        DistributerTableView.isUserInteractionEnabled = false
        secDistributerTableView.isUserInteractionEnabled = false
        thirdDistributerTableView.isUserInteractionEnabled = false
        forthDistributerTableView.isUserInteractionEnabled = false
        fifthDistributerTableView.isUserInteractionEnabled = false
        sixDistributerTableView.isUserInteractionEnabled = false
        sevenDistributerTableView.isUserInteractionEnabled = false
        eightDistributerTableView.isUserInteractionEnabled = false
        nineDistributerTableView.isUserInteractionEnabled = false
        
        
        fstCheckbox.boxType = .square
        secCheckbox.boxType = .square
        thirdCheckbox.boxType = .square
        forthCheckbox.boxType = .square
        fifthCheckbox.boxType = .square
        sixthCheckbox.boxType = .square
        seventhCheckbox.boxType = .square
        eighthCheckbox.boxType = .square
        ninthCheckbox.boxType = .square
        
        fstCheckbox.delegate = self
        secCheckbox.delegate = self
        thirdCheckbox.delegate = self
        forthCheckbox.delegate = self
        fifthCheckbox.delegate = self
        sixthCheckbox.delegate = self
        seventhCheckbox.delegate = self
        eighthCheckbox.delegate = self
        ninthCheckbox.delegate = self
    }
    
    func setUpDesign(){
        
        btn_edit.layer.cornerRadius = 17
        btn_edit.layer.masksToBounds = true
        
        btn_submit.layer.cornerRadius = 21
        btn_submit.layer.masksToBounds = true
        
//        view_KamDetails.layer.cornerRadius = 10
//        view_KamDetails.layer.borderWidth = 0.8
//        view_KamDetails.layer.borderColor = UIColor.lightGray.cgColor
        
        btn_gstImage.layer.cornerRadius = 8
        btn_gstImage.layer.masksToBounds = true
        
        btn_panImage.layer.cornerRadius = 8
        btn_panImage.layer.masksToBounds = true
        
        btn_ownerImage.layer.cornerRadius = 8
        btn_ownerImage.layer.masksToBounds = true
        
        btn_otherImage.layer.cornerRadius = 8
        btn_otherImage.layer.masksToBounds = true
        
        btn_aadherImage.layer.cornerRadius = 8
        btn_aadherImage.layer.masksToBounds = true
        
        btn_shopImage.layer.cornerRadius = 8
        btn_shopImage.layer.masksToBounds = true
        
        view_ownerImage.layer.borderColor = UIColor.lightGray.cgColor
        view_ownerImage.layer.borderWidth = 0.8
        view_ownerImage.layer.cornerRadius = 8
        
        view_gstImage.layer.borderColor = UIColor.lightGray.cgColor
        view_gstImage.layer.borderWidth = 0.8
        view_gstImage.layer.cornerRadius = 8
        
        view_panImage.layer.borderColor = UIColor.lightGray.cgColor
        view_panImage.layer.borderWidth = 0.8
        view_panImage.layer.cornerRadius = 8

        view_otherImage.layer.borderColor = UIColor.lightGray.cgColor
        view_otherImage.layer.borderWidth = 0.8
        view_otherImage.layer.cornerRadius = 8

        
        view_shopImage.layer.borderColor = UIColor.lightGray.cgColor
        view_shopImage.layer.borderWidth = 0.8
        view_shopImage.layer.cornerRadius = 8

        view_aadharImage.layer.borderColor = UIColor.lightGray.cgColor
        view_aadharImage.layer.borderWidth = 0.8
        view_aadharImage.layer.cornerRadius = 8
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
       // LanguageChanged(strLan:keyLang)
        super.viewWillAppear(true)
        setUpStautusBar()
    }
    
    override func setUpStautusBar(){
                     
                          if #available(iOS 13.0, *) {
                              let app = UIApplication.shared
                              let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                              
                              let statusbarView = UIView()
                              statusbarView.backgroundColor = UIColor.black
                              view.addSubview(statusbarView)
                            
                              statusbarView.translatesAutoresizingMaskIntoConstraints = false
                              statusbarView.heightAnchor
                                  .constraint(equalToConstant: statusBarHeight).isActive = true
                              statusbarView.widthAnchor
                                  .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                              statusbarView.topAnchor
                                  .constraint(equalTo: view.topAnchor).isActive = true
                              statusbarView.centerXAnchor
                                  .constraint(equalTo: view.centerXAnchor).isActive = true
                            
                          } else {
                              let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                              statusBar?.backgroundColor = UIColor.black
                          }
                     
                 }
    
    
    
    func LanguageChanged(strLan:String){
        lbl_firmtype.text = "FIRM TYPE".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_FirmName.text = "FIRM NAME".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_OwnerName.text = "OWNER NAME".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_mobileNo.text = "MOBILE NO".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_address1.text = "ADDRESS 1".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_address2.text = "ADDRESS 2".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_state.text = "STATE".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_distric.text = "DISTRICT".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_city.text = "CITY".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_area.text = "AREA".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_pincode.text = "PINCODE".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_branchname.text = "BRANCH NAME".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_email.text = "EMAIL".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_aadhar.text = "AADHAR NO".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_gsttype.text = "GST TYPE".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_gstNo.text = "GST NO".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_userstatus.text = "USER STATUS".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_userSubType.text = "USER SUB TYPE".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_CurrentStatus.text = "CURRENT STATUS".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_lastActionDate.text = "LAST ACTION DATE".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_regDate.text = "REG DATE".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_pan.text = "PAN NO".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        profileUnderEditLabel.text = "Profile Under Edit".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        btn_edit.setTitle("EDIT".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
    }
    
    @objc func handleTap(){
        vieew.isHidden = true
        imgVw.isHidden = true
        // img_aadharImage.isHidden = true
    }
    
    @objc func kAMNoCall(){
        
        callNumber(phoneNumber: profile.KAMMobileNo!)
        
    }
    
    @objc func btnBackPressed(_ sender: UIButton){
        if isRgistration
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton)
    {
        if isRgistration
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func onBellButtonPressed(_ sender : UIButton)
    {
        exitNotification()
        if (!(self.navigationController?.topViewController is NotificationViewController))
        {
            let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    override func onHomeButtonPressed(_ sender: UIButton) {
        exitAlert()
    }
    
    func exitNotification()
    {
        let alert = UIAlertController(title: appName, message: "doYouWantExit".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.YESPRESSED)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.noPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func exitAlert()
    {
        let alert = UIAlertController(title: appName, message: "doYouWantExit".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.yesPressed)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.noPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yesPressed(alert: UIAlertAction!)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func YESPRESSED(alert: UIAlertAction!)
    {
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func noPressed(alert: UIAlertAction!)
    {
        
    }
    func textfiled(enable:Bool)
    {
        
        txt_selectFirmType.textColor = UIColor.gray
        txt_selectFirmType.isEnabled = enable
        txt_selectRetailerType.isEnabled = enable
        txt_selectRetailerCategory.isEnabled = enable
        txt_monthlybizz.isEnabled = enable
        btn_selectFirmType.isEnabled = enable
        //        userTypeTextField.isEnabled = false
        LasrActionTextField.isEnabled = false
        LasrActionTextField.textColor = .gray
        userStatusTextField.isEnabled = false
        userStatusTextField.textColor = .gray
//        hevellsIdTextField.isEnabled = false
//        hevellsIdTextField.textColor = .gray
        userSubtypeTextField.isEnabled = false
        userSubtypeTextField.textColor = .gray
        registrationTextField.isEnabled = false
        registrationTextField.textColor = .gray
        registrationdateTextField.isEnabled = false
        registrationdateTextField.textColor = .gray
        txt_firmName.isEnabled = enable
        txt_ownerName.isEnabled = enable
        txt_ownerMobileNumber.isEnabled = true
        txt_ownerMobileNumber.textColor = .gray
        txt_address.isEnabled = enable
        txt_selectState.isEnabled = enable
        btn_selectState.isEnabled = enable
        txt_selectDistrict.isEnabled = enable
        btn_selectDistrict.isEnabled = enable
        txt_selectCity.isEnabled = enable
        btn_selectCity.isEnabled = enable
        txt_selectArea.isEnabled = enable
        btn_selectArea.isEnabled = enable
        txt_pincode.isEnabled = enable
        txt_selectBranchName.isEnabled = enable
        btn_selectBranchName.isEnabled = enable
        txt_email.isEnabled = enable
        //        txt_sapCode.isEnabled = false
        txt_aadherNo.isEnabled = enable
        txt_selectGSTType.isEnabled = enable
        btn_selectGSTType.isEnabled = enable
        txt_gstNo.isEnabled = enable
        txt_gstNo.isEnabled = enable
        address1TextField.isEnabled = enable
        tblView.isUserInteractionEnabled = enable
        
        
        
        if isProfileEditing {
            if txt_gstNo.hasText {
                txt_panNo.isEnabled = false
                txt_panNo.textColor = .gray
                
                if txt_selectGSTType.text == "SELECT GST TYPE"  {
                    
                    txt_gstNo.text = ""
                    
                }
            } else {
                txt_panNo.isEnabled = true
                txt_panNo.textColor = .black
            }
            
        } else {
            //txt_panNo.isEnabled = false
            //txt_panNo.textColor = .gray
        }
        
        
        txt_selectParentChildStatus.isEnabled = enable
        btn_selectParentChildStatus.isEnabled = enable
        txt_parentMobileNo.isEnabled = enable
        btn_ownerImage.isEnabled = enable
        btn_aadherImage.isEnabled = enable
        btn_panImage.isEnabled = enable
        btn_gstImage.isEnabled = enable
        btn_shopImage.isEnabled = enable
        btn_otherImage.isEnabled = enable
        
        if enable
        {
            btn_selectFirmType_width.constant = 40
            btn_selectState_width.constant = 40
            btn_selectDistrict_width.constant = 40
            btn_selectCity_width.constant = 40
            btn_selectArea_width.constant = 40
            btn_selectBranchName_width.constant = 0
            btn_selectGSTType_width.constant = 40
            btn_selectParentChildStatus_width.constant = 40
            btn_pincode_width.constant = 40
            btn_PinRefresh_width.constant = 40
        }
        else
        {
            btn_selectFirmType_width.constant = 0
            btn_selectState_width.constant = 0
            btn_selectDistrict_width.constant = 0
            btn_selectCity_width.constant = 0
            btn_selectArea_width.constant = 0
            btn_selectBranchName_width.constant = 0
            btn_selectGSTType_width.constant = 0
            btn_selectParentChildStatus_width.constant = 0
            btn_pincode_width.constant = 0
            btn_PinRefresh_width.constant = 0
            
        }
    }
    
    func getData()
    {
        var parameters:Parameters = [:]
        var callApi = ""
        if(callAction == ActionType.FrmType)
        {
            callApi = API.GetUserDrpCode
            parameters = [Key.ActionTypes: callAction]
        }
        else if(callAction == ActionType.ProductProfile)
        {
            callApi = API.GetUserDrpCode
            parameters = [Key.ActionTypes: callAction]
        }
            else if(callAction == ActionType.RetailerType)
            {
                callApi = API.GetUserRetailerType
                parameters = [Key.ActionTypes: callAction]
                print("parameters:\(parameters)")
            }
            else if(callAction == ActionType.RetailerCategory)
            {
                callApi = API.GetUserRetailerCategory
                parameters = [Key.ActionTypes: callAction, "UserTypeCode": retailerCategory]
                print("parameters:\(parameters)")
            }
        else if(callAction == ActionType.State)
        {
            callApi = API.GetUserDropdownCode
            parameters = [Key.ActionTypes: callAction]
        }
        else if(callAction == ActionType.DistrictByStateCode)
        {
            callApi = API.GetUserDropdownCode
            parameters = [Key.ActionTypes: callAction, Key.State: area.stateCode!]
        }
        else if(callAction == ActionType.CityByDistrict)
        {
            callApi = API.GetUserDropdownCode
            parameters = [Key.ActionTypes: callAction, Key.District: area.districtCode!]
        }
        else if(callAction == ActionType.AreaByCity)
        {
            callApi = API.GetUserDropdownCode
            parameters = [Key.ActionTypes: callAction, Key.City: area.cityCode!]
        }
        else if (callAction == ActionType.GetOtherDetailsByArea)
        {
            callApi = API.GetOtherDetailsByArea
            parameters = [Key.ActionTypes: callAction, Key.State: area.stateCode!, Key.District: area.districtCode!, Key.City: area.cityCode!, Key.Area: area.areaCode!]
        }
        else if(callAction == ActionType.DetailsByPinNo)
        {
            callApi = API.GetAllDetailsByPindoc
            parameters = [Key.Pincode: self.profilrPincode]
        }
        else if (callAction == ActionType.MobileNo) || (callAction == ActionType.AdharNo) || (callAction == ActionType.PanNo) || (callAction == ActionType.GstNo)
        {
            callApi = API.ChkAllDuplicate
            parameters = [Key.CheckType: callAction, Key.DuplicateNo: DuplicateNo, Key.UserCode: usercode]
        }
        else if callAction == ActionType.Edit
        {
            callApi = API.EditUserRegistration
            parameters = [Key.ActionTypes: callAction, Key.UserCode: usercode]
            print(parameters)
        }
        else if callAction == ActionType.Insert || callAction == ActionType.EditUser
        {
            let prodObj = appDelegate.arr_productProfile
            let jsonEncoder = JSONEncoder()
            print(prodObj)
            do{
                let jsonData = try jsonEncoder.encode(prodObj)
                if let json = String(data: jsonData, encoding: String.Encoding.utf8){
                    productString = json
                    print("jsonString is: \(json) ")
                    
                    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                           print(jsonArray) // use the json here
                        productArray = jsonArray
                            
                        } else {
                            print("bad json")
                        }
                    
                    

                }
            }catch {
                print("Decoder Error \(error.localizedDescription)")
            }
            
//            if txt_selectRetailerType.text == "GENERAL TRADE(GT)"{
//                retailerTypeString = "UTC0161"
//            }else if txt_selectRetailerType.text == "OTHERS"{
//               retailerTypeString = "UTC0166"
//            }
            
            
            
            callApi = API.InsertUpdateUserRegistration
//            callApi = ""


            parameters = [Key.ActionTypes: callAction,
                          Key.SectionName: "Registration",
                          Key.UserTypeCode: UserType_UTC0002,
                          Key.UserType: "User",
//                         Key.UserSubType:profile.s_UserSubTypeCode ?? "",
                          Key.FirmName: txt_firmName.text!,
//                          Key.FirmCode: firm.code ?? "",
                          Key.MobileNo: txt_ownerMobileNumber.text!,
                          Key.FullName: txt_ownerName.text!,
                          Key.EmailId: txt_email.text!,
//                          Key.GSTOption: txt_selectGSTType.text!,
                          Key.GSTNo: txt_gstNo.text!,
//                          Key.ParentChildStatus: txt_selectParentChildStatus.text!,
//                          Key.ParentMobileNo: txt_parentMobileNo.text!,
//                          Key.ShopImage: "",
                          Key.ShopAddress1: address1TextField.text!,
                          Key.ShopAddress2: "",
                          Key.ShopAddress3: "",
                          Key.State:txt_selectState.text!,
                          Key.District:txt_selectDistrict.text!,
                          Key.City:txt_selectCity.text!,
                          Key.Area: area.areaCode!,
                          Key.Pincode: txt_pincode.text!,
//                          Key.RegionName: areaByPincode.regionName!,
//                          Key.ShopGEOId: "",
                          Key.ForwordTo: "Branch",
                          Key.Status: "InActive",
                          Key.UserCurrentStatus: "Branch",
                          Key.IsActive: 0,
                          Key.CreatedSource: Source,
                          Key.CreatedBy: txt_ownerMobileNumber.text!,
//                          Key.UserDocCode: "",
                          Key.files: files,
                          //Key.WeeklyOff: 0,
                          Key.Productprofiledetail: dropdownJson,
                          Key.UserSubType: retailerTypeString,
                          Key.UserCategoryCode: retailerCategoryCode]
            print(dropdownJson)
            print("Parameters are:\(parameters)")

//            print("JSON Parameters are: \(JSON(parameters))")
            
            
            
            if(!isRgistration)
            {
                parameters[Key.UserCode] = profile.s_UserCode!
                parameters[Key.UserTypeCode] = profile.s_UserTypeCode!
                parameters[Key.SectionName] = "Edit User"
                parameters[Key.ForwordTo] =  "EditBranch"
                parameters[Key.Status] = "Active"
                parameters[Key.UserCurrentStatus] = "EditBranch"
            }
            
            print("Product Profile Array : \(appDelegate.arr_productProfile)")
        }
        
//        print("Parameters are:\(parameters)")
        
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: callApi, parameters: parameters, viewcontroller: self, actionType: callAction)
        print(parameters)
    }
    
    func setupDropDown()
    {
        selectDropDown.dismissMode = .automatic
        selectDropDown.separatorColor = .lightGray
        //selectDropDown.width = view_selectDivision.frame.width
        selectDropDown.bottomOffset = CGPoint(x: 0, y: txt_selectRetailerType.bounds.height)
        selectDropDown.direction = .bottom
        selectDropDown.cellHeight = 40
        selectDropDown.backgroundColor = .white
        // Action triggered on selection
        selectDropDown.selectionAction = { [self](index, item) in
            self.txt_responder!.text = item
            if(self.txt_responder == self.txt_selectState)
            {
                if let name = self.arr_State[index].name,
                    let code = self.arr_State[index].code
                {
                    self.area.stateName = name
                    self.area.stateCode = code
                    //                    self.state = self.arr_State[index]
                    self.txt_selectDistrict.text = ""
                    self.arr_District = []
                    self.txt_selectCity.text = ""
                    self.arr_City = []
                    self.txt_selectArea.text = ""
                    self.arr_Area = []
                    self.profilrPincode = ""
                    self.txt_pincode.text = ""
                    self.arr_PinCode = []
                    
                    self.area.districtName = ""
                    self.area.districtCode = ""
                    self.area.cityName = ""
                    self.area.cityCode = ""
                    self.area.areaName = ""
                    self.area.areaCode = ""
                }
                else
                {
                    self.showAlert(msg: "STATE NOT FOUND")
                }
            }
            else if(self.txt_responder == self.txt_selectDistrict)
            {
                if let name = self.arr_District[index].name,
                    let code = self.arr_District[index].code
                {
                    self.area.districtName = name
                    self.area.districtCode = code
                    //self.district = self.arr_District[index]
                    self.txt_selectCity.text = ""
                    self.arr_City = []
                    self.txt_selectArea.text = ""
                    self.arr_Area = []
                    self.profilrPincode = ""
                    self.txt_pincode.text = ""
                    //self.arr_AreaByPincode = []
                    self.arr_PinCode = []
                }
                else
                {
                    self.showAlert(msg: "DISTRICT NOT FOUND")
                }
            }
            else if(self.txt_responder == self.txt_selectCity)
            {
                if let name = self.arr_City[index].name,
                    let code = self.arr_City[index].code
                {
                    self.area.cityName = name
                    self.area.cityCode = code
                    
                    //                    if  (self.arr_AreaByPincode.count > 0) && (self.arr_AreaByPincode.contains{$0.cityName! == name})
                    //                    {
                    self.txt_selectArea.text = ""
                    self.arr_Area = []
                    self.profilrPincode = ""
                    self.txt_pincode.text = ""
                    //self.arr_AreaByPincode = []
                    self.arr_PinCode = []
                    //                    }
                }
                else
                {
                    self.showAlert(msg: "CITY NOT FOUND")
                }
            }
            else if(self.txt_responder == self.txt_selectArea)
            {
                //                if(self.profilrPincode != "" && self.arr_AreaByPincode.count > 0)
                //                {
                //                    if let name = self.arr_AreaByPincode[index].areaName,
                //                       let code = self.arr_AreaByPincode[index].areaCode
                //                    {
                //                        self.area.areaName = name
                //                        self.area.areaCode = code
                //
                ////                        if  (self.arr_AreaByPincode.count > 0) && (self.arr_AreaByPincode.contains{$0.cityName! == name})
                ////                        {
                //                            self.txt_pincode.text = ""
                //                            self.arr_AreaByPincode = []
                //                            self.profilrPincode = ""
                //                            self.arr_PinCode = []
                ////                        }
                //
                ////                        self.arr_PinCode = []
                ////                        self.profilrPincode = ""
                //
                //                    }
                //                    else
                //                    {
                //                        self.showAlert(msg: "AREA NOT FOUND")
                //                    }
                //                }
                //                else
                //                {
                if  let name = self.arr_Area[index].name,
                    let code = self.arr_Area[index].code
                {
                    self.area.areaName = name
                    self.area.areaCode = code
                    
                    self.txt_pincode.text = ""
                    //self.arr_AreaByPincode = []
                    self.arr_PinCode = []
                    self.profilrPincode = ""
                    
                }
                else
                {
                    self.showAlert(msg: "AREA NOT FOUND")
                }
                self.callAction = ActionType.GetOtherDetailsByArea
                self.getData()
            }
            else if(self.txt_responder == self.txt_selectGSTType)
            {
                if self.txt_selectGSTType.text == "SELECT GST TYPE"{
                    self.txt_gstNo.text = ""
                    self.txt_gstNo.isEnabled = false

                    self.txt_panNo.isEnabled = true
                    self.txt_panNo.textColor = UIColor.black
                }else{
                    self.txt_gstNo.isEnabled = true

                }
            }
            else if(self.txt_responder == self.txt_selectFirmType)
            {
                if  let name = self.arr_FirmCode[index].name,
                    let code = self.arr_FirmCode[index].code
                {
                    self.firm.name = name
                    self.firm.code = code
                }
                else
                {
                    self.showAlert(msg: "FIRM NOT FOUND")
                }
            }
                else if(self.txt_responder == self.txt_selectRetailerType)
                {
                    if  let name = self.arr_RetailerType[index].name,
                        let code = self.arr_RetailerType[index].code
                        
                    {
                        self.retailerTypeString = code
                        retailerCategory = self.retailerTypeString
                        print("retailerTypeString:\(self.retailerTypeString)")
                    }
                    else
                    {
                        self.showAlert(msg: "FIRM NOT FOUND")
                    }
                }
                else if(self.txt_responder == self.txt_selectRetailerCategory)
                {
                    if  let name = self.arr_RetailerCategory[index].name,
                        let code = self.arr_RetailerCategory[index].code
                        
                    {
                        self.retailerCategoryCode = code
                        selectedRetailerCategory = self.retailerCategoryCode
                        print("selectedRetailerCategory:\(self.retailerCategoryCode)")
                    }
                    else
                    {
                        self.showAlert(msg: "FIRM NOT FOUND")
                    }
                }
            else if self.txt_responder == self.txt_pincode {
                
                let pincodeBranch = self.arr_PinCode[index]
                self.area.pinCode = pincodeBranch.s_PinCode!
                self.area.branchName = pincodeBranch.s_BranchName!
                self.area.branchCode = pincodeBranch.s_BranchCode!
                self.area.regionCode = pincodeBranch.s_RegionCode!
                self.area.regionName = pincodeBranch.s_RegionName!
                self.area.salesOfficeCode = pincodeBranch.s_SalesOfficeCode!
                self.area.salesOfficeName = pincodeBranch.s_SalesOfficeName!
                self.txt_pincode.text = pincodeBranch.s_PinCode
                self.txt_selectBranchName.text = pincodeBranch.s_BranchName!
                
                
            }
                
            else if(self.txt_responder == self.txt_selectParentChildStatus)
            {
                if item == "PARENT"
                {
                    if self.txt_ownerMobileNumber.validate()
                    {
                        self.txt_parentMobileNo.text = self.txt_ownerMobileNumber.text!
                    }
                    else
                    {
                        self.showAlert(msg: self.txt_ownerMobileNumber.strMsg)
                    }
                }
            }
        }
    }
    
    var tempData : Bool = true
    var tempArray = [String]()

    
    
    
    func showFrmType()
    {
        if tempData{
            tempArray = arr_FirmCode.map{$0.name} as! [String]
            tempData = false
        }
        selectDropDown.dataSource = tempArray//arr_FirmCode.map{$0.name} as! [String]
        selectDropDown.anchorView = txt_selectFirmType
//        print(txt_selectFirmType.text)
        selectDropDown.show()
    }
    
    func showState()
    {
        selectDropDown.dataSource = arr_State.map{$0.name} as! [String]
        selectDropDown.anchorView = txt_selectState
        selectDropDown.show()
    }
    
    func showRetailer()
    {
        print("Retailer Type array:\(arr_RetailerType.map{$0.name} as! [String])")
        selectDropDown.dataSource =  arr_RetailerType.map{$0.name} as! [String]//["GENERAL TRADE(GT)","OTHERS"]
        selectDropDown.anchorView = txt_selectRetailerType
        selectDropDown.show()
    }
    func showRetailerCategory(){
        print("Retailer Category array:\(arr_RetailerCategory.map{$0.name} as! [String])")
        selectDropDown.dataSource = arr_RetailerCategory.map{$0.name} as! [String]
        selectDropDown.anchorView = txt_selectRetailerCategory
        selectDropDown.show()
        
    }
    func showDistrict()
    {
        selectDropDown.dataSource = arr_District.map{$0.name} as! [String]
        selectDropDown.anchorView = txt_selectDistrict
        selectDropDown.show()
    }
    
    func showCity()
    {
        selectDropDown.dataSource = arr_City.map{$0.name} as! [String]
        selectDropDown.anchorView = txt_selectCity
        selectDropDown.show()
    }
    
    func showArea()
    {
        var dataSource = [String]()
        //        if(self.profilrPincode != "" && arr_AreaByPincode.count > 0)
        //        {
        //            dataSource = arr_AreaByPincode.map{$0.areaName!}
        //        }
        //        else
        //        {
        dataSource = arr_Area.map{$0.name!}
        //        }
        selectDropDown.dataSource = dataSource
        selectDropDown.anchorView = txt_selectArea
        selectDropDown.show()
    }
    
    func showPinCode()
    {
        txt_responder = txt_pincode
        selectDropDown.anchorView = txt_pincode
        selectDropDown.dismissMode = .automatic
        var dataSource = [String]()
        dataSource = arr_PinCode.map{$0.s_PinCode} as! [String]
        print("PINCODE NUMBERS++++\(dataSource)")
        selectDropDown.dataSource = dataSource
        selectDropDown.show()
    }
    
    func showBranch()
    {
        var dataSource = [String]()
        if self.profilrPincode != ""
        {
            //            if (arr_AreaByPincode.count > 0)
            //            {
            //                dataSource = arr_AreaByPincode.map{$0.branchName!}
            //                selectDropDown.dataSource = dataSource
            //                selectDropDown.anchorView = txt_selectBranchName
            //                selectDropDown.show()
            //            }
            //            else
            //            {
            dataSource = arr_PinCode.map{$0.s_BranchName!}
            selectDropDown.dataSource = dataSource
            selectDropDown.anchorView = txt_selectBranchName
            selectDropDown.show()
            //            }
        }
    }
    
    @IBAction func btn_edit_pressed(_ sender: UIButton)
    {
        
        if isProfileEditing
        {
            
            isProfileEditing = false
            btn_edit.setTitle("EDIT", for: .normal)
            btn_edit.backgroundColor = UIColor.red
            //            if(validate())
            //            {
            //                callAction = ActionType.EditUser
            //                getData()
            //            }
            btn_submit.isHidden = true
            txt_selectFirmType.textColor = UIColor.black
            
            textfiled(enable: isProfileEditing)
            
            
        }
        else
        {
            //            isregis
            
            let alertController = UIAlertController(title: "", message: "edit_PROFILE".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: .alert)
            //We add buttons to the alert controller by creating UIAlertActions:
            let actionOk = UIAlertAction(title: "YES",
                                         style: .default, handler: self.onOkPressed11)
            
            //You can use a block here to handle a press on this button
            let actionCANCEL = UIAlertAction(title: "CANCEL",
                                             style: .cancel,
                                             handler: nil)
            
            alertController.addAction(actionOk)
            alertController.addAction(actionCANCEL)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    @objc func onOkPressed11(alert: UIAlertAction!)
    {
        
        self.isProfileEditing = true
        self.btn_edit.setTitle("CANCEL", for: .normal)
        self.btn_submit.isHidden = false
        self.btn_edit.backgroundColor = UIColor.gray
       
        zipCode = profile.PinCode!
        fstCheckbox.isEnabled = true
        secCheckbox.isEnabled = true
        thirdCheckbox.isEnabled = true
        forthCheckbox.isEnabled = true
        fifthCheckbox.isEnabled = true
        sixthCheckbox.isEnabled = true
        seventhCheckbox.isEnabled = true
        eighthCheckbox.isEnabled = true
        ninthCheckbox.isEnabled = true
        
        DistributerTableView.isUserInteractionEnabled = true
        secDistributerTableView.isUserInteractionEnabled = true
        thirdDistributerTableView.isUserInteractionEnabled = true
        forthDistributerTableView.isUserInteractionEnabled = true
        fifthDistributerTableView.isUserInteractionEnabled = true
        sixDistributerTableView.isUserInteractionEnabled = true
        sevenDistributerTableView.isUserInteractionEnabled = true
        eightDistributerTableView.isUserInteractionEnabled = true
        nineDistributerTableView.isUserInteractionEnabled = true
        
        textfiled(enable: isProfileEditing)
        
        
        
    }
    

    
    @IBAction func btn_selectFirmType_pressed(_ sender: UIButton)
    {
        _ = txt_selectFirmType.becomeFirstResponder()
    }
    
    @IBAction func btn_selectRetailerType_pressed(_ sender: UIButton) {
        _ = txt_selectRetailerType.becomeFirstResponder()
    }
    @IBAction func btn_selectRetailerCategory_pressed(_ sender: UIButton) {
        _ = txt_selectRetailerCategory.becomeFirstResponder()
    }
    
    
    @IBAction func btn_selectState_pressed(_ sender: UIButton)
    {
        _ = txt_selectState.becomeFirstResponder()
    }
    
    @IBAction func btn_selectDistrict_pressed(_ sender: UIButton)
    {
        _ = txt_selectDistrict.becomeFirstResponder()
    }
    
    @IBAction func btn_selectCity_pressed(_ sender: UIButton)
    {
        _ = txt_selectCity.becomeFirstResponder()
    }
    
    @IBAction func btn_selectArea_pressed(_ sender: UIButton)
    {
        _ = txt_selectArea.becomeFirstResponder()
    }
    
    @IBAction func btn_pincode_pressed(_ sender: UIButton)
    {
        _ = txt_pincode.becomeFirstResponder()
    }
    @IBAction func btn_refresh_pressed(_ sender: UIButton)
    {
        showPincodeEntering = true
//        _ = txt_pincode.becomeFirstResponder()
        txt_selectArea.text! = ""
        txt_selectCity.text! = ""
        txt_selectState.text! = ""
        txt_selectDistrict.text! = ""
        txt_pincode.text! = ""
        txt_selectBranchName.text! = ""
        
    }
   
    @IBAction func btn_selectBranchName_pressed(_ sender: UIButton)
    {
        _ = txt_selectBranchName.becomeFirstResponder()
    }
    
    @IBAction func btn_selectGSTType_pressed(_ sender: UIButton)
    {
        _ = txt_selectGSTType.becomeFirstResponder()
    }
    
    @IBAction func btn_selectParentChildStatus_pressed(_ sender: UIButton)
    {
        _ = txt_selectParentChildStatus.becomeFirstResponder()
    }
    
    @IBAction func btn_ownaerImage_pressed(_ sender: UIButton)
    {
        imageType = .UserProfileImage
        askToChangeImage()
    }
    
    @IBAction func btn_aadharImage_pressed(_ sender: UIButton)
    {
        if(txt_aadherNo.validate())
        {
            imageType = .AdharImage
            askToChangeImage()
        }
        else
        {
            showAlert(msg: txt_aadherNo.strMsg)
        }
    }
    
    @IBAction func btn_panImage_pressed(_ sender: UIButton)
    {
        if(txt_panNo.validate())
        {
            imageType = .PanImage
            askToChangeImage()
        }
        else
        {
            showAlert(msg: txt_panNo.strMsg)
        }
    }
    
    @IBAction func btn_GSTImage_pressed(_ sender: UIButton)
    {
        if(txt_gstNo.validate())
        {
            imageType = .GstImage
            
            askToChangeImage()
        }
        else
        {
            showAlert(msg: txt_gstNo.strMsg)
        }
    }
    
    @IBAction func btn_ShopImage_pressed(_ sender: UIButton)
    {
        imageType = .ShopImage
        askToChangeImage()
    }
    
    @IBAction func btn_OtherImage_pressed(_ sender: UIButton)
    {
        imageType = .OtherImage
        askToChangeImage()
    }
    
    @available(iOS 13.0, *)
    @IBAction func btn_submit_pressed(_ sender: UIButton)
    {
        
        if(self.validate())
        {
            //self.showAlert(msg: "VALIDATION SUCCESS")
            
           // if txt_gstNo.text?.count != 0 && txt_pincode.text?.count != 0{

                let callApi = API.GetMDMGSTState

                let parameters = [Key.Pincode : self.txt_pincode.text!,Key.Area : area.areaCode!] as [String : Any]

                self.checkingDemo(api: callApi, parameters: parameters, viewcontroller: self)

           // }else{

                if(self.isRgistration)
                {
                    dataFst = api_data(Checked: "", CreatedBy: "", DealerCode: fstCode, DivisionCode: fstDiv, ProductName: fstDivName, SalesOfficeCode: "", UserCode: "", productCategory: fstClass)
                    allDropDownData.append(dataFst!)
                    dataSec = api_data(Checked: "", CreatedBy: "", DealerCode: secCode, DivisionCode: secDiv, ProductName: secDivName, SalesOfficeCode: "", UserCode: "", productCategory: secClass)
                    allDropDownData.append(dataSec!)
                    dataThree = api_data(Checked: "", CreatedBy: "", DealerCode: threeCode, DivisionCode: threeDiv, ProductName: threeDivName, SalesOfficeCode: "", UserCode: "", productCategory: threeClass)
                    allDropDownData.append(dataThree!)
                    dataFour = api_data(Checked: "", CreatedBy: "", DealerCode: fourCode, DivisionCode: fourDiv, ProductName: fourDivName, SalesOfficeCode: "", UserCode: "", productCategory: fourClass)
                    allDropDownData.append(dataFour!)
                    dataFive = api_data(Checked: "", CreatedBy: "", DealerCode: fiveCode, DivisionCode: fiveDiv, ProductName: fiveDivName, SalesOfficeCode: "", UserCode: "", productCategory: fiveClass)
                    allDropDownData.append(dataFive!)
                    dataSix = api_data(Checked: "", CreatedBy: "", DealerCode: sixCode, DivisionCode: sixDiv, ProductName: sixDivName, SalesOfficeCode: "", UserCode: "", productCategory: sixClass)
                    allDropDownData.append(dataSix!)
                    dataSeven = api_data(Checked: "", CreatedBy: "", DealerCode: sevenCode, DivisionCode: SevenDiv, ProductName: SevenDivName, SalesOfficeCode: "", UserCode: "", productCategory: SevenClass)
                    allDropDownData.append(dataSeven!)
                    dataEight = api_data(Checked: "", CreatedBy: "", DealerCode: eightCode, DivisionCode: EightDiv, ProductName: EightDivName, SalesOfficeCode: "", UserCode: "", productCategory: EightClass)
                    allDropDownData.append(dataEight!)
                    dataNine = api_data(Checked: "", CreatedBy: "", DealerCode: nineCode, DivisionCode: NineDiv, ProductName: NineDivName, SalesOfficeCode: "", UserCode: "", productCategory: NineClass)
                    allDropDownData.append(dataNine!)
                    print(allDropDownData)

                    let encoder = JSONEncoder()
                    //encoder.outputFormatting = .withoutEscapingSlashes

                    do {
                        let jsonData = try encoder.encode(allDropDownData)

                        if let jsonString = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "") {
                            print(jsonString)
                          //  dropdownJson = jsonString
                            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,Any>]
                                {
                                   print(jsonArray) // use the json here
                                dropdownJson = jsonArray
                                    
                                } else {
                                    print("bad json")
                                }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.callAction = ActionType.Insert
                }
                else
                {
                    dataFst = api_data(Checked: "", CreatedBy: "", DealerCode: fstCode, DivisionCode: fstDiv, ProductName: fstDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: fstClass)
                    allDropDownData.append(dataFst!)
                    dataSec = api_data(Checked: "", CreatedBy: "", DealerCode: secCode, DivisionCode: secDiv, ProductName: secDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: secClass)
                    allDropDownData.append(dataSec!)
                    dataThree = api_data(Checked: "", CreatedBy: "", DealerCode: threeCode, DivisionCode: threeDiv, ProductName: threeDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: threeClass)
                    allDropDownData.append(dataThree!)
                    dataFour = api_data(Checked: "", CreatedBy: "", DealerCode: fourCode, DivisionCode: fourDiv, ProductName: fourDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: fourClass)
                    allDropDownData.append(dataFour!)
                    dataFive = api_data(Checked: "", CreatedBy: "", DealerCode: fiveCode, DivisionCode: fiveDiv, ProductName: fiveDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: fiveClass)
                    allDropDownData.append(dataFive!)
                    dataSix = api_data(Checked: "", CreatedBy: "", DealerCode: sixCode, DivisionCode: sixDiv, ProductName: sixDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: sixClass)
                    allDropDownData.append(dataSix!)
                    dataSeven = api_data(Checked: "", CreatedBy: "", DealerCode: sevenCode, DivisionCode: SevenDiv, ProductName: SevenDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: SevenClass)
                    allDropDownData.append(dataSeven!)
                    dataEight = api_data(Checked: "", CreatedBy: "", DealerCode: eightCode, DivisionCode: EightDiv, ProductName: EightDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: EightClass)
                    allDropDownData.append(dataEight!)
                    dataNine = api_data(Checked: "", CreatedBy: "", DealerCode: nineCode, DivisionCode: NineDiv, ProductName: NineDivName, SalesOfficeCode: "", UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!, productCategory: NineClass)
                    allDropDownData.append(dataNine!)
                    print(allDropDownData)

                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .withoutEscapingSlashes

                    do {
                        let jsonData = try encoder.encode(allDropDownData)

                        if let jsonString = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "") {
                            print(jsonString)
                          //  dropdownJson = jsonString
                            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,Any>]
                                {
                                   print(jsonArray) // use the json here
                                dropdownJson = jsonArray
                                    
                                } else {
                                    print("bad json")
                                }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.callAction = ActionType.EditUser
                    self.btn_edit.isHidden = true
                    self.profileUnderEditLabel.isHidden = false
                    self.btn_edit_h.constant = 0
                    self.btn_edit_top.constant = 0

                }
            
           
            self.getData()
            
       // }
        }

    }
    
    
    func checkingDemo(api:String, parameters:Parameters, viewcontroller:UIViewController)
    {
        let url = baseUrl + api
        viewcontroller.view.makeToastActivity(message: "Processing...")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, parameters : parameters, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(url)\nRESPONSE : \(response)")
                
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                if swiftyJsonVar["Result"].stringValue == "Success"{
                    
                    let compareData = swiftyJsonVar["MdmGstStateCode"].stringValue
                    
                    if compareData != ""{
                        
                        if compareData == self.txt_gstNo.text!.prefix(2)
                        {
                            
                            if(self.isRgistration)
                            {
                                self.callAction = ActionType.Insert
                            }
                            else
                            {
                                self.callAction = ActionType.EditUser
                                self.btn_edit.isHidden = true
                                self.profileUnderEditLabel.isHidden = false
                                self.btn_edit_h.constant = 0
                                self.btn_edit_top.constant = 0
                                
                            }
                            
                            self.getData()
                            
                        }else{
                            viewcontroller.showAlert(msg: "Gst statecode and address statecode should be same ".uppercased())
                        }
                    }
                }
                
                
                //        switch response.result
                //                {
                //                case .success:
                //                    if let json = response.result.value as? [Any]
                //                    {
                //                        print(json)
                //f
                //                        //respoance delegate
                //                        //self.delegate?.didRecivedRespoance?(api: api, parser: self, json: json)
                //                    }
                //                    else
                //                    {
                //                        if let jsonString = response.result.value as? String
                //                        {
                //                            if let json = jsonString.parseJSONString
                //                            {
                //                                print(json)
                //
                //                                //self.parseRespoance(api: api, json: json, viewcontroller: viewcontroller, actionType: actionType)
                //                            }
                //                            else
                //                            {
                //                                viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                //                                    UserDefaults.standard.string(forKey: "keyLang")!))
                //                            }
                //                        }
                //                        else if let json = response.result.value as? [String:Any]
                //                        {
                //                            //self.parseRespoance(api: api, json: json, viewcontroller: viewcontroller, actionType: actionType)
                //                        }
                //                        else
                //                        {
                //                            viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                //                                UserDefaults.standard.string(forKey: "keyLang")!))
                //                        }
                //                        //respoance delegate
                //                        //self.delegate?.didRecivedRespoance?(api: api, parser: self, json: response.result.value!)
                //                    }
                //                    break
                //                case .failure(let error):
                //                    print(error)
                //                    switch (response.error!._code)
                //                    {
                //                    case NSURLErrorTimedOut:
                //                        viewcontroller.showAlert(msg: "server_is_Busy".localizableString(loc:
                //                            UserDefaults.standard.string(forKey: "keyLang")!))
                //                        break
                //                    case NSURLErrorNotConnectedToInternet:
                //                        viewcontroller.showAlert(msg: error.localizedDescription)
                //                        break
                //                    default:
                //                        viewcontroller.showAlert(msg: "serviceUnavailable".localizableString(loc:
                //                            UserDefaults.standard.string(forKey: "keyLang")!))
                //                    }
                //                }
                viewcontroller.view.hideToastActivity()
            }
        }
    }
    
    @IBAction func Close(_ sender: UIButton) {
        vieew.isHidden = true
        imgVw.isHidden = true
        img_aadharImage.isHidden = false
    }
    
    //MARK:- VALIDATION
    //MARK:-
    
    func validate() -> Bool
    {
        self.files.removeAll()
        self.arr_fileUploadToServer.removeAll()

//        if(!txt_selectFirmType.validate())
//        {
//            showAlert(msg: "selectFirmType".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//            return false
//        }
        
        if(!txt_selectRetailerType.validate())
        {
            showAlert(msg: "selectRetailerType".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
        else if !txt_selectRetailerCategory.validate()
        {
            showAlert(msg: "selectRetailerCategory".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
        else if !txt_firmName.validate()
        {
            showAlert(msg: txt_firmName.strMsg)
            return false
        }
        else if !txt_ownerName.validate()
        {
            showAlert(msg: txt_ownerName.strMsg)
            return false
        }
        else if !txt_ownerMobileNumber.validate()
        {
            showAlert(msg: txt_ownerMobileNumber.strMsg)
            return false
        }
            //        else if !txt_address.validate()
            //        {
            //            showAlert(msg: txt_address.strMsg)
            //            return false
            //        }
        else if !txt_selectState.validate()
        {
            showAlert(msg: "selectSate".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
        else if !txt_selectDistrict.validate()
        {
            showAlert(msg: "selectDistrict".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
        else if !txt_selectCity.validate()
        {
            showAlert(msg: "selectCity".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
        else if !txt_selectArea.validate()
        {
            showAlert(msg: "selectArea".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
        else if !txt_selectArea.validate()
        {
            showAlert(msg: "selectArea".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
        else if !txt_pincode.validate()
        {
            showAlert(msg: txt_pincode.strMsg)
            return false
        }
        else if !txt_selectBranchName.validate()
        {
            showAlert(msg: txt_selectBranchName.strMsg)
            return false
        }
        
        if txt_email.text != ""
        {
            if !txt_email.validate()
            {
                showAlert(msg: txt_email.strMsg)
                return false
            }
        }
        
        if txt_aadherNo.text != ""
        {
            if !txt_aadherNo.validate()
            {
                showAlert(msg: txt_aadherNo.strMsg)
                return false
            }
            
           else if (self.txt_aadherNo.text?.count != 12){
                
                showAlert(msg: "PLEASE ENTER 12 DIGIT AADHAR NO\(txt_aadherNo.text!)".uppercased())
                return false
            }
            
        }
        
        if txt_panNo.text != ""
        {
            if !txt_panNo.validate()
            {
                showAlert(msg: txt_panNo.strMsg)
                return false
            }

            if self.txt_panNo.text?.count != 10{

                showAlert(msg: "PLEASE ENTER 10 DIGIT PAN NO".uppercased())
                return false
            }
        }
        
        if txt_gstNo.text != ""
        {
            
            if self.txt_gstNo.text?.count != 15{
                
                showAlert(msg: "PLEASE ENTER 15 DIGIT GST NO".uppercased())
                return false
            }
        }
        

        
//        if (txt_selectFirmType.text == "Company") && (txt_panNo.text == "")
//        {
//            showAlert(msg: "PLEASE ENTER PAN NUMBER FOR FIRM TYPE \(txt_selectFirmType.text!)".uppercased())
//            return false
//        }
//        else if (txt_selectFirmType.text == "Company") && (txt_firmName.text == txt_ownerName.text){
//            showAlert(msg: "OWNER NAME AND FIRM NAME SHOULD NOT BE SAME FOR FIRM TYPE \(txt_selectFirmType.text!)".uppercased())
//            return false
//        }
//        if txt_aadherNo.text == "" || txt_panNo.text == ""
//        {
//            showAlert(msg: "PLEASE ENTER AADHER OR PAN NUMBER FOR FIRM TYPE \(txt_selectFirmType.text!)".uppercased())
//            return false
//        }
//        if (txt_selectFirmType.text == "Partnership/LLP") && (txt_panNo.text == "")
//        {
//            showAlert(msg: "PLEASE ENTER PAN NUMBER FOR FIRM TYPE \(txt_selectFirmType.text!)".uppercased())
//            return false
//        }
//
//        if (txt_selectFirmType.text == "Proprietor") && (txt_panNo.text == "") && (txt_gstNo.text == "") && (txt_aadherNo.text == "")
//        {
//            showAlert(msg: "PLEASE ENTER AADHAR NUMBER OR PAN NUMBER OR GST NUMBER  FOR FIRM TYPE \(txt_selectFirmType.text!)".uppercased())
//            return false
//        }
       
//        if txt_selectGSTType.text != "" && txt_selectGSTType.text != "SELECT GST TYPE" && !txt_gstNo.validate()
//        {
//            showAlert(msg: txt_gstNo.strMsg)
//            return false
//        }
        
//        if !txt_monthlybizz.validate()
//        {
//            showAlert(msg: txt_monthlybizz.strMsg)
//            return false
//        }
        
        
        
        
        
        //        if !txt_selectParentChildStatus.validate()
        //        {
        //            showAlert(msg: MessageAndError.selectParentChildStaus)
        //            return false
        //        }
        //        else if !txt_parentMobileNo.validate()
        //        {
        //            showAlert(msg: txt_parentMobileNo.strMsg)
        //            return false
        //        }
        
        //        if(isRgistration)
        //        {
        
        
        print(gstString)
        print(panString)
        print(aadharString)
       
        
        if let index = arr_fileUpload.index(where: {$0.fileName! == ImageType.UserProfileImage.rawValue}),
            arr_fileUpload[index].image != nil
        {
            let file = arr_fileUpload[index]
            let fileParameter = [Key.fileName: (file.fileName ?? "") + ".jpg",
                                 Key.documentName: file.documentName ?? "",
                                 Key.documentNo: file.documentNo ?? ""]
            files.append(fileParameter)
            arr_fileUploadToServer.append(file)
        }
        
//        else if(isRgistration)
//        {
//            showAlert(msg: "selectOwnerImage".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//            return false
//        }
        
        if let index = arr_fileUpload.index(where: {$0.fileName! == ImageType.ShopImage.rawValue}),
            arr_fileUpload[index].image != nil
        {
            let file = arr_fileUpload[index]
            let fileParameter = [Key.fileName: (file.fileName ?? "") + ".jpg",
            Key.documentName: file.documentName ?? "",
            Key.documentNo: file.documentNo ?? ""]
            files.append(fileParameter)
            arr_fileUploadToServer.append(file)

        }
        
//        else if(isRgistration)
//        {
//            showAlert(msg: "selectShopImage".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//            return false
//        }
        
        //MARK:- GST
        
        
        if let index = arr_fileUpload.index(where: {$0.fileName! == ImageType.GstImage.rawValue}),
            arr_fileUpload[index].image != nil,
            txt_gstNo.text != ""
        {
            let file = arr_fileUpload[index]
            let fileParameter = [Key.fileName: (file.fileName ?? "") + ".jpg",
                                 Key.documentName: file.documentName ?? "",
                                 Key.documentNo: self.txt_gstNo.text!] as [String : Any]
            files.append(fileParameter)
            arr_fileUploadToServer.append(file)

        }
        
//        else if(isRgistration)
//        {
//            showAlert(msg: "selectGstIamge".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//            return false
//        }

        //MARK:- AADHAAR
        
        if let index = arr_fileUpload.index(where: {$0.fileName! == ImageType.AdharImage.rawValue}),
            arr_fileUpload[index].image != nil,
            txt_aadherNo.text != ""
        {
            let file = arr_fileUpload[index]
            let fileParameter = [Key.fileName: (file.fileName ?? "") + ".jpg",
                                 Key.documentName: file.documentName ?? "",
                                 Key.documentNo:  self.txt_aadherNo.text!] as [String : Any]//file.documentNo!]
            files.append(fileParameter)
            arr_fileUploadToServer.append(file)

            
        }
        
//        else if(isRgistration)
//        {
//            showAlert(msg: "selectAadherImage".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//            return false
//        }

        
        //MARK:- PAN
        
        if let index = arr_fileUpload.index(where: {$0.fileName! == ImageType.PanImage.rawValue}),
            arr_fileUpload[index].image != nil,
            txt_panNo.text != ""
        {
            let file = arr_fileUpload[index]
            let fileParameter = [Key.fileName: (file.fileName ?? "") + ".jpg",
                                 Key.documentName: file.documentName ?? "",
                                 Key.documentNo: self.txt_panNo.text!] as [String : Any]//file.documentNo!]
            
            files.append(fileParameter)
            arr_fileUploadToServer.append(file)

        }
//        else if(isRgistration)
//        {
//            showAlert(msg: "selectPanImage".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//            return false
//        }
        
        
        //==========
        
     
       //---------WORKING
        if let index = arr_fileUpload.index(where: {$0.fileName! == ImageType.AdharImage.rawValue}),
            arr_fileUpload[index].image != nil,
            txt_aadherNo.text == ""
        {
            showAlert(msg:"AADHAR NUMBER IS COMPULSORY")
            return false
        }
        
        //---------WORKING
        
        if let index = arr_fileUpload.index(where: {$0.fileName! == ImageType.PanImage.rawValue}),
            arr_fileUpload[index].image != nil,
            txt_panNo.text == ""
        {
            showAlert(msg:"PAN NUMBER IS COMPULSORY")
            return false
        }
        
        if let index = arr_fileUpload.index(where: {$0.fileName! == ImageType.GstImage.rawValue}),
            arr_fileUpload[index].image != nil,
            txt_gstNo.text == ""
        {
            showAlert(msg:"GST NUMBER IS COMPULSORY")
            return false
        }
        
//        if (txt_selectFirmType.text == "Company") || (txt_selectFirmType.text == "Partnership/LLP")
//        {
//
//            if txt_panNo.text != "" && txt_gstNo.text != ""{
//
//            }else if panString == ""{
//                showAlert(msg:"PAN IMAGE IS COMPULSORY")
//                return false
//            }
//
//        }
//
//        if (txt_selectFirmType.text == "Proprietor") {
//            if txt_aadherNo.text != "" && aadharString == "" {
//                showAlert(msg: "selectAadherImage".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//                return false
//
//            }
//
//            if txt_panNo.text != "" && panString == ""{
//                showAlert(msg: "selectPanImage".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//                return false
//
//            }
//        }
        
        
         if txt_gstNo.text != ""{
            if gstString == ""{
            showAlert(msg:"GST IMAGE IS COMPULSORY")
            return false
        }
        }
        
        
        if txt_aadherNo.text != ""{
            if aadharString == ""{
                showAlert(msg:"AADHAAR IMAGE IS COMPULSORY")
                return false
            }
        }
        
      
        
         //=-=------==-
        
 
        return true
    }
//MARK: DISTRIBUTER TABLE DROPDOWN CODE:RB
    @objc func firstDistributorDropDown()  {
        FstDropDown.dataSource = fstListData//4
        FstDropDown.anchorView = DistributerTableView //5
        FstDropDown.bottomOffset = CGPoint(x: 0, y: DistributerTableView.frame.size.height) //6
        FstDropDown.show() //7
        FstDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = fst_check(name: item)
                self?.collection.append(data)
                print(data)
                if let object = self?.check.filter({ $0.name == item }).first {
                    print(self!.collection.contains)
                    print(self!.collection)
                    print("already available")
                } else {
                    var data = fst_collect(name: item)
                    if self!.items.count < 1{
                    self?.check.append(data)
                    self?.items.append(item)
                    print(self!.fstCodeListData[index])
                    self?.fstCode = self!.fstCodeListData[index]
                    }
                   // self?.fstCodes.append(self!.fstCodeListData[index])
                    print("not available:\(self!.items)")
                //    print(self!.fstCodes)
                   // item could not be found
                }
                self?.DistributerTableView.reloadData()
            }
    }
    @objc func secDistributorDropDown()  {
        secDropDown.dataSource = secListData//4
        secDropDown.anchorView = secDistributerTableView //5
        secDropDown.bottomOffset = CGPoint(x: 0, y: secDistributerTableView.frame.size.height) //6
        secDropDown.show() //7
        secDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = sec_collect(name: item)
                self?.secCollection.append(data)
                print(data)
                if let object = self?.secCheck.filter({ $0.name == item }).first {
                    print("already available")
                } else {
                    var data = sec_check(name: item)
                    if self!.secItems.count < 1{
                    self?.secCheck.append(data)
                    self?.secItems.append(item)
                    self?.secCode =  self!.secCodeListData[index]
                    
                    }
                    //self?.secCodes.append(self!.secCodeListData[index])
                    //print(self!.secCodes)
                    print("not available:\(self!.secItems)")
                   // item could not be found
                }
                self?.secDistributerTableView.reloadData()
            }
    }
    @objc func thirdDistributorDropDown()  {
        thirdDropDown.dataSource = threeListData//4
        thirdDropDown.anchorView = thirdDistributerTableView //5
        thirdDropDown.bottomOffset = CGPoint(x: 0, y: thirdDistributerTableView.frame.size.height) //6
        thirdDropDown.show() //7
        thirdDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = third_collect(name: item)
                self?.thirdCollection.append(data)
                print(data)
                if let object = self?.thirdCheck.filter({ $0.name == item }).first {
                    print("already available")
                } else {
                    var data = third_check(name: item)
                    if self!.thirdItems.count < 1{
                    self?.thirdCheck.append(data)
                    self?.thirdItems.append(item)
                   // self?.thirdCodes.append(self!.threeCodeListData[index])
                    self?.threeCode =  self!.threeCodeListData[index]

                    }
                   // print(self!.thirdCodes)
                    print("not available:\(self!.thirdItems)")
                   // item could not be found
                }
                self?.thirdDistributerTableView.reloadData()
            }
    }
    @objc func forthDistributorDropDown()  {
        forthDropDown.dataSource = fourListData//4
        forthDropDown.anchorView = forthDistributerTableView //5
        forthDropDown.bottomOffset = CGPoint(x: 0, y: forthDistributerTableView.frame.size.height) //6
        forthDropDown.show() //7
        forthDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = forth_collect(name: item)
                self?.forthCollection.append(data)
                print(data)
                if let object = self?.forthCheck.filter({ $0.name == item }).first {
                    print("already available")
                } else {
                    var data = forth_check(name: item)
                    if self!.forthItems.count < 1{
                    self?.forthCheck.append(data)
                    self?.forthItems.append(item)
                   // self?.forthCodes.append(self!.fourCodeListData[index])
                        self?.fourCode =  self!.fourCodeListData[index]
                    }
                   // print(self!.forthCodes)
                    print("not available:\(self!.forthItems)")
                   // item could not be found
                }
                self?.forthDistributerTableView.reloadData()
            }
    }
    @objc func fifthDistributorDropDown()  {
        fifthDropDown.dataSource = fiveListData//4
        fifthDropDown.anchorView = fifthDistributerTableView //5
        fifthDropDown.bottomOffset = CGPoint(x: 0, y: fifthDistributerTableView.frame.size.height) //6
        fifthDropDown.show() //7
        fifthDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = fifth_collect(name: item)
                self?.fifthCollection.append(data)
                print(data)
                if let object = self?.fifthCheck.filter({ $0.name == item }).first {
                    print("already available")
                } else {
                    var data = fifth_check(name: item)
                    if self!.fifthItems.count < 1{
                    self?.fifthCheck.append(data)
                    self?.fifthItems.append(item)
                   // self?.fifthCodes.append(self!.fiveCodeListData[index])
                        self?.fiveCode =  self!.fiveCodeListData[index]

                    }
                  //  print(self!.fifthCodes)
                    print("not available:\(self!.fifthItems)")
                   // item could not be found
                }
                self?.fifthDistributerTableView.reloadData()
            }
    }
    @objc func sixDistributorDropDown()  {
        sixDropDown.dataSource = sixListData//4
        sixDropDown.anchorView = sixDistributerTableView //5
        sixDropDown.bottomOffset = CGPoint(x: 0, y: sixDistributerTableView.frame.size.height) //6
        sixDropDown.show() //7
        sixDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = six_collect(name: item)
                self?.sixCollection.append(data)
                print(data)
                if let object = self?.sixCheck.filter({ $0.name == item }).first {
                    print("already available")
                } else {
                    var data = six_check(name: item)
                    if self!.sixItems.count < 1{
                    self?.sixCheck.append(data)
                    self?.sixItems.append(item)
                    //self?.sixCodes.append(self!.sixCodeListData[index])
                        self?.sixCode =  self!.sixCodeListData[index]

                    }
                 //   print(self!.sixCodes)
                    print("not available:\(self!.sixItems)")
                   // item could not be found
                }
                self?.sixDistributerTableView.reloadData()
            }
    }
    @objc func sevenDistributorDropDown()  {
        sevenDropDown.dataSource = sevenListData//4
        sevenDropDown.anchorView = sevenDistributerTableView //5
        sevenDropDown.bottomOffset = CGPoint(x: 0, y: sevenDistributerTableView.frame.size.height) //6
        sevenDropDown.show() //7
        sevenDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = seven_collect(name: item)
                self?.sevenCollection.append(data)
                print(data)
                if let object = self?.sevenCheck.filter({ $0.name == item }).first {
                    print("already available")
                } else {
                    var data = seven_check(name: item)
                    if self!.sevenItems.count < 1{
                    self?.sevenCheck.append(data)
                    self?.sevenItems.append(item)
                    //self?.sevenCodes.append(self!.sevenCodeListData[index])
                        self?.sevenCode =  self!.sevenCodeListData[index]

                    }
                  //  print(self!.sevenCodes)
                    print("not available:\(self!.sevenItems)")
                   // item could not be found
                }
                self?.sevenDistributerTableView.reloadData()
            }
    }
    @objc func eightDistributorDropDown()  {
        eightDropDown.dataSource = eightListData//4
        eightDropDown.anchorView = eightDistributerTableView //5
        eightDropDown.bottomOffset = CGPoint(x: 0, y: eightDistributerTableView.frame.size.height) //6
        eightDropDown.show() //7
        eightDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = eight_collect(name: item)
                self?.eightCollection.append(data)
                print(data)
                if let object = self?.eightCheck.filter({ $0.name == item }).first {
                    print("already available")
                } else {
                    var data = eight_check(name: item)
                    if self!.eightItems.count < 1{
                    self?.eightCheck.append(data)
                    self?.eightItems.append(item)
                   // self?.eightCodes.append(self!.eightCodeListData[index])
                        self?.eightCode =  self!.eightCodeListData[index]

                    }
                  //  print(self!.eightCodes)
                    print("not available:\(self!.eightItems)")
                   // item could not be found
                }
                self?.eightDistributerTableView.reloadData()
            }
    }
    @objc func nineDistributorDropDown()  {
        nineDropDown.dataSource = nineListData//4
        eightDropDown.anchorView = nineDistributerTableView //5
        eightDropDown.bottomOffset = CGPoint(x: 0, y: nineDistributerTableView.frame.size.height) //6
        eightDropDown.show() //7
        eightDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
                var data = nine_collect(name: item)
                self?.nineCollection.append(data)
                print(data)
                if let object = self?.nineCheck.filter({ $0.name == item }).first {
                    print("already available")
                } else {
                    var data = nine_check(name: item)
                    if self!.nineItems.count < 1{
                    self?.nineCheck.append(data)
                    self?.nineItems.append(item)
                    //self?.nineCodes.append(self!.nineCodeListData[index])
                        self?.nineCode =  self!.nineCodeListData[index]

                    }
                 //   print(self!.nineCodes)
                    print("not available:\(self!.nineItems)")
                   // item could not be found
                }
                self?.nineDistributerTableView.reloadData()
            }
    }
    
    //MARK:Class dropdown functions
    
    @objc func fst_Class_DropDown()  {
        fstClass_DropDown.dataSource = ["A", "B", "C"]//4
        fstClass_DropDown.anchorView = fstClassDropDown //5
        fstClass_DropDown.bottomOffset = CGPoint(x: 0, y: fstClassDropDown.frame.size.height) //6
        fstClass_DropDown.show() //7
        fstClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            
            self?.fstClassLbl.text = item
            self!.fstClass = item
            }
    }
    @objc func sec_Class_DropDown()  {
        secClass_DropDown.dataSource = ["A", "B", "C"]//4
        secClass_DropDown.anchorView = secClassDropDown //5
        secClass_DropDown.bottomOffset = CGPoint(x: 0, y: secClassDropDown.frame.size.height) //6
        secClass_DropDown.show() //7
        secClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            self?.secClassLbl.text = item
            self!.secClass = item
            }
    }
    @objc func third_Class_DropDown()  {
        thirdClass_DropDown.dataSource = ["A", "B", "C"]//4
        thirdClass_DropDown.anchorView = thirdClassDropDown //5
        thirdClass_DropDown.bottomOffset = CGPoint(x: 0, y: thirdClassDropDown.frame.size.height) //6
        thirdClass_DropDown.show() //7
        thirdClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            self?.threeClassLbl.text = item
            self!.threeClass = item
            }
    }
    @objc func forth_Class_DropDown()  {
        forthClass_DropDown.dataSource = ["A", "B", "C"]//4
        forthClass_DropDown.anchorView = forthClassDropDown //5
        forthClass_DropDown.bottomOffset = CGPoint(x: 0, y: forthClassDropDown.frame.size.height) //6
        forthClass_DropDown.show() //7
        forthClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            self?.fourClassLbl.text = item
            self!.fourClass = item
            }
    }
    @objc func fifth_Class_DropDown()  {
        fifthClass_DropDown.dataSource = ["A", "B", "C"]//4
        fifthClass_DropDown.anchorView = fifthClassDropDown //5
        fifthClass_DropDown.bottomOffset = CGPoint(x: 0, y: fifthClassDropDown.frame.size.height) //6
        fifthClass_DropDown.show() //7
        fifthClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            self?.fiveClassLbl.text = item
            self!.fiveClass = item
            }
    }
    @objc func six_Class_DropDown()  {
        sixClass_DropDown.dataSource = ["A", "B", "C"]//4
        sixClass_DropDown.anchorView = sixClassDropDown //5
        sixClass_DropDown.bottomOffset = CGPoint(x: 0, y: sixClassDropDown.frame.size.height) //6
        sixClass_DropDown.show() //7
        sixClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            self?.sixClassLbl.text = item
            self!.sixClass = item
            }
    }
    @objc func seven_Class_DropDown()  {
        sevenClass_DropDown.dataSource = ["A", "B", "C"]//4
        sevenClass_DropDown.anchorView = sevenClassDropDown //5
        sevenClass_DropDown.bottomOffset = CGPoint(x: 0, y: sevenClassDropDown.frame.size.height) //6
        sevenClass_DropDown.show() //7
        sevenClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            self?.sevenClassLbl.text = item
            self!.SevenClass = item
            }
    }
    @objc func eight_Class_DropDown()  {
        eightClass_DropDown.dataSource = ["A", "B", "C"]//4
        eightClass_DropDown.anchorView = eightClassDropDown //5
        eightClass_DropDown.bottomOffset = CGPoint(x: 0, y: eightClassDropDown.frame.size.height) //6
        eightClass_DropDown.show() //7
        eightClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            self?.eightClassLbl.text = item
            self!.EightClass = item
            }
    }
    @objc func nine_Class_DropDown()  {
        nineClass_DropDown.dataSource = ["A", "B", "C"]
        nineClass_DropDown.anchorView = nineClassDropDown //5
        nineClass_DropDown.bottomOffset = CGPoint(x: 0, y: nineClassDropDown.frame.size.height) //6
        nineClass_DropDown.show() //7
        nineClass_DropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                print(item)
            self?.nineClassLbl.text = item
            self!.NineClass = item
            }
        
    }
    
    //Remove item
    @objc func removedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.DistributerTableView)
            let indexPath : IndexPath = self.DistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.items[indexPath.row]
              if let cell = DistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                check.remove(at: indexPath.row)
                //fstCodes.remove(at: indexPath.row)
                      if let index = items.index(of:item) {
                        items.remove(at: index)
                      }
                DistributerTableView.reloadData()
              }
    }
    
    @objc func secRemovedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.secDistributerTableView)
            let indexPath : IndexPath = self.secDistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.secItems[indexPath.row]
              if let cell = secDistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                secCheck.remove(at: indexPath.row)
                //secCodes.remove(at: indexPath.row)
                      if let index = secItems.index(of:item) {
                        secItems.remove(at: index)
                      }
                secDistributerTableView.reloadData()
              }
    }
    
    @objc func thirdRemovedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.thirdDistributerTableView)
            let indexPath : IndexPath = self.thirdDistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.thirdItems[indexPath.row]
              if let cell = thirdDistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                thirdCheck.remove(at: indexPath.row)
                //thirdCodes.remove(at: indexPath.row)
                      if let index = thirdItems.index(of:item) {
                        thirdItems.remove(at: index)
                      }
                thirdDistributerTableView.reloadData()
              }
    }
    
    @objc func forthRemovedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.forthDistributerTableView)
            let indexPath : IndexPath = self.forthDistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.forthItems[indexPath.row]
              if let cell = forthDistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                forthCheck.remove(at: indexPath.row)
                //forthCodes.remove(at: indexPath.row)
                      if let index = forthItems.index(of:item) {
                        forthItems.remove(at: index)
                      }
                forthDistributerTableView.reloadData()
              }
    }
    
    @objc func fifthRemovedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.fifthDistributerTableView)
            let indexPath : IndexPath = self.fifthDistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.fifthItems[indexPath.row]
              if let cell = fifthDistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                fifthCheck.remove(at: indexPath.row)
                //fifthCodes.remove(at: indexPath.row)
                      if let index = fifthItems.index(of:item) {
                        fifthItems.remove(at: index)
                      }
                fifthDistributerTableView.reloadData()
              }
    }
    
    @objc func sixRemovedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.sixDistributerTableView)
            let indexPath : IndexPath = self.sixDistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.sixItems[indexPath.row]
              if let cell = sixDistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                sixCheck.remove(at: indexPath.row)
               // sixCodes.remove(at: indexPath.row)
                      if let index = sixItems.index(of:item) {
                        sixItems.remove(at: index)
                      }
                sixDistributerTableView.reloadData()
              }
    }
    
    @objc func sevenRemovedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.sevenDistributerTableView)
            let indexPath : IndexPath = self.sevenDistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.sevenItems[indexPath.row]
              if let cell = sevenDistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                sevenCheck.remove(at: indexPath.row)
               // sevenCodes.remove(at: indexPath.row)
                      if let index = sevenItems.index(of:item) {
                        sevenItems.remove(at: index)
                      }
                sevenDistributerTableView.reloadData()
              }
    }
    
    @objc func eightRemovedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.eightDistributerTableView)
            let indexPath : IndexPath = self.eightDistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.eightItems[indexPath.row]
              if let cell = eightDistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                eightCheck.remove(at: indexPath.row)
               // eightCodes.remove(at: indexPath.row)
                      if let index = eightItems.index(of:item) {
                        eightItems.remove(at: index)
                      }
                eightDistributerTableView.reloadData()
              }
    }
    
    @objc func nineRemovedSelectedDistributorClicked(sender:UIButton){
            let buttonPosition : CGPoint = sender.convert(CGPoint.zero, to: self.nineDistributerTableView)
            let indexPath : IndexPath = self.nineDistributerTableView.indexPathForRow(at: buttonPosition)!
              let item = self.nineItems[indexPath.row]
              if let cell = nineDistributerTableView.cellForRow(at: indexPath) {
                      cell.accessoryType = .none
                      // UnCheckmark cell JSON data Remove from array
                nineCheck.remove(at: indexPath.row)
               // nineCodes.remove(at: indexPath.row)
                      if let index = nineItems.index(of:item) {
                        nineItems.remove(at: index)
                      }
                nineDistributerTableView.reloadData()
              }
    }
//MARK: GET DROPDOWN DATA FROM API
    func getFstDropDownData(divisionCode:String, zipcode:String)
    {
       // let url = "https://retailerwebapiqa.usha.com:5065/api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    fstListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                    fstCodeListData.append(s_RetailerSapCode)
                }
            }
        }
    }
    func getSecDropDownData(divisionCode:String, zipcode:String)
    {
        //let url = "https://retailerwebapiqa.usha.com:5065/api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    secListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                    secCodeListData.append(s_RetailerSapCode)
                }
            }
        }
    }
    func getThreeDropDownData(divisionCode:String, zipcode:String)
    {
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    threeListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                    threeCodeListData.append(s_RetailerSapCode)
                }
            }
        }
    }
    func getFourDropDownData(divisionCode:String, zipcode:String)
    {
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    fourListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                    fourCodeListData.append(s_RetailerSapCode)
                }
            }
        }
    }
    func getFiveDropDownData(divisionCode:String, zipcode:String)
    {
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    fiveListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                    fiveCodeListData.append(s_RetailerSapCode)
                }
            }
        }
    }
    func getSixDropDownData(divisionCode:String, zipcode:String)
    {
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    sixListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                    sixCodeListData.append(s_RetailerSapCode)
                }
            }
        }
    }
    func getSevenDropDownData(divisionCode:String, zipcode:String)
    {
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    sevenListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                    sevenCodeListData.append(s_RetailerSapCode)
                }
            }
        }
    }
    func getEightDropDownData(divisionCode:String, zipcode:String)
    {
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    eightListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    eightCodeListData.append(s_RetailerSapCode)
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                }
            }
        }
    }
    func getNineDropDownData(divisionCode:String, zipcode:String)
    {
        let url = mainUrl + "api/EmployeeUser/GetRDDMmappingDetails?division=" + divisionCode + "&salesOffice=" + zipcode + "&MobileNo"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, encoding : URLEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async { [self] in
                print("URL : \(url)\nRESPONSE : \(response)")

                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["s_FullName"].stringValue
                    print("s_FullName:\(s_FullName)")
                    nineListData.append(s_FullName)
                    let s_RetailerSapCode = i["s_RetailerSapCode"].stringValue
                    print("s_RetailerSapCode:\(s_RetailerSapCode)")
                    nineCodeListData.append(s_RetailerSapCode)
                }
            }
        }
    }
    
}

extension UserProfileViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count - range.length
        if textField == txt_firmName
        {
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,&-_0123456789 "
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered && newLength <= 50)
        }
        else if textField == txt_ownerName
        {
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,&-_ "
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        else if textField == txt_ownerMobileNumber
        {
            if (currentCharacterCount == 0) && (string == "0")
            {
                return false
            }
            
            if(newLength == 10)
            {
                DuplicateNo = textField.text! + string
                callAction = ActionType.MobileNo
                getData()
            }
            return newLength <= 10
        }
        else if textField == txt_pincode
        {
            self.profilrPincode = ""
            if(newLength == 6)
            {
                fstCheckbox.isEnabled = true
                secCheckbox.isEnabled = true
                thirdCheckbox.isEnabled = true
                forthCheckbox.isEnabled = true
                fifthCheckbox.isEnabled = true
                sixthCheckbox.isEnabled = true
                seventhCheckbox.isEnabled = true
                eighthCheckbox.isEnabled = true
                ninthCheckbox.isEnabled = true
                
                DistributerTableView.isUserInteractionEnabled = true
                secDistributerTableView.isUserInteractionEnabled = true
                thirdDistributerTableView.isUserInteractionEnabled = true
                forthDistributerTableView.isUserInteractionEnabled = true
                fifthDistributerTableView.isUserInteractionEnabled = true
                sixDistributerTableView.isUserInteractionEnabled = true
                sevenDistributerTableView.isUserInteractionEnabled = true
                eightDistributerTableView.isUserInteractionEnabled = true
                nineDistributerTableView.isUserInteractionEnabled = true
                
                self.profilrPincode = textField.text! + string
                callAction = ActionType.DetailsByPinNo
                getData()
            }
            return newLength <= 6
        }else if textField == address1TextField
        {
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/.,&-_ "
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered && newLength <= 50)
        }
        else if textField == txt_address
        {
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/.,&-_ "
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered && newLength <= 50)
        }
            
        else if textField == txt_aadherNo
        {
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("Backspace was pressed")
            }
            else
            {
                if(newLength == 5 || newLength == 10)
                {
                    //   textField.text = textField.text! + " "
                }
            }
            
            if(newLength == 12)
            {
                DuplicateNo = (textField.text! + string).removeCharacters(from: " ")
                callAction = ActionType.AdharNo
                getData()
            }
            
            return newLength <= 12
        }
        else if textField == txt_panNo
        {
            if(newLength == 10)
            {
                DuplicateNo = textField.text! + string
                callAction = ActionType.PanNo
                getData()
            }
            return newLength <= 10
        }
        else if textField == txt_gstNo
        {
            // this below code pan no from gst
            
            
            if(newLength == 15){
                
                if let text = textField.text,
                    let textRange = Range(range, in: text) {
                    let updatedText = text.replacingCharacters(in: textRange,
                                                               with: string)
                    self.panFromGSTNo = (updatedText.subString(from: 2, to: 11))
                }
                
            }
            
            self.txt_panNo.text = panFromGSTNo
            self.txt_panNo.isEnabled = false
            
            if(newLength == 15)
            {
                DuplicateNo = textField.text! + string
                callAction = ActionType.GstNo
                //  getData()
            }
            return newLength <= 15
        }
        else if textField == txt_gstNo
        {
            let ACCEPTABLE_CHARACTERS = "/^([0-9]){2}([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}([0-9]){1}([a-zA-Z]){1}([a-zA-Z0-9]){1}?$/"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        else  if textField == txt_parentMobileNo
        {
            if (currentCharacterCount == 0) && (string == "0")
            {
                return false
            }
            return newLength <= 10
        }
        else
        {
            return true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        if textField != txt_pincode {
            showPincodeEntering = false
        }
        
        if(txt_responder != nil)
        {
            _ = txt_responder?.resignFirstResponder()
        }
        
        txt_responder = textField as? SkyFloatingLabelTextField
        
        if (textField == txt_selectFirmType)
        {
            if(arr_FirmCode.count == 0)
            {
                //hide this api
                callAction = ActionType.FrmType
                getData()
                return false
            }
            showFrmType()
            return false
        }
        else if(textField == txt_selectState)
        {
            if(arr_State.count == 0)
            {
                callAction = ActionType.State
                getData()
                return false
            }
            showState()
            return false
        }
        else if(textField == txt_selectDistrict)
        {
            if (txt_selectState.text! == "")
            {
                showAlert(msg: "PLEASE SELECT STATE")
                return false
            }
            
            if(arr_District.count == 0)
            {
                callAction = ActionType.DistrictByStateCode
                getData()
                return false
            }
            showDistrict()
            return false
        }
        else if(textField == txt_selectCity)
        {
            if (txt_selectDistrict.text! == "")
            {
                showAlert(msg: "PLEASE SELECT DISTRICT")
                return false
            }
            
            if(arr_City.count == 0)
            {
                callAction = ActionType.CityByDistrict
                getData()
                return false
            }
            showCity()
            return false
        }
        else if(textField == txt_selectArea)
        {
            if (txt_selectCity.text! == "")
            {
                showAlert(msg: "PLEASE SELECT CITY")
                return false
            }
            
            if(arr_Area.count == 0)
            {
                callAction = ActionType.AreaByCity
                getData()
                return false
            }
            showArea()
            return false
        }
        else if(textField == txt_selectRetailerType)
        {
            if(arr_RetailerType.count == 0)
            {
                callAction = ActionType.RetailerType
                getData()
                return false
            }
            showRetailer()
            return false
        }
        else if(textField == txt_selectRetailerCategory)
        {
            if(arr_RetailerCategory.count == 0)
            {
                callAction = ActionType.RetailerCategory
                getData()
                return false
            }
            getData()
            showRetailerCategory()
            return false
        }
            
        else if(textField == txt_pincode)
        {
            
//            if(arr_PinCode.count == 0)
//            {
//                callAction = ActionType.GetOtherDetailsByArea
//                getData()
//                return false
//            }
            showPincodeEntering = true
            if showPincodeEntering {
                return true
            } else {
                showPinCode()
            }
            
            return false
        }
            
        else if textField == txt_selectBranchName
        {
            if(txt_pincode.text == "")
            {
                showAlert(msg: "PLEASE ENTER PINCODE")
                return false
            }
            showBranch()
            return false
        }
        else if(textField == txt_selectGSTType)
        {
            txt_responder = txt_selectGSTType
            selectDropDown.dataSource = arr_gstType
            selectDropDown.anchorView = txt_selectGSTType
            
            selectDropDown.show()
            return false
        }
        else if(textField == txt_selectParentChildStatus)
        {
            txt_responder = txt_selectParentChildStatus
            selectDropDown.dataSource = arr_parentChildStatus
            selectDropDown.anchorView = txt_selectParentChildStatus
            selectDropDown.show()
            return false
        }
        else if(textField == txt_parentMobileNo)
        {
            if self.txt_selectParentChildStatus.validate()
            {
                if(self.txt_selectParentChildStatus.text == "PARENT")
                {
                    return false
                }
            }
            else
            {
                showAlert(msg: txt_selectParentChildStatus.strMsg)
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
//        if textField == txt_gstNo{
//            if txt_selectGSTType.hasText{
//                textField.becomeFirstResponder()
//            }else{
//                textField.resignFirstResponder()
//            }
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txt_aadherNo
        {
            let num = textField.text!.removeCharacters(from: " ")
            if(!Aadhar_VerhoeffAlgorithm.ValidateVerhoeff(num:num))
            {
                txt_aadherNo.showErrorIconForMsg("INVALID AADHAR NUMBER!")
            }else{
                
            }
        }
        
    }
}
//TODO: - Camera, UIImagePickerDelegate Methods

extension UserProfileViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    /**
     Action sheet to give choice for photo selection
     */
    func askToChangeImage()
    {
        let alertImage = UIAlertController(title: "Let's get a picture", message: "Choose a picture upload method", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        self.imgPicker.delegate = self
        
        //        if(is_imageUpload)
        //        {
        //            let removeImageButton = UIAlertAction(title: "Remove Picture", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
        //                //self.is_imageUpload = false
        //
        //            }
        //            alertImage.addAction(removeImageButton)
        //        }else{
        //            print("No image is selected")
        //        }
        
        //Add AlertAction to select image from library
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.flag = 0
            self.imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imgPicker.delegate = self
            self.present(self.imgPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                self.flag = 1
                self.imgPicker.dismiss(animated: true, completion: nil)
                self.imgPicker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(self.imgPicker, animated: true, completion: nil)
            }
            alertImage.addAction(cameraButton)
        } else {
            print("Camera not available")
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        alertImage.addAction(libButton)
        alertImage.addAction(cancelButton)
        self.present(alertImage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
      
            if flag == 0{
                self.demoURL = info[UIImagePickerControllerImageURL] as? URL
                print(demoURL)
                
            }else{
                self.demoURL = URL(fileURLWithPath: "Demo_Url")
            }
            
           setup(image: image, imgUrl: self.demoURL)
            
            
        } else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!)
    {
        
        if let image = image{ //info[UIImagePickerControllerOriginalImage] as? UIImage {
            //            uplodImage = image
            //            txt_check.text = "BlankCheque"
            //            img_check.image = uplodImage

            let imageURL = editingInfo[UIImagePickerControllerImageURL] as? URL
            
            print(imageURL!)
            
            //setup(image: image, imgUrl: imageURL!)
            
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: { () -> Void in
        })
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        //is_imageUpload = false
        dismiss(animated: true, completion: nil)
    }
    
    func setup(image:UIImage,imgUrl : URL)
    {
        
        switch self.imageType
        {
        case .UserProfileImage:
            for ele in arr_fileUpload {
                if ele.fileName != nil && ele.fileName == imageType.rawValue {
                    let ind = arr_fileUpload.index(of: ele)
                    arr_fileUpload.remove(at: ind!)
                }
            }
            img_ownerImage.image = image
            let file = Files()
            file.fileName = imageType.rawValue
            file.documentName = DocType.User.rawValue
            file.documentNo = ""
            file.image = image
            self.arr_fileUpload.append(file)
        case .AdharImage:
            for ele in arr_fileUpload {
                if ele.fileName != nil && ele.fileName == imageType.rawValue {
                    let ind = arr_fileUpload.index(of: ele)
                    arr_fileUpload.remove(at: ind!)
                }
            }
            img_aadharImage.image = image
            let file = Files()
            file.fileName = imageType.rawValue
            file.documentName = DocType.Adhar.rawValue
            file.documentNo = self.txt_aadherNo.text!
            file.image = image
            self.arr_fileUpload.append(file)
            self.aadharString = "\(imgUrl)"
            
        case .PanImage:
            for ele in arr_fileUpload {
                if ele.fileName != nil && ele.fileName == imageType.rawValue {
                    let ind = arr_fileUpload.index(of: ele)
                    arr_fileUpload.remove(at: ind!)
                }
            }
            img_panImage.image = image
            let file = Files()
            file.fileName =  imageType.rawValue
            file.documentName = DocType.Pan.rawValue
            file.documentNo = self.txt_panNo.text!
            file.image = image
            self.arr_fileUpload.append(file)
            self.panString = "\(imgUrl)"
        case .GstImage:
            for ele in arr_fileUpload {
                if ele.fileName != nil && ele.fileName == imageType.rawValue {
                    let ind = arr_fileUpload.index(of: ele)
                    arr_fileUpload.remove(at: ind!)
                }
            }
            img_gstImage.image = image
            let file = Files()
            file.fileName = imageType.rawValue
            file.documentName = DocType.Gst.rawValue
            file.documentNo = self.txt_gstNo.text!
            file.image = image
            self.arr_fileUpload.append(file)
            self.gstString = "\(imgUrl)"
        case .ShopImage:
            for ele in arr_fileUpload {
                if ele.fileName != nil && ele.fileName == imageType.rawValue {
                    let ind = arr_fileUpload.index(of: ele)
                    arr_fileUpload.remove(at: ind!)
                }
            }
            img_shopImage.image = image
            let file = Files()
            file.fileName = imageType.rawValue
            file.documentName = DocType.Shop.rawValue
            file.documentNo = ""
            file.image = image
            self.arr_fileUpload.append(file)
        case .OtherImage:
            for ele in arr_fileUpload {
                if ele.fileName != nil && ele.fileName == imageType.rawValue {
                    let ind = arr_fileUpload.index(of: ele)
                    arr_fileUpload.remove(at: ind!)
                }
            }
            img_otherImage.image = image
            let file = Files()
            file.fileName = imageType.rawValue
            file.documentName = DocType.ShopDoc.rawValue
            file.documentNo = ""
            file.image = image
            self.arr_fileUpload.append(file)
        case .none: break
        }
    }
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if(alertTag == 1)
        {
            var isUploadImage = false
            for item in self.arr_fileUpload
            {
                if item.image != nil
                {
                    isUploadImage = true
                }
            }
            
            if(isUploadImage)
            {
                uploadFiles()
            }
            else
            {
                btn_edit_pressed(btn_edit)
            }
        }
        else if(alertTag == 3)
        {
            if(isRgistration)
            {
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                self.navigationController?.popToRootViewController(animated: true)
                //btn_edit_pressed(btn_edit)
            }
        } else if(alertTag == 4)
        {
           
                self.dismiss(animated: true, completion: nil)
          
        }
    }

    func uploadFiles()
    {
        
        var urlStr: String = ""

               if isRgistration{
                    urlStr = "\(baseUrl)EmployeeUser/UserRegistrationUploadFile?chkRequest=R"

               }else{
                    urlStr = "\(baseUrl)EmployeeUser/UserRegistrationUploadFile?chkRequest=E"
               }
       
//        let urlStr = "\(baseUrl)EmployeeUser/UserRegistrationUploadFile?chkRequest=E"
        let url = try! URLRequest(url: urlStr, method: .post, headers: headers)
        
        
        presentWindow?.makeToastActivity(message: "Uploading...")
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            print(self.arr_fileUploadToServer)
         
            
            for item in self.arr_fileUploadToServer
            {
                if let image = item.image
                {
                    
                    let imgName = "\(self.usercode)_\(item.fileName!).jpg"
                    
                    print(imgName)
                    let imageData = image.jpeg(.medium)
                    multipartFormData.append(imageData!, withName: "", fileName: imgName, mimeType: "image/jpg")
                    multipartFormData.append(imgName.data(using: String.Encoding.utf8)!, withName: "name")
                }
            
            }
        
        }, with: url) {  result in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response)
                    presentWindow?.hideToastActivity()
                    self.alertTag = 3
                    self.showAlert(msg: "FILES UPLOADED SUCCESSFULLY!")
                }
            case .failure(let encodingError):
                print("failure : \(encodingError)")
            }
        }
        //        }
    }
    
    /* func imageUpload()
     {
     Alamofire.upload(
     multipartFormData: { multipartFormData in
     multipartFormData.append(imageData, withName: "photo[image]", fileName: filename, mimeType: "image/jpg")
     },
     usingThreshold: UInt64(0), // force alamofire to always write to file no matter how small the payload is
     to: "http://", // if we give it a real url sometimes alamofire will attempt the first upload. I don't want to let it get to our servers but it fails if I feed it ""
     method: .post,
     headers: headers,
     encodingCompletion: { encodingResult in
     switch encodingResult {
     case .success(let alamofireUploadTask, _, let url):
     alamofireUploadTask.suspend()
     defer { alamofireUploadTask.cancel() }
     if let alamofireUploadFileUrl = url {
     var request = URLRequest(url: URL(string: "https://yourserver.com/photoUploadEndpoint")!)
     request.httpMethod = "POST"
     for (key, value) in alamofireUploadTask.request!.allHTTPHeaderFields! { // transfer headers from the request made by alamofire
     request.addValue(value, forHTTPHeaderField: key)
     }
     // we want to own the multipart file to avoid alamofire deleting it when we tell it to cancel its task
     // so copy file on alamofireUploadFileUrl to a file you control
     // dispatch the request to the background session
     // don't forget to delete the file when you're done uploading
     } else {
     // alamofire failed to encode the request file for some reason
     }
     case .failure:
     // alamofire failed to encode the request file for some reason
     }
     }
     )
     }*/
    
}

extension UserProfileViewController
{
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if let jsonData = json as? [Any]
        {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: JSONSerialization.WritingOptions.prettyPrinted) else
            {
                showAlert(msg: "DATA NOT FOUND!")
                return
            }

            do {
                if(callAction == ActionType.State)
                {
                    self.arr_State = try JSONDecoder().decode([Division].self, from: jsonData)
                    if(self.arr_State.count == 0)
                    {
                        showAlert(msg: "STATE NOT AVAIBLE!")
                        return
                    }
                    
                    if(isRgistration || isProfileEditing)
                    {
                        showState()
                    }
                    else if profile != nil,
                        let index = self.arr_State.index(where: {$0.code! == profile.StateCode!})
                    {
                        area.stateName = self.arr_State[index].name!
                        area.stateCode = self.arr_State[index].code!
                        txt_selectState.text =  self.arr_State[index].name!
                        callAction = ActionType.DistrictByStateCode
                        getData()
                    }
                }
                else if(callAction == ActionType.DistrictByStateCode)
                {
                    self.arr_District = try JSONDecoder().decode([Division].self, from: jsonData)
                    if(self.arr_District.count == 0)
                    {
                        showAlert(msg: "DISTRICT NOT AVAIBLE!")
                        return
                    }
                    if(isRgistration || isProfileEditing)
                    {
                        showDistrict()
                    }
                    else if profile != nil,
                        let index = self.arr_District.index(where: {$0.code! == profile.DistrictCode!})
                    {
                        area.districtName = self.arr_District[index].name!
                        area.districtCode = self.arr_District[index].code!
                        txt_selectDistrict.text =  self.arr_District[index].name!
                        
                        callAction = ActionType.CityByDistrict
                        getData()
                    }
                    
                }
                else if(callAction == ActionType.CityByDistrict)
                {
                    self.arr_City = try JSONDecoder().decode([Division].self, from: jsonData)
                    if(self.arr_City.count == 0)
                    {
                        showAlert(msg: "CITY NOT AVAIBLE!")
                        return
                    }
                    if(isRgistration || isProfileEditing)
                    {
                        showCity()
                    }
                    else if profile != nil,
                        let index = self.arr_City.index(where: {$0.code! == profile.CityCode!})
                    {
                        area.cityName = self.arr_City[index].name!
                        area.cityCode = self.arr_City[index].code!
                        txt_selectCity.text =  self.arr_City[index].name!
                        
                        callAction = ActionType.AreaByCity
                        getData()
                    }
                    
                }
                else if(callAction == ActionType.AreaByCity)
                {
                    self.arr_Area = try JSONDecoder().decode([Division].self, from: jsonData)
                    if(self.arr_Area.count == 0)
                    {
                        showAlert(msg: "AREA NOT AVAIBLE!")
                        return
                    }
                    if(isRgistration || isProfileEditing)
                    {
                        showArea()
                    }
                    else if profile != nil,
                        let index = self.arr_Area.index(where: {$0.code! == profile.AreaCode!})
                    {
                        area.areaName = self.arr_Area[index].name!
                        area.areaCode = self.arr_Area[index].code!
                        txt_selectArea.text =  self.arr_Area[index].name!
                    }
                } else if(callAction == ActionType.RetailerType)
                {
                    self.arr_RetailerType = try JSONDecoder().decode([Division].self, from: jsonData)
                    print(self.arr_RetailerType)
                    if(self.arr_RetailerType.count == 0)
                    {
                        showAlert(msg: "RETAILER TYPE NOT AVAIBLE!")
                        return
                    }
                    if(isRgistration || isProfileEditing)
                    {
                        showRetailer()
                    }
                    else if profile != nil,
                        let index = self.arr_RetailerType.index(where: {$0.code! == profile.s_UserSubTypeCode!})
                    {
                        
                        retailerTypeString = self.arr_RetailerType[index].code!
                        txt_selectRetailerType.text =  self.arr_RetailerType[index].name!
                        userSubtypeTextField.text = self.arr_RetailerType[index].name!
                        
                    }
                }

            } catch {
                print("Decoder Error \(error.localizedDescription)")
            }
        }
        else if (parser.isSuccess(result: json as! [String:Any])),
            let ResponseData = parser.responseData as? String,
            let json = ResponseData.data(using: String.Encoding.utf8)
        {
            print(json)
            if(callAction == ActionType.Insert || callAction == ActionType.EditUser)
            {
                if(ResponseData == "")
                {
                    if(isRgistration)
                    {
                        let  responsemessage = parser.responseMessage!.uppercased()
                        alertTag = 0
                        showAlert(msg: responsemessage)
                    }
                    else
                    {
                        let  responsemessage = parser.responseMessage!.uppercased()
                        if responsemessage == "ADHAR NO ALREADY EXISTS"{
                            alertTag = 0
                            showAlert(msg: parser.responseMessage!.uppercased())
                        }else if responsemessage == "PAN NO ALREADY EXISTS"{
                            alertTag = 0
                            showAlert(msg: parser.responseMessage!.uppercased())
                            
                        }else if responsemessage == "GST NO ALREADY EXISTS"{
                            alertTag = 0
                            showAlert(msg: parser.responseMessage!.uppercased())
                        }else{
                            alertTag = 1
                            showAlert(msg: parser.responseMessage!.uppercased())
                        }
                        
                    }
                }
                else
                {
                    usercode = ResponseData
                    alertTag = 1
                    showAlert(msg: parser.responseMessage!.uppercased())
                }
            }
            else
            {
                do {
                    if(callAction == ActionType.FrmType)
                    {
                        self.arr_FirmCode = try JSONDecoder().decode([Division].self, from: json)
                        if(self.arr_FirmCode.count == 0)
                        {
                            showAlert(msg: "FIRM NOT AVAIBLE!")
                            return
                        }
                        if(isRgistration)
                        {
                            showFrmType()
                        }
                        else if profile != nil,
                            let index = self.arr_FirmCode.index(where: {$0.code! == profile.s_FirmCode ?? ""})
                        {
                            self.firm = self.arr_FirmCode[index]
//                            txt_selectFirmType.text =  self.arr_FirmCode[index].name!
                            txt_selectFirmType.text = "Proprietor"
                            callAction = ActionType.State
                            getData()
                        }
                        
                        txt_selectFirmType.text = "Proprietor"
                        callAction = ActionType.State
                        getData()
                    }
                    else if(callAction == ActionType.RetailerCategory)
                    {
                        self.arr_RetailerCategory = try JSONDecoder().decode([Division].self, from: json)
                        print(self.arr_RetailerCategory)
                        if(self.arr_RetailerCategory.count == 0)
                        {
                            showAlert(msg: "RETAILER TYPE NOT AVAIBLE!")
                            return
                        }
                        if(isRgistration || isProfileEditing)
                        {
                            showRetailerCategory()
                        }
                        else if profile != nil,
                            let index = self.arr_RetailerCategory.index(where: {$0.code! == profile.UserCategoryCode!})
                            
                        {
                           
                            retailerCategoryCode = self.arr_RetailerCategory[index].code!
                            txt_selectRetailerCategory.text =  self.arr_RetailerCategory[index].name!
                            getData()
                           // userSubtypeTextField.text = self.arr_RetailerCategory[index].name!
                            
                        }
                    }
                    else if(callAction == ActionType.ProductProfile)
                    {
                        self.arr_productNameCode.removeAll()
                        self.arr_productNameCode = try JSONDecoder().decode([Division].self, from: json)
                        print(arr_productNameCode)
                        if(self.arr_productNameCode.count == 0)
                        {
                            showAlert(msg: "FIRM NOT AVAIBLE!")
                            return
                        }
                        if(isRgistration)
                        {
//                            showFrmType()
                            for  prodEle in arr_productNameCode {
                                let productProfile = ProductProfile()
                                
                                productProfile.DivCode = prodEle.code
                                productProfile.S_Usercode = ""
                                productProfile.Category = ""
                                productProfile.companyAssociate = ""

                                if appDelegate.arr_productProfile.count == 0 {
                                    appDelegate.arr_productProfile.append(productProfile)
                                }else {
                                    appDelegate.arr_productProfile.append(productProfile)

                                }
                                
                            }
                            
                            let prodObj = appDelegate.arr_productProfile
                            let jsonEncoder = JSONEncoder()
                            let jsonData = try jsonEncoder.encode(prodObj)
                            let json = String(data: jsonData, encoding: String.Encoding.utf8)
                            print("jsonString is: \(json) ")
                            self.tblView.reloadData()
                        }else {
                            usercode = DataProvider.sharedInstance.userDetails.s_UserCode!

                            for  prodEle in arr_productNameCode {
                                print(prodEle)
                                let productProfile = ProductProfile()
                                print(prodEle.name)
                                productProfile.DivCode = prodEle.code
                                productProfile.S_Usercode = usercode
                                productProfile.Category = ""
                                productProfile.companyAssociate = ""

                                if appDelegate.arr_productProfile.count == 0 {
                                    appDelegate.arr_productProfile.append(productProfile)
                                }else {
                                    appDelegate.arr_productProfile.append(productProfile)

                                }
                                
                            }
                            
                            let prodObj = appDelegate.arr_productProfile
                            let jsonEncoder = JSONEncoder()
                            let jsonData = try jsonEncoder.encode(prodObj)
                            let json = String(data: jsonData, encoding: String.Encoding.utf8)
                            print("jsonString is: \(json) ")
//                            self.tblView.reloadData()
                            callAction = ActionType.Edit
                            getData()
                            
                        }
//                        else if profile != nil,
//                            let index = self.arr_FirmCode.index(where: {$0.code! == profile.s_FirmCode ?? ""})
//                        {
//                            self.firm = self.arr_FirmCode[index]
////                            txt_selectFirmType.text =  self.arr_FirmCode[index].name!
//                            txt_selectFirmType.text = "Proprietor"
//                            callAction = ActionType.State
//                            getData()
//                        }
//
//                        txt_selectFirmType.text = "Proprietor"
//                        callAction = ActionType.State
//                        getData()
                    }
                    else if (callAction == ActionType.GetOtherDetailsByArea)
                    {
                        arr_PinCode = try JSONDecoder().decode([AreaPincode].self, from: json)
                        if(arr_PinCode.count == 0)
                        {
                            showAlert(msg: "PLEASE ENTER 6 DIGIT VALID PINCODE!")
                            return
                        }
                        if arr_PinCode.count == 1 {
                            let pincodeBranch = self.arr_PinCode[0]
                            self.area.pinCode = pincodeBranch.s_PinCode!
                            self.area.branchName = pincodeBranch.s_BranchName!
                            self.area.branchCode = pincodeBranch.s_BranchCode!
                            self.area.regionCode = pincodeBranch.s_RegionCode!
                            self.area.regionName = pincodeBranch.s_RegionName!
                            self.area.salesOfficeCode = pincodeBranch.s_SalesOfficeCode!
                            self.area.salesOfficeName = pincodeBranch.s_SalesOfficeName!
                            self.txt_pincode.text = pincodeBranch.s_PinCode
                            self.txt_selectBranchName.text = pincodeBranch.s_BranchName!
                        } else {
                            showPinCode()
                        }
                    }
                    else if(callAction == ActionType.DetailsByPinNo)
                    {
                        let areasByPincode = try JSONDecoder().decode([Area].self, from: json)
                        //self.arr_AreaByPincode = try JSONDecoder().decode([Area].self, from: json)
                        if(areasByPincode.count == 0)
                        {
                            showAlert(msg: "PLEASE ENTER 6 DIGIT VALID PINCODE!")
                            return
                        }
                        
                        if(isRgistration)
                        {
                            area = areasByPincode[0]
                            txt_selectState.text = area.stateName!
                            txt_selectDistrict.text = area.districtName!
                            txt_selectCity.text = area.cityName!
                            txt_selectArea.text = area.areaName!
                            txt_selectBranchName.text = area.branchName!
                            
                            //area = self.arr_AreaByPincode[0]
                            //                            if(self.txt_selectState.text! != "")
                            //                            {
                            //                                let areaByPIN = self.arr_AreaByPincode.filter({$0.stateName! == self.txt_selectState.text!})
                            //                                if areaByPIN.count > 0
                            //                                {
                            //                                    area = areaByPIN[0]
                            //                                    txt_selectState.text = area.stateName!
                            //                                }
                            //                                else
                            //                                {
                            //                                    txt_selectState.text = area.stateName!
                            //                                }
                            //                            }
                            //                            else
                            //                            {
                            //                                txt_selectState.text = area.stateName!
                            //                            }
                            //
                            //                            if(self.txt_selectDistrict.text! != "")
                            //                            {
                            //                                let areaByPIN = self.arr_AreaByPincode.filter({$0.districtName! == self.txt_selectDistrict.text!})
                            //                                if areaByPIN.count > 0
                            //                                {
                            //                                    area = areaByPIN[0]
                            //                                    txt_selectDistrict.text = area.districtName!
                            //                                }
                            //                                else
                            //                                {
                            //                                    txt_selectDistrict.text = area.districtName!
                            //                                }
                            //                            }
                            //                            else
                            //                            {
                            //                                txt_selectDistrict.text = area.districtName!
                            //                            }
                            //
                            //                            if(self.txt_selectCity.text! != "")
                            //                            {
                            //                                let areaByPIN = self.arr_AreaByPincode.filter({$0.cityName! == self.txt_selectCity.text!})
                            //                                if areaByPIN.count > 0
                            //                                {
                            //                                    area = areaByPIN[0]
                            //                                    txt_selectCity.text = area.cityName!
                            //                                }
                            //                                else
                            //                                {
                            //                                    txt_selectCity.text = area.cityName!
                            //                                }
                            //                            }
                            //                            else
                            //                            {
                            //                                txt_selectCity.text = area.cityName!
                            //                            }
                            //
                            //                            if(self.txt_selectArea.text! != "")
                            //                            {
                            //                                let areaByPIN = self.arr_AreaByPincode.filter({$0.areaName! == self.txt_selectArea.text!})
                            //                                if areaByPIN.count > 0
                            //                                {
                            //                                    area = areaByPIN[0]
                            //                                    txt_selectArea.text = area.areaName!
                            //                                    print(txt_selectArea.text as Any)
                            //                                }
                            //                                else
                            //                                {
                            //                                    txt_selectArea.text = ""
                            //                                }
                            //                            }
                            //                            else
                            //                            {
                            //                                txt_selectArea.text = ""
                            //                            }
                        }
                        else if profile != nil
                        {
                            //area = self.arr_AreaByPincode[0]
                            
                            area = areasByPincode[0]
                            txt_selectState.text = area.stateName!
                            txt_selectDistrict.text = area.districtName!
                            txt_selectCity.text = area.cityName!
                            txt_selectArea.text = area.areaName!
                            txt_selectBranchName.text = area.branchName!
                            
                            self.arr_District = []
                            self.arr_City = []
                            self.arr_Area = []
                            self.arr_PinCode = []
                            callAction = ActionType.RetailerType
                             getData()
                        }
                    }
                    else if(callAction == ActionType.Edit)
                    {
                        appDelegate.arr_productProfile.removeAll()
//                        arr_productNameCode.removeAll()
                        self.profile = try JSONDecoder().decode(Profile.self, from: json)
                        if let docment = self.profile.Documents,
                            let docData = docment.data(using: .utf8)
                        {
                            let arrDoc = try JSONDecoder().decode([Document].self, from: docData)
                            self.profile.arr_Documents = arrDoc
                        }
                        
                        if let prodArray = self.profile.ProductProfile,
                            let prodData = prodArray.data(using: .utf8)
                        {
//                           arr_productNameCode.removeAll()

                            let arrDoc = try JSONDecoder().decode([ServerProductProfile].self, from: prodData)
//                            self.profile.arr_Documents = arrDoc
                            print(arrDoc)
                            for ele in arrDoc {
                                let prodProfile = ProductProfile()
                                print(ele.dealerName)
                                if ele.s_SKUCategoryCode == "11"{
                                   // fstCheckbox.isEnabled = true
                                    fstCheckbox.on = true
                                    items.append(ele.dealerName!)
                                    var data = fst_collect(name: ele.dealerName!)
                                    check.append(data)
                                    fstCode = ele.s_DealerCode!
                                    print(ele.s_class!)
                                    fstClass = ele.s_class!
                                    if ele.s_class != nil{
                                    fstClassLbl.text = ele.s_class!
                                    }
                                    DistributerTableView.reloadData()
                                }
                                if ele.s_SKUCategoryCode == "36"{
                                   // secCheckbox.isEnabled = true
                                    secCheckbox.on = true
                                    secItems.append(ele.dealerName!)
                                    var data = sec_check(name: ele.dealerName!)
                                    secCheck.append(data)
                                    secCode = ele.s_DealerCode!
                                    secClass = ele.s_class!
                                    if ele.s_class != nil{
                                    secClassLbl.text = ele.s_class!
                                    }
                                    secDistributerTableView.reloadData()
                                }
                                if ele.s_SKUCategoryCode == "46" {
                                   // thirdCheckbox.isEnabled = true
                                    thirdCheckbox.on = true
                                    thirdItems.append(ele.dealerName!)
                                    var data = third_check(name: ele.dealerName!)
                                    thirdCheck.append(data)
                                    threeCode = ele.s_DealerCode!
                                    threeClass = ele.s_class!
                                    if ele.s_class != nil{
                                    threeClassLbl.text = ele.s_class!
                                    }
                                    thirdDistributerTableView.reloadData()
                                }
                                if ele.s_SKUCategoryCode == "41" {
                                    //thirdCheckbox.isEnabled = true
                                    forthCheckbox.on = true
                                    forthItems.append(ele.dealerName!)
                                    var data = forth_check(name: ele.dealerName!)
                                    forthCheck.append(data)
                                    fourCode = ele.s_DealerCode!
                                    fourClass = ele.s_class!
                                    if ele.s_class != nil{
                                    fourClassLbl.text = ele.s_class!
                                    }
                                    forthDistributerTableView.reloadData()
                                }
                                if ele.s_SKUCategoryCode == "80" {
                                    //thirdCheckbox.isEnabled = true
                                    fifthCheckbox.on = true
                                    fifthItems.append(ele.dealerName!)
                                    var data = fifth_check(name: ele.dealerName!)
                                    fifthCheck.append(data)
                                    fiveCode = ele.s_DealerCode!
                                    fiveClass = ele.s_class!
                                    if ele.s_class != nil{
                                    fiveClassLbl.text = ele.s_class!
                                    }
                                    fifthDistributerTableView.reloadData()
                                }
                                if ele.s_SKUCategoryCode == "20" {
                                    //thirdCheckbox.isEnabled = true
                                    sixthCheckbox.on = true
                                    sixItems.append(ele.dealerName!)
                                    var data = six_check(name: ele.dealerName!)
                                    sixCheck.append(data)
                                    sixCode = ele.s_DealerCode!
                                    sixClass = ele.s_class!
                                    if ele.s_class != nil{
                                    sixClassLbl.text = ele.s_class!
                                    }
                                    sixDistributerTableView.reloadData()
                                }
                                if ele.s_SKUCategoryCode == "12" {
                                    //thirdCheckbox.isEnabled = true
                                    seventhCheckbox.on = true
                                    sevenItems.append(ele.dealerName!)
                                    var data = seven_check(name: ele.dealerName!)
                                    sevenCheck.append(data)
                                    sevenCode = ele.s_DealerCode!
                                    SevenClass = ele.s_class!
                                    if ele.s_class != nil{
                                    sevenClassLbl.text = ele.s_class!
                                    }
                                    sevenDistributerTableView.reloadData()
                                }
                                if ele.s_SKUCategoryCode == "10" {
                                    //thirdCheckbox.isEnabled = true
                                    eighthCheckbox.on = true
                                    eightItems.append(ele.dealerName!)
                                    var data = eight_check(name: ele.dealerName!)
                                    eightCheck.append(data)
                                    eightCode = ele.s_DealerCode!
                                    EightClass = ele.s_class!
                                    if ele.s_class != nil{
                                    eightClassLbl.text = ele.s_class!
                                    }
                                    eightDistributerTableView.reloadData()
                                }
                                if ele.s_SKUCategoryCode == "60" {
                                    //ninthCheckbox.isEnabled = true
                                    ninthCheckbox.on = true
                                    nineItems.append(ele.dealerName!)
                                    var data = nine_check(name: ele.dealerName!)
                                    nineCheck.append(data)
                                    nineCode = ele.s_DealerCode!
                                    NineClass = ele.s_class!
                                    if ele.s_class != nil{
                                    nineClassLbl.text = ele.s_class!
                                    }
                                    nineDistributerTableView.reloadData()
                                }
                                prodProfile.DivCode = ele.Divcode
                                prodProfile.S_Usercode = ele.S_Usercode
                                prodProfile.Category = ele.Category
                                prodProfile.companyAssociate = ele.companyAssociate
                                
                                appDelegate.arr_productProfile.append(prodProfile)
                            }
                            print("array from edit is : \(appDelegate.arr_productProfile)")
//                            appDelegate.arr_productProfile = arrDoc
                            
                            
//                            for  prodEle in arrDoc {
//                                let productProfile = Division()
//
//                                productProfile.code = prodEle.DivCode
//                                productProfile.name = prodEle.companyAssociate
//
//
//                                if arr_productNameCode.count == 0 {
//                                    self.arr_productNameCode.append(productProfile)
//                                }else {
//                                    self.arr_productNameCode.append(productProfile)
//
//                                }
//
//                            }


                            tblView.reloadData()
//                            
//                            callAction = ActionType.ProductProfile
//                            getData()
                        }
                        print("PROFILE: \(self.profile)")
                        //hide this api
//                        callAction = ActionType.FrmType
//                        getData()
                        
                        txt_firmName.text = profile.s_ShopName!
                        txt_ownerName.text = profile.s_FullName!
                        txt_ownerMobileNumber.text = profile.s_MobileNo!
                        txt_address.text = profile.s_ShopAddress2!
                        //                        txt_sapCode.text = profile.s_RetailerSapCode!
                        if let weekly_off = profile.s_WeeklyOff {
                            txt_monthlybizz.text = weekly_off

                        }else {
                            txt_monthlybizz.text = ""

                        }
//                        txt_monthlybizz.text = profile.s_WeeklyOff!
                        txt_pincode.text = profile.PinCode!
                        zipCode = profile.PinCode!
                        //view for state area cirt district
                        self.profilrPincode = profile.PinCode!
                        callAction = ActionType.DetailsByPinNo
                        getData()
                        txt_selectBranchName.text = profile.BranchName!
                        
                        
                        //                        userTypeTextField.text = profile.s_UserTypeCode!
                        LasrActionTextField.text = profile.ModifyDate!
                        if profile.s_UserSubTypeCode == "null"{
                            userSubtypeTextField.text = ""
                        }else{
                            userSubtypeTextField.text = profile.s_UserSubTypeCode
                            let userCategory = profile.UserCategoryCode
                            //print(userCategory)
                            if userCategory == "UTC0167" {
                                txt_selectRetailerCategory.text = "Trade Retailer (TRR)"
                                retailerCategoryCode = "UTC0167"
                            }else if userCategory == "UTC0168" {
                                txt_selectRetailerCategory.text = "Rural Business Retailer (RBR)"
                                retailerCategoryCode = "UTC0168"
                            }else if userCategory == "UTC0169" {
                                txt_selectRetailerCategory.text = "Usha Rural Preferred Dealer (URPD)"
                                retailerCategoryCode = "UTC0169"
                            }else if userCategory == "UTC0170" {
                                txt_selectRetailerCategory.text = "Usha Silai School (SSR)"
                                retailerCategoryCode = "UTC0170"
                            }else if userCategory == "UTC0171" {
                                txt_selectRetailerCategory.text = "Modern Trade Outlet (MTR)"
                                retailerCategoryCode = "UTC0171"
                            }else if userCategory == "UTC0172" {
                                txt_selectRetailerCategory.text = "Regional Retail Outlet (RRR)"
                                retailerCategoryCode = "UTC0172"
                            }else{
                                txt_selectRetailerCategory.text = ""
                                retailerCategoryCode = ""
                            }
                            //callAction = ActionType.RetailerType
                           // getData()
                          /*  if profile.s_UserSubTypeCode == "UTC0161"{
                                userSubtypeTextField.text = "GENERAL TRADE(GT)"
                                txt_selectRetailerType.text = "GENERAL TRADE(GT)"

                            }else if profile.s_UserSubTypeCode == "UTC0162"{
                                userSubtypeTextField.text = "REGIONAL RETAIL(RR)"
                                txt_selectRetailerType.text = "REGIONAL RETAIL(RR)"

                            }else if profile.s_UserSubTypeCode == "UTC0163"{
                                userSubtypeTextField.text = "MODERN RETAIL(MR)"
                            }else  if profile.s_UserSubTypeCode == "UTC0164"{
                                userSubtypeTextField.text = "CENTERAL POLICE CANTEEN (CPC)"
                            }else if profile.s_UserSubTypeCode == "UTC0165"{
                                userSubtypeTextField.text = "CANTEEN STORES DEPARTMENT-ARMY(CSD)"
                            }else if profile.s_UserSubTypeCode == "UTC0166"{
//                                userSubtypeTextField.text = "CANTEEN STORES DEPARTMENT-ARMY(CSD)"
                                txt_selectRetailerType.text = "OTHERSS"

                            }
                            else{
                                userSubtypeTextField.text = "null"
                            }
 */
                        }
                        //                        userSubtypeTextField.text = profile.s_UserSubTypeCode!
                        registrationTextField.text = profile.s_UserCurrentStatus!
                        registrationdateTextField.text = profile.RegistrationDate!
                        address1TextField.text = profile.s_ShopAddress1!
                        userStatusTextField.text = profile.b_IsActive!
                        lastActivationLabel.text = profile.ModifyDate!
                        createdLabel.text = profile.EmpName!
                        userCurrentStatusLabel.text = profile.s_UserCurrentStatus!
                        verifiedLabel.text = "\(profile.VerifiedBy!)"
//                        kamNameLabel.text = "\(profile.KAMName!) " + "\(profile.KAMMobileNo!)"
//                        profileVerifiedLabel.text = "\(profile.s_IsVerified!)".uppercased()
                       // hevellsIdTextField.text = profile.s_MdmCode!
                        
                        
                        //EDIT BUTTON HIDE AND SHOW
                        if (profile.s_UserCurrentStatus == "Approved") {
                            btn_edit.isHidden = false
                            profileUnderEditLabel.isHidden = true
                            
                        }else{
                            btn_edit.isHidden = true
                            profileUnderEditLabel.isHidden = false
                        }
                        //If  User Bank details approved then firm name and owner name cannot change(readonly field)
                        if (profile.s_AccountStatus == "APPROVED" || profile.s_AccountStatus == "Approved"){
                            txt_firmName.isEnabled = false
                            txt_firmName.isUserInteractionEnabled = false
                            txt_firmName.textColor = .gray
                            txt_ownerName.isEnabled = false
                            txt_ownerName.isUserInteractionEnabled = false
                            txt_ownerName.textColor = .gray
                        } else {
                            txt_firmName.isEnabled = true
                            txt_ownerName.isEnabled = true
                            txt_firmName.textColor = .black
                            txt_ownerName.textColor = .black
                        }
                        //view for city district area 
//                        self.profilrPincode = profile.PinCode!
//                        callAction = ActionType.DetailsByPinNo
//                        getData()
                        
                        if let email = profile.s_EmailID
                        {
                            txt_email.text = email
                        }
                        if let gst = profile.s_GSTType
                        {
                            txt_selectGSTType.text = gst
                        }
                        if let gstno = profile.s_GSTNo
                        {
                            if txt_selectGSTType.hasText{
                                txt_selectGSTType.text = gstno
                            }else{
                                txt_gstNo.isUserInteractionEnabled = false
                                txt_gstNo.textColor = .gray
                            }
                        }
                        txt_selectParentChildStatus.text = profile.s_StatusParentChild ?? ""
                        txt_parentMobileNo.text = profile.s_RetailerParentCode ?? ""
                        
                        
                        if(profile.arr_Documents!.count > 0)
                        {
                            for doc in profile.arr_Documents!
                            {
                                let file = Files()
                                let url = "\(mainUrl)Document/\(doc.s_FileName ?? "")"
                                print("url:\(url)")
                                if(doc.s_DocumnetMasterCode == DocType.Adhar.rawValue)
                                {
                                    txt_aadherNo.text = doc.s_DocumnetNo!

                                    img_aadharImage.downloadedFrom(link: url)
                                    {
                                        image in

                                        file.fileName = ImageType.AdharImage.rawValue //right
                                        file.documentName = doc.s_DocumnetMasterCode!
                                        file.documentNo = self.txt_aadherNo.text!//doc.s_DocumnetNo
                                        file.image = image
                                        
                                        for ele in self.arr_fileUpload {
                                            if ele.fileName != nil && ele.fileName == self.imageType.rawValue {
                                                let ind = self.arr_fileUpload.index(of: ele)
                                                self.arr_fileUpload.remove(at: ind!)
                                            }
                                        }
                                        
                                        self.arr_fileUpload.append(file)
                                        
                                        self.aadharString = url
                                    }
                                }
                                else if (doc.s_DocumnetMasterCode == DocType.Pan.rawValue)
                                {
                                    txt_panNo.text = doc.s_DocumnetNo!
                                    img_panImage.downloadedFrom(link: url)
                                    {
                                        image in
                                  
                                        file.fileName = ImageType.PanImage.rawValue //right
                                        file.documentName = doc.s_DocumnetMasterCode
                                        file.documentNo = self.txt_panNo.text//doc.s_DocumnetNo
                                        file.image = image
                                        
                                        for ele in self.arr_fileUpload {
                                            if ele.fileName != nil && ele.fileName == self.imageType.rawValue {
                                                let ind = self.arr_fileUpload.index(of: ele)
                                                self.arr_fileUpload.remove(at: ind!)
                                            }
                                        }
                                        
                                        self.arr_fileUpload.append(file)
                                        
                                        self.panString = url
                                    }
                                   
                                }
                                else if (doc.s_DocumnetMasterCode == DocType.Gst.rawValue)
                                {
                                    txt_gstNo.text = doc.s_DocumnetNo!
                                    img_gstImage.downloadedFrom(link: url)
                                    {
                                        image in
                                        
                                        file.fileName = ImageType.GstImage.rawValue //right
                                        file.documentName = doc.s_DocumnetMasterCode
                                        file.documentNo = self.txt_gstNo.text//doc.s_DocumnetNo
                                        file.image = image
                                        
                                        for ele in self.arr_fileUpload {
                                            if ele.fileName != nil && ele.fileName == self.imageType.rawValue {
                                                let ind = self.arr_fileUpload.index(of: ele)
                                                self.arr_fileUpload.remove(at: ind!)
                                            }
                                        }
                                        
                                         self.arr_fileUpload.append(file)
                                        
                                        self.gstString = url
                                    }
                                    
                                  
                                }
                                else if (doc.s_DocumnetMasterCode == DocType.Shop.rawValue)
                                {
                                    img_shopImage.downloadedFrom(link: url)
                                    {
                                        image in

                                        file.fileName = ImageType.ShopImage.rawValue //right
                                        file.documentName = doc.s_DocumnetMasterCode
                                        file.documentNo = doc.s_DocumnetNo
                                        file.image = image
                                        
                                        for ele in self.arr_fileUpload {
                                            if ele.fileName != nil && ele.fileName == self.imageType.rawValue {
                                                let ind = self.arr_fileUpload.index(of: ele)
                                                self.arr_fileUpload.remove(at: ind!)
                                            }
                                        }
                                        
                                        self.arr_fileUpload.append(file)
                                    }
                                }
                                else if (doc.s_DocumnetMasterCode == DocType.ShopDoc.rawValue)
                                {
//                                    txt_panNo.text = doc.s_DocumnetNo!
                                    img_otherImage.downloadedFrom(link: url)
                                    {
                                        image in
                                  
                                        file.fileName = ImageType.OtherImage.rawValue //right
                                        file.documentName = doc.s_DocumnetMasterCode
//                                        file.documentNo = self.txt_panNo.text//doc.s_DocumnetNo
                                        file.image = image
                                        
                                        for ele in self.arr_fileUpload {
                                            if ele.fileName != nil && ele.fileName == self.imageType.rawValue {
                                                let ind = self.arr_fileUpload.index(of: ele)
                                                self.arr_fileUpload.remove(at: ind!)
                                            }
                                        }
                                        
                                        self.arr_fileUpload.append(file)
                                        
//                                        self.panString = url
                                    }
                                   
                                }
                                else if (doc.s_DocumnetMasterCode == DocType.User.rawValue)
                                {
//                                    txt_panNo.text = doc.s_DocumnetNo!
                                    img_ownerImage.downloadedFrom(link: url)
                                    {
                                        image in
                                  
                                        file.fileName = ImageType.UserProfileImage.rawValue //right
                                        file.documentName = doc.s_DocumnetMasterCode
//                                        file.documentNo = self.txt_panNo.text//doc.s_DocumnetNo
                                        file.image = image
                                        
                                        for ele in self.arr_fileUpload {
                                            if ele.fileName != nil && ele.fileName == self.imageType.rawValue {
                                                let ind = self.arr_fileUpload.index(of: ele)
                                                self.arr_fileUpload.remove(at: ind!)
                                            }
                                        }
                                        
                                        self.arr_fileUpload.append(file)
                                        
//                                        self.panString = url
                                    }
                                   
                                }
                                
                            }
                             print(self.arr_fileUpload)
                        }
                    } else if(callAction == ActionType.Edit) {
                        //                        json.is
                    }
                } catch {
                    print("Decoder Error \(error.localizedDescription)")
                }
            }
        }
        else
        {
            showAlert(msg: parser.responseMessage.uppercased())
        }
    }
}

extension UserProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if  isRgistration == true {
//        return arr_productNameCode.count
//        }else {
//            return appDelegate.arr_productProfile.count
//        }
        if tableView == DistributerTableView{ // Distributor Table view setup
            if items.count == 0 {
                    self.DistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.DistributerTableView.restore()
                }

                return items.count
        }
         if tableView == secDistributerTableView{ // Distributor Table view setup
            if secItems.count == 0 {
                    self.secDistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.secDistributerTableView.restore()
                }

                return secItems.count
        }
         if tableView == thirdDistributerTableView{ // Distributor Table view setup
            if thirdItems.count == 0 {
                    self.thirdDistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.thirdDistributerTableView.restore()
                }

                return thirdItems.count
        }
         if tableView == forthDistributerTableView{ // Distributor Table view setup
            if forthItems.count == 0 {
                    self.forthDistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.forthDistributerTableView.restore()
                }

                return forthItems.count
        }
         if tableView == fifthDistributerTableView{ // Distributor Table view setup
            if fifthItems.count == 0 {
                    self.fifthDistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.fifthDistributerTableView.restore()
                }

                return fifthItems.count
        }
         if tableView == sixDistributerTableView{ // Distributor Table view setup
            if sixItems.count == 0 {
                    self.sixDistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.sixDistributerTableView.restore()
                }

                return sixItems.count
        }
         if tableView == sevenDistributerTableView{ // Distributor Table view setup
            if sevenItems.count == 0 {
                    self.sevenDistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.sevenDistributerTableView.restore()
                }

                return sevenItems.count
        }
         if tableView == eightDistributerTableView{ // Distributor Table view setup
            if eightItems.count == 0 {
                    self.eightDistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.eightDistributerTableView.restore()
                }

                return eightItems.count
        }
         if tableView == nineDistributerTableView{ // Distributor Table view setup
            if nineItems.count == 0 {
                    self.nineDistributerTableView.setEmptyMessage("Select Some Options")
                } else {
                    self.nineDistributerTableView.restore()
                }

                return nineItems.count
        }
        
        return arr_productNameCode.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == DistributerTableView{ // Distributor Table view setup
            let cell = tableView.dequeueReusableCell(withIdentifier: "FstDistributorTableViewCell", for: indexPath) as! FstDistributorTableViewCell

            cell.selectedDistributorLbl.text = items[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(removedSelectedDistributorClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
         if tableView == secDistributerTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecDisTableViewCell", for: indexPath) as! SecDisTableViewCell

            cell.selectedDistributorLbl.text = secItems[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(secRemovedSelectedDistributorClicked(sender:)), for: .touchUpInside)

            
            
            return cell
        }
         if tableView == thirdDistributerTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdDisTableViewCell", for: indexPath) as! ThirdDisTableViewCell

            cell.selectedDistributorLbl.text = thirdItems[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(thirdRemovedSelectedDistributorClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
         if tableView == forthDistributerTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForthDisTableViewCell", for: indexPath) as! ForthDisTableViewCell

            cell.selectedDistributorLbl.text = forthItems[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(forthRemovedSelectedDistributorClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
         if tableView == fifthDistributerTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "fifthDisTableViewCell", for: indexPath) as! fifthDisTableViewCell

            cell.selectedDistributorLbl.text = fifthItems[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(fifthRemovedSelectedDistributorClicked(sender:)), for: .touchUpInside)
           

            return cell
        }
         if tableView == sixDistributerTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SixDisTableViewCell", for: indexPath) as! SixDisTableViewCell

            cell.selectedDistributorLbl.text = sixItems[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(sixRemovedSelectedDistributorClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
         if tableView == sevenDistributerTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SevenDisTableViewCell", for: indexPath) as! SevenDisTableViewCell

            cell.selectedDistributorLbl.text = sevenItems[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(sevenRemovedSelectedDistributorClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
         if tableView == eightDistributerTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EightDisTableViewCell", for: indexPath) as! EightDisTableViewCell

            cell.selectedDistributorLbl.text = eightItems[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(eightRemovedSelectedDistributorClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
         if tableView == nineDistributerTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NineDisTableViewCell", for: indexPath) as! NineDisTableViewCell

            cell.selectedDistributorLbl.text = nineItems[indexPath.row]
            cell.removeselectedDistributorBtn.addTarget(self, action: #selector(nineRemovedSelectedDistributorClicked(sender:)), for: .touchUpInside)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! profileCell
        
//        cell.lbl_profileName.text = arr_productNameCode[indexPath.row].name
        
        
        if isRgistration == true{
        cell.lbl_profileName.text = arr_productNameCode[indexPath.row].name
        cell.txt_selectCat.tag = indexPath.row
        cell.btn_selectCat.tag = indexPath.row
        
        cell.txt_selectType.tag = indexPath.row
        cell.btn_selectType.tag = indexPath.row
        
        cell.arr_productNameCode = self.arr_productNameCode
        cell.productnameCode = arr_productNameCode[indexPath.row]
        }
        else {
            cell.lbl_profileName.text = self.arr_productNameCode[indexPath.row].name
            cell.txt_selectType.text = appDelegate.arr_productProfile[indexPath.row].companyAssociate
            cell.txt_selectCat.text = appDelegate.arr_productProfile[indexPath.row].Category
            cell.txt_selectCat.tag = indexPath.row
            cell.btn_selectCat.tag = indexPath.row
            
            cell.txt_selectType.tag = indexPath.row
            cell.btn_selectType.tag = indexPath.row
            
            cell.arr_productNameCode = self.arr_productNameCode
            cell.productnameCode = arr_productNameCode[indexPath.row]
        }
      
        
        
        return cell

    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
//
//
//
//        headerView.lbl_oderName.numberOfLines = 0
//        headerView.lbl_qty.numberOfLines = 0
//        headerView.lbl_amount.numberOfLines = 0
//
//        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
//
//        headerView.lbl_oderName.font = font
//        headerView.lbl_qty.font = font
//        headerView.lbl_amount.font = font
//        headerView.lbl_oderName.text = hName
//        headerView.lbl_qty.text = hQty
//        let x = hAmount
//       print(x)
//        headerView.lbl_oderName.text = "Profile"
//        headerView.lbl_qty.text = "Associated With USHA As"
//        headerView.lbl_amount.text = "Category"
//
//        return headerView
//    }
    
  //  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as? DemoHeaderView
//        {
//            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
//
//            let font = UIFont.systemFont(ofSize: 12, weight: .medium)
//            let name_height = hName.height(withConstrainedWidth: headerView.lbl_oderName.frame.width, font: font)
//            let qty_height = hQty.height(withConstrainedWidth: headerView.lbl_qty.frame.width, font: font)
//            let amount_height = hName.height(withConstrainedWidth: headerView.lbl_amount.frame.width, font: font)
//
//            let largest = max(max(name_height, qty_height), amount_height)
//
//            return largest + 4
//        }
//        return 50
//    }

    
    
    
}


extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
}

//extension String {
//    func index(from: Int) -> Index {
//        return self.index(startIndex, offsetBy: from)
//    }
//
//    func substring(from: Int) -> String {
//        let fromIndex = index(from: from)
//        return substring(from: fromIndex)
//    }
//
//    func substring(to: Int) -> String {
//        let toIndex = index(from: to)
//        return substring(to: toIndex)
//    }
//
//    func substring(with r: Range<Int>) -> String {
//        let startIndex = index(from: r.lowerBound)
//        let endIndex = index(from: r.upperBound)
//        return substring(with: startIndex..<endIndex)
//    }
//}

extension Array {
    func removingDuplicates<T: Hashable>(byKey key: (Files) -> T)  -> [Files] {
        var result = [Files]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value as! Files)).inserted {
                result.append(value as! Files)
            }
        }
        return result
    }
}
//MARK: DISTRIBUTER TABLE:RB
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 17)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
extension UserProfileViewController : BEMCheckBoxDelegate {
     func didTap(_ checkBox: BEMCheckBox) {
        zipCode = txt_pincode.text!
        if fstCheckbox.on == true{
            print("hello 1")
            fstDiv = "11"
            fstDivName = "Eco. Fan(11)"
            getFstDropDownData(divisionCode: "11", zipcode: zipCode)
        } else {
            fstDiv = ""
            fstDivName = ""
            fstListData.removeAll()
            print("here hello 1")
        }
        if secCheckbox.on == true{
            secDiv = "36"
            secDivName = "EWP(36)"
            getSecDropDownData(divisionCode: "36", zipcode: zipCode)
            print("hello 2")
        } else {
            secDiv = ""
            secDivName = ""
            secListData.removeAll()
            print("here hello 2")
        }
        if thirdCheckbox.on == true{
            threeDiv = "46"
            threeDivName = "H. Comf(46)"
            getThreeDropDownData(divisionCode: "46", zipcode: zipCode)
            print("hello 3")
        } else {
            threeDiv = ""
            threeDivName = ""
            threeListData.removeAll()
            print("here hello 3")
        }
        if forthCheckbox.on == true{
            fourDiv = "41"
            fourDivName = "Iron(41)"
            getFourDropDownData(divisionCode: "41", zipcode: zipCode)
            print("hello 4")
        } else {
            fourDiv = ""
            fourDivName = ""
            fourListData.removeAll()
            print("here hello 4")
        }
        if fifthCheckbox.on == true{
            fiveDiv = "80"
            fiveDivName = "Lighting(80)"
            getFiveDropDownData(divisionCode: "80", zipcode: zipCode)
            print("hello 5")
        } else {
            fiveDiv = ""
            fiveDivName = ""
            fiveListData.removeAll()
            print("here hello 5")
        }
        if sixthCheckbox.on == true{
            sixDiv = "20"
            sixDivName = "SM(20)"
            getSixDropDownData(divisionCode: "20", zipcode: zipCode)
            print("hello 6")
        } else {
            sixDiv = ""
            sixDivName = ""
            sixListData.removeAll()
            print("here hello 6")
        }
        if seventhCheckbox.on == true{
            SevenDiv = "12"
            SevenDivName = "Spl. Fan(12)"
            getSevenDropDownData(divisionCode: "12", zipcode: zipCode)
            print("hello 7")
        } else {
            SevenDiv = ""
            SevenDivName = ""
            sevenListData.removeAll()
            print("here hello 7")
        }
        if eighthCheckbox.on == true{
            EightDiv = "10"
            EightDivName = "Std. Fan(10)"
            getEightDropDownData(divisionCode: "10", zipcode: zipCode)
            print("hello 8")
        } else {
            EightDiv = ""
            EightDivName = ""
            eightListData.removeAll()
            print("here hello 8")
        }
        if ninthCheckbox.on == true{
            NineDiv = "60"
            NineDivName = "WSB(60)"
            getNineDropDownData(divisionCode: "60", zipcode: zipCode)
            print("hello 9")
        } else {
            NineDiv = ""
            NineDivName = ""
            nineListData.removeAll()
            print("here hello 9")
        }
    }
}
