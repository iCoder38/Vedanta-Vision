//
//  edit_profile.swift
//  Vedanta
//
//  Created by Dishant Rajput on 20/10/22.
//

import UIKit
import Alamofire

import CountryList

class edit_profile: UIViewController , UITextFieldDelegate, CountryListDelegate {
    
    var countryList = CountryList()
    
    var save_country_phone_code:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton! {
        didSet {
            btnDashboardMenu.tintColor = .black
        }
    }
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "CHANGE PASSWORD"
        }
    }
    
    @IBOutlet weak var btn_eye_old_pass:UIButton!
    @IBOutlet weak var btn_eye_pass:UIButton!
    @IBOutlet weak var btn_eye_confirm_pass:UIButton!
    
    @IBOutlet weak var txt_phone_country_code:UITextField! {
        didSet {
//            txt_phone_country_code.setLeftPaddingPoints(24)
            txt_phone_country_code.layer.borderColor = UIColor.lightGray.cgColor
            txt_phone_country_code.layer.borderWidth = 0.8
            txt_phone_country_code.layer.cornerRadius = 8
            txt_phone_country_code.clipsToBounds = true
            txt_phone_country_code.keyboardType = .numberPad
            txt_phone_country_code.textAlignment = .center
            txt_phone_country_code.text = ""
            txt_phone_country_code.placeholder = "+1"
        }
    }
    
    @IBOutlet weak var txt_full_name:UITextField! {
        didSet {
            txt_full_name.setLeftPaddingPoints(24)
            txt_full_name.layer.borderColor = UIColor.lightGray.cgColor
            txt_full_name.layer.borderWidth = 0.8
            txt_full_name.layer.cornerRadius = 8
            txt_full_name.clipsToBounds = true
            txt_full_name.delegate = self
             
        }
    }
    
    @IBOutlet weak var txt_email_address:UITextField! {
        didSet {
            txt_email_address.setLeftPaddingPoints(24)
            txt_email_address.layer.borderColor = UIColor.lightGray.cgColor
            txt_email_address.layer.borderWidth = 0.8
            txt_email_address.layer.cornerRadius = 8
            txt_email_address.clipsToBounds = true
            txt_email_address.delegate = self
            txt_email_address.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var txt_phone:UITextField! {
        didSet {
            txt_phone.setLeftPaddingPoints(24)
            txt_phone.layer.borderColor = UIColor.lightGray.cgColor
            txt_phone.layer.borderWidth = 0.8
            txt_phone.layer.cornerRadius = 8
            txt_phone.clipsToBounds = true
            txt_phone.delegate = self
            txt_phone.keyboardType = .phonePad
             
        }
    }
    
    @IBOutlet weak var txt_password:UITextField! {
        didSet {
            txt_password.setLeftPaddingPoints(24)
            txt_password.layer.borderColor = UIColor.lightGray.cgColor
            txt_password.layer.borderWidth = 0.8
            txt_password.layer.cornerRadius = 8
            txt_password.clipsToBounds = true
            txt_password.delegate = self
            txt_password.text = "********"
        }
    }
    
     
    
    @IBOutlet weak var btnUpdatePassword:UIButton! {
        didSet {
            btnUpdatePassword.layer.cornerRadius = 12
            btnUpdatePassword.clipsToBounds = true
            btnUpdatePassword.setTitle("Edit", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_change_password:UIButton! {
        didSet {
            btn_change_password.layer.cornerRadius = 12
            btn_change_password.clipsToBounds = true
            btn_change_password.setTitle("Change Password", for: .normal)
            btn_change_password.backgroundColor = app_red_orange_mix_color
        }
    }
    
    @IBOutlet weak var btn_password:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow_2), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide_2), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        
        
        self.btnUpdatePassword.addTarget(self, action: #selector(validationBeforeChangePassword), for: .touchUpInside)
        
       
        self.btnDashboardMenu.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        
        countryList.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            print(person)
            
            self.txt_phone.text         = (person["contactNumber"] as! String)
            self.txt_full_name.text     = (person["fullName"] as! String)
            self.txt_email_address.text = (person["email"] as! String)
            self.txt_phone_country_code.text = "+"+(person["country_code"] as! String)
            
            self.save_country_phone_code = (person["country_code"] as! String)
            
            if (person["socialType"] as! String) == "G" {
                self.btn_change_password.backgroundColor = .darkGray
            } else if (person["socialType"] as! String) == "F" {
                self.btn_change_password.backgroundColor = .darkGray
            } else {
                self.btn_change_password.isHidden = false
                self.btn_change_password.addTarget(self, action: #selector(change_password_click_method), for: .touchUpInside)
            }
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
    }
    
    @objc func validationBeforeChangePassword() {
        
        if self.txt_full_name.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Full name should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txt_email_address.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Email should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txt_phone.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Phone should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.changePasswordWB()
        }
        
        
    }
    
    @objc func changePasswordWB() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let parameters = [
                "action"            : "editprofile",
                "userId"            : String(myString),
                "fullName"          : String(self.txt_full_name.text!),
                "contactNumber"     : String(self.txt_phone.text!),
                "country_code"      : String(self.save_country_phone_code),
            ]
            
            AF.request(application_base_url,
                       method: .post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                // debugPrint(response.result)
                
                switch response.result {
                case let .success(value):
                    
                    let JSON = value as! NSDictionary
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = JSON["status"]as Any as? String
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        ERProgressHud.sharedInstance.hide()
                        
                        let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: str_save_login_user_data)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    let alert = UIAlertController(title: String("Error!"), message: String("Server Issue"), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    
    //
    @IBAction func handleCountryList(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    func selectedCountry(country: Country) {
        
        print("\(country.flag!) \(country.name!), \(country.countryCode), \(country.phoneExtension)")
        // self.selectedCountryLabel.text = "\(country.flag!) \(country.name!), \(country.countryCode), \(country.phoneExtension)"
        
        self.txt_phone_country_code.text = "+\(country.phoneExtension)"
        self.save_country_phone_code = "\(country.phoneExtension)"
        
        // self.btn_flag.setTitle("\(country.flag!)", for: .normal)
        
    }
    
}
