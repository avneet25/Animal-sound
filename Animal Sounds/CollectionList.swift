//
//  CollectionList.swift
//  Animal Sounds
//
//  Created by Kalpit Patil on 2021-05-20.
//

import UIKit

class CollectionList: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //contains particular categories. id - list
    var particularCategory = [String:Any]()
    var idArr = [Int]()
    var Id = Int()
    //all data list
    var dataList = [[String:Any]]()
    var nameArr = [String]()
    var urlArr = [String]()
    var size: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        self.title = particularCategory["name"] as! String
    }
    
    func getData(){
        idArr = particularCategory["ids"] as! [Int]
        print(idArr)
        size = idArr.count
        
        for i in 0..<size {
            for j in 0..<dataList.count
            {
                let partiData = dataList[j]
                if idArr[i] == partiData["id"] as! Int
                {
                    nameArr.append(partiData["name"] as! String)
                    urlArr.append(partiData["imgurl"] as! String)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.view.frame.width - 36)/2, height: (self.view.frame.width - 36)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryListCell", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.black.cgColor
    
        
        cell.lbl2.text = nameArr[0]
        
        nameArr.remove(at: 0)
    
        cell.img2.sd_setImage(with: URL.init(string: urlArr[0])) { img,
                error, cache, url in
        
                    cell.loader2.stopAnimating()
                    cell.loader2.isHidden = true
                }
        urlArr.remove(at: 0)
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Id = idArr[indexPath.row]
        performSegue(withIdentifier: "partiSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "partiSegue"{
            let vc2 = segue.destination as! PartiAnimal
            vc2.id = Id
            vc2.dataList = dataList
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
