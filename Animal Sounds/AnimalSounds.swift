//
//  ViewController.swift
//  Animal Sounds
//
//  Created by Kalpit Patil on 2021-05-20.
//

import UIKit
import Alamofire
import SDWebImage

class AnimalSounds: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    let apiUrl = "https://www.dropbox.com/s/gw049r6gszx82f8/Animal_Sound.json?dl=1"
    
    var category = [[String:Any]]()
    var data = [[String:Any]]()
    var tempPartiCatgry = [String:Any]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        AF.request(apiUrl).responseJSON { [self] result in
            if let value = result.value {
                let animal = value as! [String:Any]
                data = animal["data"] as! [[String : Any]]
                category = animal["category"] as! [[String : Any]]
            }
            collectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.view.frame.width - 36)/2, height: (self.view.frame.width - 36)/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.black.cgColor
        
        let partiCategory = category[indexPath.row]
        cell.lbl.text = partiCategory["name"] as? String
    
        let imgUrl = partiCategory["img"] as! String
        cell.img.sd_setImage(with: URL.init(string: imgUrl)) { img,
        error, cache, url in
            
            cell.loader.stopAnimating()
            cell.loader.isHidden = true
        }
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let idsArr = category[indexPath.row]["ids"] as! [Int]
//        print(idsArr)
//
//
//        let filter = data.filter { idsArr.contains($0["id"] as! Int)   }
//        print(filter)
        
            tempPartiCatgry = category[indexPath.row]
        performSegue(withIdentifier: "listSegue", sender: nil)
   
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listSegue"{
            let vc = segue.destination as! CollectionList

            vc.dataList = data
            vc.particularCategory = tempPartiCatgry
        
          
        }
        else if segue.identifier == "downloadSegue"{
            let vc = segue.destination as! DownloadVC
            vc.datalist = data
        }
    }
    @IBAction func downloadAction(_ sender: Any) {
        performSegue(withIdentifier: "downloadSegue", sender: nil)
        
    }
    
    @IBAction func shareAction(_ sender: Any) {
        
    }
}

