    //
//  MakeOrderViewController.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/25.
//

import UIKit

class MakeOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ordererLabel: UILabel!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkDescriptionLabel: UILabel!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderInfoLabel: UILabel!
    @IBOutlet weak var sentOrderBtn: UIButton!
    @IBOutlet weak var postOrderIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageViewIndicator: UIActivityIndicatorView!
    
    let ordererName:String
    var drinkInfo: DrinkData
    var order = OrderData(drinkName: nil, drinkSize: nil, drinkSugar: nil, drinkIce: nil, addOn: nil, totalPrice: nil)
        
    var optionTypes = OptionTypes.allCases
    
    var size = Array(repeating: false, count: Size.allCases.count)
    var sugar = Array(repeating: false, count: Sugar.allCases.count)
    var ice = Array(repeating: false, count: Ice.allCases.count)
    var addOn = Array(repeating: false, count: AddOn.allCases.count)
    var addOnPrice:Int = 0
    var sizePrice:Int = 0
    var didAddOn:Bool = false
    
    init?(coder:NSCoder, drinkInfo:DrinkData, orderer:String) {
        self.drinkInfo = drinkInfo
        self.ordererName = orderer
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func comfirmOrder(_ sender: Any) {
        
        order.totalPrice = sizePrice + addOnPrice
            
        if let _ = order.drinkName,
           let _ = order.drinkIce,
           let _ = order.drinkSugar,
           let _ = order.drinkSize {
            showComfirmOrderAlertController()
        }else{
            didNotCompleteOrderAlertController()
        }
        
    }
    
    func updateUI() {
        fetchImage()
        order.drinkName = drinkInfo.drink.value
        orderInfoLabel.text = "請選擇飲品份量、甜度、溫度"
        drinkNameLabel.text = drinkInfo.drink.value
        drinkDescriptionLabel.text = drinkInfo.description.value
        ordererLabel.text = "Hello, \(ordererName.capitalized)"
        sentOrderBtn.layer.cornerRadius = sentOrderBtn.frame.width/30
        postOrderIndicatorView.isHidden = true
        optionTableView.reloadData()
    }
    func fetchImage() {
        imageViewIndicator.isHidden = false
        URLSession.shared.dataTask(with: drinkInfo.imageUrl.url) { data, response, error in
            if let data = data{
                DispatchQueue.main.async {
                    self.drinkImageView.image = UIImage(data: data)
                    self.imageViewIndicator.isHidden = true
                }
            }
        }.resume()
    }
    func showComfirmOrderAlertController() {
        let comfirmAlertController = UIAlertController(title: "確認送出訂單", message: "\n\(order.drinkName!), \(order.drinkSize!.rawValue)\n\(order.drinkSugar!.rawValue), \(order.drinkIce!.rawValue)\n加料: \(order.addOn!.rawValue)\n總金額為 $\(order.totalPrice!)", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "確定", style: .default) { (_) in
            self.postOrder()
        }
        let noAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        comfirmAlertController.addAction(yesAction)
        comfirmAlertController.addAction(noAction)
        present(comfirmAlertController, animated: true, completion: nil)
    }
    
    func didNotCompleteOrderAlertController() {
        let controller = UIAlertController(title: "確認是否完整填寫表格", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    func jumpToOrderListController() {
        if let controller = storyboard?.instantiateViewController(identifier: "\(OrderListViewController.self)"){
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
        }
        
    }
    func postOrder() {
        postOrderIndicatorView.isHidden = false
        let orderItem = OrderItem(orderer: ordererName.capitalized,
                                  drinkName: order.drinkName!,
                                  drinkSize: order.drinkSize!.rawValue,
                                  drinkSugar: order.drinkSugar!.rawValue,
                                  drinkIce: order.drinkIce!.rawValue,
                                  addOn: order.addOn!.rawValue,
                                  totalPrice: "\(order.totalPrice!)")
        
        let postOrder = PostOrder(data: orderItem)
        let url = URL(string: "https://sheetdb.io/api/v1/uvbnaxcxrtqr6")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
        if let data = try? JSONEncoder().encode(postOrder){
            urlRequest.httpBody = data
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                //檢查上傳的JSON印出字串
                if let data = data,
                   let content = String(data: data, encoding: .utf8){
                    print(content)
                    DispatchQueue.main.async {
                        self.jumpToOrderListController()
                        self.postOrderIndicatorView.isHidden = true
                    }
                }else{
                    print(error)
                }
            }.resume()
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return optionTypes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let optionType = optionTypes[section]
        switch optionType {
        case .size: return "份量"
        case .sugar: return "甜度"
        case .ice: return "溫度"
        case .addOn: return "加料"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let optionType = optionTypes[section]
        switch optionType {
        case .size:
            if drinkInfo.priceL.value == "無資料" {
                return 1
            }else{
                return Size.allCases.count
            }
            
        case .sugar: return Sugar.allCases.count
        case .ice: return Ice.allCases.count
        case .addOn: return AddOn.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DrinkDetailTableViewCell.self)", for: indexPath) as? DrinkDetailTableViewCell else { return UITableViewCell() }
        
        let optionType = optionTypes[indexPath.section]
        switch optionType {
        case .size:
            let sizeOption = Size.allCases[indexPath.row]
            cell.optionLabel.text = sizeOption.rawValue
            if size[indexPath.row] {
                cell.selectImageView.image = UIImage(systemName: "circle.fill")
            }else{
                cell.selectImageView.image = UIImage(systemName: "circle")
            }
            cell.priceLabel.text = ""
            
        case .sugar:
            let sugarOption = Sugar.allCases[indexPath.row]
            cell.optionLabel.text = sugarOption.rawValue
            if sugar[indexPath.row]{
                cell.selectImageView.image = UIImage(systemName: "circle.fill")
            }else{
                cell.selectImageView.image = UIImage(systemName: "circle")
            }
            cell.priceLabel.text = ""
            
        case .ice:
            let iceOption = Ice.allCases[indexPath.row]
            cell.optionLabel.text = iceOption.rawValue
            if ice[indexPath.row] {
                cell.selectImageView.image = UIImage(systemName: "circle.fill")
            }else{
                cell.selectImageView.image = UIImage(systemName: "circle")
            }
            cell.priceLabel.text = ""
            
        case .addOn:
            let addOnOption = AddOn.allCases[indexPath.row]
            cell.optionLabel.text = addOnOption.rawValue
            if addOnOption == .whiteBubble {
                cell.priceLabel.text = "+$ 10"
            }else{
                cell.priceLabel.text = "+$ 0"
            }
            
            if addOn[indexPath.row] {
                cell.selectImageView.image = UIImage(systemName: "circle.fill")
            }else{
                cell.selectImageView.image = UIImage(systemName: "circle")
            }
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionType = optionTypes[indexPath.section]
        
        switch optionType {
        case .size:
            size = Array(repeating: false, count: Size.allCases.count)
            size[indexPath.row] = !size[indexPath.row]
            if indexPath.row == 0 {
                priceLabel.text = "$ \(drinkInfo.priceM.value)"
                sizePrice = Int(drinkInfo.priceM.value)!
            }else{
                priceLabel.text = "$ \(drinkInfo.priceL.value)"
                sizePrice = Int(drinkInfo.priceL.value)!
            }
            order.drinkSize = Size.allCases[indexPath.row]
            orderInfoLabel.text = "未含加料金額"
            
        case .sugar:
            sugar = Array(repeating: false, count: Sugar.allCases.count)
            sugar[indexPath.row] = !sugar[indexPath.row]
            order.drinkSugar = Sugar.allCases[indexPath.row]
            
        case .ice:
            ice = Array(repeating: false, count: Ice.allCases.count)
            ice[indexPath.row] = !ice[indexPath.row]
            order.drinkIce = Ice.allCases[indexPath.row]
            
        case .addOn:
            addOn = Array(repeating: false, count: AddOn.allCases.count)
            addOn[indexPath.row] = !addOn[indexPath.row]
            order.addOn = AddOn.allCases[indexPath.row]
            
            if order.addOn == .whiteBubble{
                addOnPrice = 10
            }
        }
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
