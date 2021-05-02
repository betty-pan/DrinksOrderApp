//
//  EnterNameSceneViewController.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/24.
//

import UIKit

class EnterNameSceneViewController: UIViewController {
    @IBOutlet weak var enterNameTextField: UITextField!
    @IBOutlet weak var enterBtn: UIButton!
    @IBAction func unwindToMainScene(_ unwindSegue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterBtn.layer.cornerRadius = enterBtn.frame.height/15
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkIfUserDidEnterName(_ sender: Any) {
        //判斷有無輸入訂購者名稱
        if enterNameTextField.text?.isEmpty == true {
            didNotEnterNameAlert()
        }else{
            jumpToMenuViewController()
        }
    }
    @IBAction func toOrderListScene(_ sender: Any) {
        jumpToOrderListController()
    }
    
    
    func didNotEnterNameAlert() {
        let alertController = UIAlertController(title: "請輸入訂購者名稱", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "確認", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    func jumpToMenuViewController() {
        if let controller = storyboard?.instantiateViewController(identifier: "\(MenuSceneViewController.self)", creator: { coder in
            MenuSceneViewController(coder: coder, orderer: self.enterNameTextField.text!)
            
        }){
            controller.modalPresentationStyle = .fullScreen
            show(controller, sender: nil)
        }
    }
    func jumpToOrderListController() {
        if let controller = storyboard?.instantiateViewController(identifier: "\(OrderListViewController.self)"){
            show(controller, sender: nil)
        }
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
