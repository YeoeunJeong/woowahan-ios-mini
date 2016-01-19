//
//  MainVC.swift
//  minicosmetic
//
//  Created by elite on 2016. 1. 12..
//  Copyright © 2016년 yeoeun. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

@objc protocol MainVCDelegate {
    optional func refreshData()
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MainVCDelegate {
    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var cosmeticListArray = [CosmeticListModel]()
    var shopId:String?
    var shopName:String?
    var shopBrandName:String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getShopInfo()
        refreshData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return cosmeticListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MainTableViewCell
        
        cell.nameLabel.text = self.cosmeticListArray[indexPath.row].cosmeticName
        cell.salesLabel.text = String(self.cosmeticListArray[indexPath.row].salesVolume! as Int)
        
        // 재고 주문이 있으면 재고량과 함께 표시 // 재고량 (재고 주문량)
        if (self.cosmeticListArray[indexPath.row].orderVolume != 0) {
            cell.stockLabel.text = "\(self.cosmeticListArray[indexPath.row].stockVolume! as Int) (\(self.cosmeticListArray[indexPath.row].orderVolume!))"
        } else {
            cell.stockLabel.text = String(self.cosmeticListArray[indexPath.row].stockVolume! as Int)
        }
        
        // 재고가 0개이면 붉은 글자로 표시
        if (self.cosmeticListArray[indexPath.row].soldOut == true) {
            print("*** \(self.cosmeticListArray[indexPath.row].soldOut)")
            cell.stockLabel.textColor = UIColor.redColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
        
        vc.cosmeticName = self.cosmeticListArray[indexPath.row].cosmeticName
        vc.cosmeticId = self.cosmeticListArray[indexPath.row].cosmeticId
        vc.cosmeticSales = self.cosmeticListArray[indexPath.row].salesVolume
        vc.cosmeticStock = self.cosmeticListArray[indexPath.row].stockVolume
        vc.salesStockId = self.cosmeticListArray[indexPath.row].id
        vc.delegate = self
        
        print("***cosmeticName \(vc.cosmeticName)")
        print("You did selected cell #\(indexPath.row)!")

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getShopInfo() {
        shopId = String(4)
        let getShopInfoURL = "http://ye-project.dev/shops/\(shopId!).json"
        
        Alamofire.request(.GET, getShopInfoURL).responseJSON {
            response in
            
            print("--request  : \(response.request)")  // original URL request
            print("--response : \(response.response)") // URL response
            // print("--data     : \(response.data)")     // server data
            print("--result   : \(response.result)")   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                // array 형태가 아니기 때문에 모델 만들어서 for문 돌릴 필요 X
                if let shop = JSON as? NSDictionary {
                    self.shopName = shop["name"] as? String
                    self.shopBrandName = shop["brand"]!["name"] as? String
                    
                    self.shopNameLabel.text = "\(self.shopBrandName!) \(self.shopName!)"
                    print("*** \(self.shopNameLabel.text)")
                }
            }
        }

    }
    
    func refreshData() {
        cosmeticListArray.removeAll()
        shopId = String(4)
        let url = "http://ye-project.dev/shops/\(shopId!)/sales_stocks.json"
        // MAIN
        Alamofire.request(.GET, url).responseJSON {
            response in
            
            print("--request  : \(response.request)")  // original URL request
            print("--response : \(response.response)") // URL response
            // print("--data     : \(response.data)")     // server data
            print("--result   : \(response.result)")   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                if let cosmetics = JSON as? NSArray {
                    
                    for cosmetic in cosmetics {
                        if let dict = cosmetic as? NSDictionary {
                            
                            let cosmeticModel = CosmeticListModel()
                            cosmeticModel.id = dict["id"] as? Int
                            cosmeticModel.cosmeticName = dict["cosmetic"]!["name"] as? String
                            cosmeticModel.cosmeticId = dict["cosmetic"]!["id"] as? Int
                            cosmeticModel.cosmeticGender = dict["cosmetic"]!["gender"] as? Int
                            cosmeticModel.cosmeticUse = dict["cosmetic"]!["use"] as? Int
                            cosmeticModel.stockVolume = dict["stock_volume"] as? Int
                            cosmeticModel.salesVolume = dict["sales_volume"] as? Int
                            cosmeticModel.orderVolume = dict["order_volume"] as? Int
                            cosmeticModel.soldOut = dict["sold_out"] as? Bool
                            
                            self.cosmeticListArray.append(cosmeticModel)
                        }
                    }
                    //테이블 데이터가 다 들어왔으므로 리로드!
                    self.tableView.reloadData()
                }
            }
        }
        
        print("refresh Data!")
    }
    
    
    
}