//
//  MenuSceneViewController.swift
//  DrinksOrderApp
//
//  Created by Betty Pan on 2021/4/25.
//

import UIKit

private let reuseIdentifier = "\(DrinksCollectionViewCell.self)"

class MenuSceneViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let orderer:String
    var menuInfo:Menu?
    var items = [DrinkData]()
    
    
    init?(coder:NSCoder, orderer:String) {
        self.orderer = orderer
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    @IBAction func changeDrink(_ sender: UIButton) {
        if sender.currentTitle == "經典飲品"{
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(named: "Color")?.cgColor
            sender.backgroundColor = UIColor.clear
            sender.setTitleColor(UIColor(named: "Color"), for: .normal)
        }
    }
    @IBSegueAction func goToMakeOrderScene(_ coder: NSCoder) -> MakeOrderViewController? {
        guard let row = collectionView.indexPathsForSelectedItems?.first?.row else { return nil}
        return MakeOrderViewController(coder: coder, drinkInfo: items[row], orderer: orderer)
    }
    
    func fetchData() {
        let urlStr = "https://spreadsheets.google.com/feeds/list/1NkOirEn0w0QNnsWBEbu8sMOJ5OFREgKK2H9vVkEb8c4/od6/public/values?alt=json"
        if let url = URL(string: urlStr){
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
//                self.decodeDate(decoder: decoder)
                if let data = data {
                    do {
                        let searchResponse = try decoder.decode(Menu.self, from: data)
                        self.menuInfo = searchResponse
                        DispatchQueue.main.async {
                            self.items = searchResponse.feed.entry
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    func decodeDate(decoder:JSONDecoder){
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom({ (decoder)-> Date in
            let container = try decoder.singleValueContainer()
            let dateStri = try container.decode(String.self)
            if let date = dateFormatter.date(from: dateStri){
                return date
            }else{
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
            }
        })
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DrinksCollectionViewCell else {return UICollectionViewCell()}
        
        let item = items[indexPath.row]
        cell.drinkImageView.image = UIImage(named: "")
        //fetchDrinkImage
        URLSession.shared.dataTask(with: item.imageUrl.url) { data, response, error in
            if let data = data{
                DispatchQueue.main.async {
                    cell.drinkImageView.image = UIImage(data: data)
                    cell.indicatorView.isHidden = true
                }
            }
        }.resume()
        cell.drinkNameLabel.text = item.drink.value
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(MenuCollectionReusableHeaderView.self)", for: indexPath) as? MenuCollectionReusableHeaderView else { return UICollectionReusableView() }
        
        return reusableView
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
