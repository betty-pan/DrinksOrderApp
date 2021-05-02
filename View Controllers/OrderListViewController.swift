//
//  OrderListViewController.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/5/1.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var targetList:[[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        updateUI()
    }
    func updateUI() {
        footerView.layer.cornerRadius = footerView.frame.width / 20
    }
    func fetchData() {
        indicatorView.isHidden = false
        let url = URL(string: "https://sheetdb.io/api/v1/uvbnaxcxrtqr6")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: urlRequest) {data, response, error in
            let decoder = JSONDecoder()
            if let data = data{
                do {
                    let searchResponse = try decoder.decode([[String:String]].self, from: data)
                    self.targetList = searchResponse
                    DispatchQueue.main.async {
                        self.targetList = searchResponse
                        self.totalAmountLabel.text = "共計\(self.targetList.count)杯"
                        self.totalPriceLabel.text = "$\(self.computePrice())"
                        self.indicatorView.isHidden = true
                        self.tableView.reloadData()
                        
                    }
                } catch {
                    print(error)
                }
                
            }
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)", for: indexPath) as? OrderListTableViewCell else { return UITableViewCell() }
        
        let drinkInfo = targetList[indexPath.row]
        cell.drinkNameLabel.text = drinkInfo["drinkName"]!
        cell.drinkInfoLabel.text = "\(drinkInfo["drinkSize"]!)、\(drinkInfo["drinkSugar"]!)、\(drinkInfo["drinkIce"]!)、\(drinkInfo["addOn"]!)"
        cell.priceLabel.text = "$\(drinkInfo["totalPrice"]!)"
        cell.ordererLabel.text = drinkInfo["orderer"]!
        
        return cell
    }
    
    
    func computePrice()->Int {
        var result:Int = 0
        targetList.forEach({
            result += Int($0["totalPrice"]!) ?? 0
        })
        return result
    }

}

