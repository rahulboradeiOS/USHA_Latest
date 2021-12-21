//
//  AddBankAccountViewController.swift
 
//
//  Created by Apple.Inc on 11/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire

class AddBankAccountViewController: BaseViewController
{
    @IBOutlet weak var lbl_addNewBankD: UILabel!
    @IBOutlet weak var lbl_noteAdd: UILabel!
    @IBOutlet weak var lcl_chq: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view_addBank: UIView!
    @IBOutlet weak var txt_selectBank: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_bankAccountNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_IFSCCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_bankName: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_bankAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_accountHolderName: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_check: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_checkUpload: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_selectBank: UIButton!
    @IBOutlet weak var img_check: UIImageView!
    
    let imgPicker : UIImagePickerController = UIImagePickerController()
    
    var is_imageUpload : Bool = Bool()
    var uplodImage:UIImage!
    //var imgUrl:URL!
    
    let action = API.InsertUpdateUserBankDetails
    
    var alertTag = 0
    
    var bankId = ""
    var userCode = ""
    var addedSuccessfully = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        //print(DataProvider.sharedInstance.userDetails.s_ShopName!)
        
        btn_submit.layer.cornerRadius = 20
        btn_submit.layer.masksToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        txt_bankAccountNo.delegate = self
        txt_bankAccountNo.updateLengthValidationMsg("bankAccountEmpty".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        txt_bankAccountNo.addRegx(accountNoRegEx, withMsg: "bankAccountNo10_25".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        
        txt_IFSCCode.delegate = self
        txt_IFSCCode.updateLengthValidationMsg("ifscEmpty".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        txt_IFSCCode.addRegx(ifscRegEx, withMsg: "invalidIFSC".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        txt_bankName.updateLengthValidationMsg("bankNameEmpty".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        txt_bankAddress.updateLengthValidationMsg("bankAddressEmpty".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        txt_accountHolderName.updateLengthValidationMsg("accountHolderNameEmpty".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        
        txt_bankAddress.delegate = self
        txt_accountHolderName.delegate = self
        txt_bankName.delegate = self

        addReginTapGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LanguageChanged(strLan:keyLang)
        
        
    }
    func LanguageChanged(strLan:String){
        lbl_addNewBankD.text = "Add New Bank Details".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_noteAdd.text = "Note: Max Upload Document Size should not greater than 3 MB. Only image formats (jpg, tif, png, gif) are accepted".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        lcl_chq.text = "ACCUMULATION SUMMARY".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        btn_submit.setTitle("SUBMIT NEW BANK DETAILS".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        btn_checkUpload.setTitle("UPLOAD".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        exitAlert()
    }
    
    @IBAction func btn_Back_pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_checkUpload_pressed(_ sender: UIButton)
    {
        self.askToChangeImage()
    }
    
    @IBAction func btn_cancel_pressed(_ sender: UIButton)
    {
    }
    
    override func onHomeButtonPressed(_ sender: UIButton) {
        exitAlert()
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
    @objc func YESPRESSED(alert: UIAlertAction!)
    {
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
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
    @IBAction func btn_submit_pressed(_ sender: UIButton)
    {
        if(isItemValid())
        {
            checkIMEI()
        }
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
    
    @objc func noPressed(alert: UIAlertAction!)
    {
        
    }
    
    func isItemValid() -> Bool
    {
        if(Connectivity.isConnectedToInternet())
        {
            if(txt_bankAccountNo.validate())
            {
                if(txt_IFSCCode.validate())
                {
                    if(txt_bankName.validate())
                    {
                        if(txt_bankAddress.validate())
                        {
                            if(txt_accountHolderName.validate())
                            {
                                let holderName = txt_accountHolderName.text?.lowercased()
                                let shopName = DataProvider.sharedInstance.userDetails.s_ShopName!.lowercased()
                                let fullName = DataProvider.sharedInstance.userDetails.s_FullName!.lowercased()
                                if ((holderName == shopName) || (holderName == fullName))
                                {
                                    if (uplodImage != nil)
                                    {
                                        if let imageData = uplodImage.jpeg(.medium)
                                        {
                                            let bcf = ByteCountFormatter()
                                            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                                            bcf.countStyle = .file
                                            let string = bcf.string(fromByteCount: Int64(imageData.count))
                                            print("formatted result: \(string)")
                                            
                                            let imageSize: Int = imageData.count
                                            let kb = Double(imageSize) / 1024.0
                                            let mb = kb / 1024
                                            if mb > 3
                                            {
                                                showAlert(msg: "imageSize".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!))
                                                return false
                                            }
                                            else
                                            {
                                                return true
                                            }
                                        }
                                        else
                                        {
                                            return false
                                        }
                                    }
                                    else
                                    {
                                        showAlert(msg: "selectChequesImage".localizableString(loc:
                                            UserDefaults.standard.string(forKey: "keyLang")!))
                                        return false
                                    }
                                }
                                else
                                {
                                    showAlert(msg: "chqName".localizableString(loc:
                                        UserDefaults.standard.string(forKey: "keyLang")!))
                                    return false
                                }
                            }
                            else
                            {
                                showAlert(msg: txt_accountHolderName.strMsg)
                                return false
                            }
                        }
                        else
                        {
                            showAlert(msg: txt_bankAddress.strMsg)
                            return false
                        }
                    }
                    else
                    {
                        showAlert(msg: txt_bankName.strMsg)
                        return false
                    }
                }
                else
                {
                    showAlert(msg: txt_IFSCCode.strMsg)
                    return false
                }
            }
            else
            {
                showAlert(msg: txt_bankAccountNo.strMsg)
                return false
            }
        }
        else
        {
            showAlert(msg: "NEED INTERNET CONNECTIVITY TO ADD BANK DETAILS")
            return false
        }
    }

    
    func uploadCheque(bankId:String, usercode:String)
    {
        let imgName = "\(bankId)_\(usercode)_BlankCheque.jpg"
        if let imageData = uplodImage.jpeg(.medium)
        {
            let urlStr = "\(baseUrl)EmployeeUser/BankRegistrationUploadFile"
            let url = try! URLRequest(url: urlStr, method: .post, headers: headers)
            
            let parameters = ["name": imgName] //Optional for extra parameter

            presentWindow?.makeToastActivity(message: "Uploading...")
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "", fileName: imgName, mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                } //Optional for extra parameters
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
                        self.showAlert(msg: self.addedSuccessfully)
                        //self.showAlert(msg: MessageAndError.imageUploaded)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddBankAccountViewController
{
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if api == API.InsertUpdateUserBankDetails
        {
            if let responseData = parser.responseData as? String
            {
                if responseData != ""
                {
                    bankId = responseData
                    addedSuccessfully = parser.responseMessage
                    //self.view.makeToast(message: parser.responseMessage)
                    let imgName = "\(bankId)_\(userCode)_BlankCheque.jpg"
                    txt_check.text = imgName
                    uploadCheque(bankId: bankId, usercode: userCode)
                    //alertTag = 1
                    //showAlert(msg: parser.responseMessage)
                }
                else
                {
                    showAlert(msg: parser.responseMessage)
                }
            }
        }
    }
    
    override func onOkPressed(alert: UIAlertAction!) {
        if alertTag == 1
        {
            let imgName = "\(bankId)_\(userCode)_BlankCheque.jpg"
            txt_check.text = imgName
            uploadCheque(bankId: bankId, usercode: userCode)
        }
        else if alertTag == 3
        {
            self.navigationController?.popViewController(animated: true)
        }
        else if alertTag == -1
        {
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
        else if alertTag == 2
        {
            //exit(0)
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
    }
    
    func didRecivedInsertUpdateUserBankDetails()
    {
    }
    
    func didRecivedAppCredentailFali(msg: String)
    {
        alertTag = -1
        showAlert(msg: msg)
    }
    
    override func didRecivedAppCredentail(parser:Parser, appVersion: String, mobileNumber: String, isIMEIExit: Bool, status: String, userCode: String, userStatus: String, usertype: String, actionType: String, isForceUpdate:String,isVerify : String)
    {
        if actionType == ActionType.CheckIMEI
        {
            if (isIMEIExit)
            {
                let userStatus = Parser.checkUsertType(usertype: usertype, userStatus: userStatus, viewController: self)
                if (userStatus.0)
                {
                    if action == API.InsertUpdateUserBankDetails
                    {
                        self.userCode = userCode
                        InsertUpdateUserBankDetails(userCode: userCode)
                    }
                }
                else
                {
                    if(userStatus.1 != 1)
                    {
                        alertTag = userStatus.1
                    }
                }
            }
            else
            {
                showWrongUDIDAlert()
            }
        }
    }
    
    func InsertUpdateUserBankDetails(userCode:String)
    {
        let parameters:Parameters = [Key.ActionTypes : ActionType.Insert,  Key.DocCode : "DOC003", Key.CodeType : "User", Key.UserCode : userCode, Key.CreatedBy : DataProvider.sharedInstance.userDetails.s_CreatedBy!, Key.BankAccNo : txt_bankAccountNo.text!, Key.IFSCCode : txt_IFSCCode.text!, Key.BankName : txt_bankName.text!, Key.BankAddress : txt_bankAddress.text!, Key.NomeOf_AccHolder : txt_accountHolderName.text!, Key.SourceName : Source]
        
        print(parameters)
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.InsertUpdateUserBankDetails, parameters: parameters, viewcontroller: self, actionType: API.InsertUpdateUserBankDetails)
    }
}



extension AddBankAccountViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count - range.length

        if textField == txt_bankAccountNo
        {
            let currentCharacterCount = textField.text?.count ?? 0
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 25
        }
        else if textField == txt_IFSCCode
        {
            
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
//            //return (string == filtered)

           
            //return newLength <= 11
            
            if(string == filtered && newLength <= 11)
            {
                return true
            }
            else
            {
                return false
            }
        }
        else if ((textField == txt_bankName) || (textField == txt_accountHolderName))
        {
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-.&,"
            
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered && newLength <= 50)
            
//
//            let set = CharacterSet.init(charactersIn: notAllowedCharacters)
//            let inverted = set.inverted;
//
//            let filtered = string.components(separatedBy: inverted).joined(separator: "")
//            return filtered == string;
        }
//        else if (textField == txt_accountHolderName)
//        {
//            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz."
//
//            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
//            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
//            return (string == filtered)
//
//            //
//            //            let set = CharacterSet.init(charactersIn: notAllowedCharacters)
//            //            let inverted = set.inverted;
//            //
//            //            let filtered = string.components(separatedBy: inverted).joined(separator: "")
//            //            return filtered == string;
//        }
        else if textField == txt_bankAddress
        {
            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-./&,"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered && newLength <= 50)
        }
        else
        {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        _ = textField.resignFirstResponder()
        return true
    }
    
}

//TODO: - Camera, UIImagePickerDelegate Methods

extension AddBankAccountViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    /**
     Action sheet to give choice for photo selection
     */
    func askToChangeImage()
    {
        
        let alertImage = UIAlertController(title: "Let's get a picture", message: "Choose a picture upload method", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        self.imgPicker.delegate = self
        
        if(is_imageUpload){
            let removeImageButton = UIAlertAction(title: "Remove Picture", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
                self.is_imageUpload = false
                self.uplodImage = nil
            }
            alertImage.addAction(removeImageButton)
        }else{
            print("No image is selected")
        }
        
        //Add AlertAction to select image from library
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            
            self.imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imgPicker.delegate = self
            self.present(self.imgPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                
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
            txt_check.text = "BlankCheque"
                
//            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
//            imgUrl = imageURL as URL? //imageURL.absoluteString
//            txt_check.text = imageURL.absoluteString
            uplodImage = image
            img_check.image = uplodImage

            //self.uploadImage(image: image)
            //self.updateDP(image: image)
            //self.uplodDP(image: image)
        } else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
        //        self.dismiss(animated: true, completion: { isFinish in
        //        })
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!)
    {
        if let image = image{ //info[UIImagePickerControllerOriginalImage] as? UIImage {
            uplodImage = image
            txt_check.text = "BlankCheque"
            img_check.image = uplodImage
            //self.uploadImage(image: image)
            //self.updateDP(image: image)
            //self.uplodDP(image: image)
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: { () -> Void in
        })
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        is_imageUpload = false
        dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

