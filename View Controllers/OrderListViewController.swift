//
//  OrderListViewController.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/5/1.
//

import UIKit

class OrderListViewController: UIViewController{
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
                    print("error: \(error)")
                }
            }
        }.resume()
    }
    func deleteData(indexPath:IndexPath, order:[String:String]) {
        let orderer = order["orderer"]
        let url = URL(string:"https://sheetdb.io/api/v1/uvbnaxcxrtqr6/orderer/\(orderer!)?limit=1".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data,
               let status = String(data: data, encoding: .utf8){
                DispatchQueue.main.async {
                    print(status)
                    self.fetchData()
                    self.targetList.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }else{
                print("deleteError")
            }
        }.resume()
    }
    
    func computePrice()->Int {
        var result:Int = 0
        targetList.forEach({
            result += Int($0["totalPrice"]!) ?? 0
        })
        return result
    }
    func comfirmDeleteOrderAlert(indexPath: IndexPath,order:[String:String]){
        let controller = UIAlertController(title: "請填入訂購者名稱", message: "英文大小寫需相同", preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.placeholder = "請填入訂購者名稱"
            textField.keyboardType = .default
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let comfirmAction = UIAlertAction(title: "確認", style: .default) { (_) in
            let ordererName = controller.textFields?[0].text
            let targetName = order["orderer"]
            guard ordererName == targetName else {
                return self.failureAlert()
            }
            print("驗證成功")
            self.deleteData(indexPath: indexPath,order: order)
        }
        controller.addAction(comfirmAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    func failureAlert(){
        let controller = UIAlertController(title: "訂購者名稱輸入錯誤", message: "再試一次", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        comfirmDeleteOrderAlert(indexPath: indexPath, order: targetList[indexPath.row])
        
    }
}
