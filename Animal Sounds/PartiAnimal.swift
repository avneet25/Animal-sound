//
//  PartiAnimal.swift
//  Animal Sounds
//
//  Created by Kalpit Patil on 2021-05-20.
//

import UIKit
import SDWebImage
import AVKit

class PartiAnimal: UIViewController {

    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var AnimalNameLbl: UILabel!
    @IBOutlet weak var TextView: UITextView!
    var audioUrl = String()
    var name = String()
    var id = Int()
    var dataList = [[String:Any]]()
    var player = AVPlayer()
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBtn.layer.cornerRadius = 25
        downloadBtn.layer.borderWidth = 1
        downloadBtn.layer.borderColor = UIColor.init(named: "theme color")?.cgColor
        downloadBtn.layer.cornerRadius = 8
        getdata()
        getFilesfromDD()
        loader.isHidden = true
        
    }
    func getFilesfromDD() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            let filter = fileURLs.filter {
                $0.lastPathComponent.split(separator: ".")[0] == name
            }
            if filter.count > 0 {
                
                downloadBtn.setImage(UIImage(named: "tick.png"), for: .normal)
                downloadBtn.isUserInteractionEnabled = false
            }
            else{
                //
            }
            
            
            
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    func getdata(){
        let filter = dataList.filter { (($0["id"] as! Int)) == id}
        let temp = filter[0] as! [String: Any]
        AnimalNameLbl.text = temp["name"] as! String
        
        TextView.text = temp["description"] as! String
        
        img2.sd_setImage(with: URL.init(string: temp["imgurl"] as! String))
        audioUrl = temp["audio"] as! String
        name = temp["name"] as! String
        self.title = temp["name"] as! String
        }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        
        saveFile(url: URL.init(string: audioUrl)!)
        downloadBtn.isUserInteractionEnabled = false
        
    }
    
    func saveFile(url:URL){
        
        let docUrl:URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
    let desURL = docUrl.appendingPathComponent("\(name).m4a") //Use file name with ext
    var downloadTask:URLSessionDownloadTask
    downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { [weak self](URLData, response, error) -> Void in
        do{
            let isFileFound:Bool? = FileManager.default.fileExists(atPath: desURL.path)
            if isFileFound == true{
                print(desURL)
            } else {
                try FileManager.default.copyItem(at: URLData!, to: desURL)
                
            }
            
            DispatchQueue.main.async { [self] in
                self!.downloadBtn.setImage(UIImage(named: "tick.png"), for: .normal)
                self!.downloadBtn.isUserInteractionEnabled = false
                self!.loader.stopAnimating()
                self!.loader.isHidden = true
            }

        }catch let err {
            print(err.localizedDescription)
            self!.downloadBtn.isUserInteractionEnabled = true
        }
    })
        
        loader.isHidden = false
        loader.startAnimating()
        downloadBtn.setImage(UIImage(), for: .normal)
        
        //resume downloading
    downloadTask.resume()
    }
    @IBAction func playBtnPressed(_ sender: Any) {
        
        
        guard let url = URL.init(string: audioUrl) else { return }
        //web url AVPlayer
        
                let playerItem = AVPlayerItem.init(url: url)
               player = AVPlayer.init(playerItem: playerItem)
                player.play()
    }
}
