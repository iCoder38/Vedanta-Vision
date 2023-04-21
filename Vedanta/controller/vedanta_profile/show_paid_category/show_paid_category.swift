//
//  show_paid_category.swift
//  Vedanta
//
//  Created by Dishant Rajput on 21/10/22.
//

import UIKit
import Alamofire
import SDWebImage

class show_paid_category: UIViewController {
    
    var str_catgory_id:String!
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    var arr_mut_video_list:NSMutableArray! = []
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .black
        }
    }
    
    @IBOutlet weak var tble_view:UITableView! {
        didSet {
            
            tble_view.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var view_full_view:UIView! {
        didSet {
            view_full_view.backgroundColor = UIColor.init(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view_full_view.backgroundColor = app_BG_color
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 250.0/255.0, green: 250.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        self.tble_view.separatorColor = .clear
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.create_custom_array()
        
    }
    
    @objc func create_custom_array() {
        
        self.arr_mut_video_list.removeAllObjects()
        self.video_list_without_like_WB(page_number: 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.tble_view {
            let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    self.video_list_without_like_WB(page_number: page)
                    
                }
            }
        }
    }
    
    // MARK: - WEBSERVICE ( VIDEO LIST ) -
    
    
    // MARK: - WEBSERVICE ( VIDEO LIST ) -
    @objc func video_list_without_like_WB(page_number:Int) {
        self.view.endEditing(true)
        
        if page_number == 1 {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        if IsInternetAvailable() == false {
            self.please_check_your_internet_connection()
            return
        }
         
        let parameters = [
            "action"        : "videolist",
            "pageNo"        : page_number,
            "forHomePage"   : "",
            "categoryId"    : String(self.str_catgory_id),
            "Type"          : "2"
            
        ] as [String : Any]
        
        print(parameters as Any)
        
        AF.request(application_base_url, method: .post, parameters: parameters)
        
            .response { response in
                
                do {
                    if response.error != nil{
                        print(response.error as Any, terminator: "")
                    }
                    
                    if let jsonDict = try JSONSerialization.jsonObject(with: (response.data as Data?)!, options: []) as? [String: AnyObject]{
                        
                        print(jsonDict as Any, terminator: "")
                        
                        // for status alert
                        var status_alert : String!
                        status_alert = (jsonDict["status"] as? String)
                        
                        // for message alert
                        var str_data_message : String!
                        str_data_message = jsonDict["msg"] as? String
                        
                        if status_alert.lowercased() == "success" {
                            
                            print("=====> yes")
                            ERProgressHud.sharedInstance.hide()
                            
                            
                            /*
                             Link = "https://youtu.be/ro4nbpLbBa0";
                             Type = 2;
                             categoryId = 36;
                             created = "Oct 7th, 2022, 1:45 pm";
                             description = "The World You See Is a Projection, Not a Creation";
                             homePage = 1;
                             image = "";
                             title = "The World You See Is a Projection, Not a Creation";
                             videoFile = "";
                             videoId = 1;
                             youLiked = Yes;
                             */
                            
                            
                            
                            var ar : NSArray!
                            ar = (jsonDict["data"] as! Array<Any>) as NSArray
                            self.arr_mut_video_list.addObjects(from: ar as! [Any])
                            
                            print(self.arr_mut_video_list as Any)
                            
                            self.tble_view.delegate = self
                            self.tble_view.dataSource = self
                            self.tble_view.reloadData()
                            self.loadMore = 1
                            
                        } else {
                            
                            print("=====> no")
                            ERProgressHud.sharedInstance.hide()
                            
                            let alert = NewYorkAlertController(title: String(status_alert), message: String(str_data_message), style: .alert)
                            let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                        }
                        
                    } else {
                        
                        self.please_check_your_internet_connection()
                        
                        return
                    }
                    
                } catch _ {
                    print("Exception!")
                    ERProgressHud.sharedInstance.hide()
                    print(response.error as Any, terminator: "")
                }
            }
        
    }
    
    
    
    
    
    
    
}


extension show_paid_category : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_video_list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:show_paid_category_table_cell = tableView.dequeueReusableCell(withIdentifier: "show_paid_category_table_cell") as! show_paid_category_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_video_list[indexPath.row] as? [String:Any]
        print(item as Any)
        
        cell.img_view_list.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_view_list.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        cell.lbl_title.text = (item!["title"] as! String)
        cell.lbl_list_description.text = (item!["description"] as! String)
        
        
        
        // cell.btn_like.tag = indexPath.row
        // cell.btn_like.addTarget(self, action: #selector(like_click_method), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_mut_video_list[indexPath.row] as? [String:Any]
        
        if "\(item!["Type"]!)" == "2" {
            
            self.push_to_video_screen(str_video_file_link: (item!["Link"] as! String),
                                      str_video_title: (item!["title"] as! String))
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /*let item = self.arr_mut_video_list[indexPath.row] as? [String:Any]
         
         if (item!["status"] as! String) == "header" {
         return UITableView.automaticDimension
         } else if (item!["status"] as! String) == "title" {
         return 50
         } else {*/
        return 130
        // }
        
    }
    
}

class show_paid_category_table_cell:UITableViewCell {
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 4
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 8
            view_bg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var img_view:UIImageView! {
        didSet {
            img_view.layer.cornerRadius = 8
            img_view.clipsToBounds = true
            img_view.backgroundColor = UIColor.init(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lbl_header_video_title:UILabel!
    @IBOutlet weak var lbl_header_date:UILabel!
    @IBOutlet weak var lbl_header_description:UILabel! {
        didSet {
            lbl_header_description.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        }
    }
    
    @IBOutlet weak var img_view_list:UIImageView! {
        didSet {
            img_view_list.layer.cornerRadius = 8
            img_view_list.clipsToBounds = true
            img_view_list.backgroundColor = UIColor.init(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_list_description:UILabel!
    
    @IBOutlet weak var btn_like:UIButton!
    
    @IBOutlet weak var btn_play:UIButton!
    
}
