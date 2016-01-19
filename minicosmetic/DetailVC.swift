//
//  DetailVC.swift
//  minicosmetic
//
//  Created by elite on 2016. 1. 13..
//  Copyright © 2016년 yeoeun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DetailVC: UIViewController {
    
    var cosmeticId: Int?
    var cosmeticName: String?
    var cosmeticPrice: Int?
    var cosmeticSales: Int?
    var cosmeticStock: Int?
    var salesStockId: Int?
    var delegate:MainVCDelegate?
    
    @IBOutlet weak var cosName: UILabel!
    @IBOutlet weak var cosmeticPriceLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    @IBOutlet weak var stockNumEdit: UITextField!
    @IBOutlet weak var salesNumEdit: UITextField!
    
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var stockButton: UIButton!

    @IBOutlet weak var sellOKButton: UIButton!
    @IBOutlet weak var stockOKButton: UIButton!
    
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var stockView: UIView!
    
    // @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.cosmeticName
        self.cosName.text = self.cosmeticName
        self.stockLabel.text = "재고 : \(self.cosmeticStock!) 개"
        self.salesLabel.text = "판매 : \(self.cosmeticSales!) 개"
        
        self.stockView.hidden = true
        self.stockButton.setTitleColor(UIColor(red: 0.3, green: 0.3, blue: 0.9, alpha: 0.5), forState: UIControlState.Normal)

        let getCosmeticInfoURL = "http://ye-project.dev/cosms/\(self.cosmeticId!).json"
        
        // DETAIL
        Alamofire.request(.GET, getCosmeticInfoURL).responseJSON {
            
            response in
            
            print("--request  : \(response.request)")  // original URL request
            print("--response : \(response.response)") // URL response
            // print("--data     : \(response.data)")     // server data
            print("--result   : \(response.result)")   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                // array 형태가 아니기 때문에 모델 만들어서 for문 돌릴 필요 X
                if let cosmetic = JSON as? NSDictionary {
                    self.cosmeticPrice = cosmetic["price"] as? Int
                    
                    print(self.cosmeticPrice)
                    self.cosmeticPriceLabel.text = String(self.cosmeticPrice!)
                }
            }
        }        
    }
 
    @IBAction func touch1(sender: AnyObject) { //1
        self.stockView.hidden = true
        self.sellView.hidden = false
        self.stockButton.setTitleColor(UIColor(red: 0.3, green: 0.3, blue: 0.9, alpha: 0.5), forState: UIControlState.Normal)
        self.sellButton.setTitleColor(UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0), forState: UIControlState.Normal)
    }
    
    @IBAction func touch2(sender: AnyObject) { //2
        self.stockView.hidden = false
        self.sellView.hidden = true
        self.stockButton.setTitleColor(UIColor(red: 0.3, green: 0.3, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
        self.sellButton.setTitleColor(UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.5), forState: UIControlState.Normal)
    }
    
    @IBAction func touchSell(sender: AnyObject) {
        self.delegate?.refreshData!()
        
        let parameters = ["sales_volume" : salesNumEdit.text!]
        let putVolumeURL = "http://ye-project.dev/shops/4/sales_stocks/\(self.salesStockId!).json"
        
        Alamofire.request(.PUT, putVolumeURL, parameters: parameters, encoding:.JSON)
            .responseJSON {
                response in
                
                print("--request  : \(response.request)")  // original URL request
                print("--response : \(response.response)") // URL response
                // print("--data     : \(response.data)")     // server data
                print("--result   : \(response.result)")   // result of response serialization
        }

        // navigationController?.popViewControllerAnimated(true) // pop
        navigationController?.popToRootViewControllerAnimated(true) // popToRoot
    }
    
    @IBAction func touchStock(sender: AnyObject) {
        self.delegate?.refreshData!()
        
        let parameters = ["order_volume" : stockNumEdit.text!]
        let putVolumeURL = "http://ye-project.dev/shops/4/sales_stocks/\(self.salesStockId!).json"

        Alamofire.request(.PUT, putVolumeURL, parameters: parameters, encoding:.JSON)
            .responseJSON {
            response in
            
            print("--request  : \(response.request)")  // original URL request
            print("--response : \(response.response)") // URL response
            // print("--data     : \(response.data)")     // server data
            print("--result   : \(response.result)")   // result of response serialization
        }
         navigationController?.popToRootViewControllerAnimated(true) // popToRoot
    }
    
    
    
    
}