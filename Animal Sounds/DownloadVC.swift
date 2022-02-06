//
//  DownloadVC.swift
//  Animal Sounds
//
//  Created by Kalpit Patil on 2021-05-21.
//

import UIKit
import SDWebImage
import AVKit

class DownloadVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var datalist = [[String:Any]]()
    var fileURLs = [URL]()
    var player = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        getdata()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        let partiUrl = fileURLs[indexPath.row]
        let name = partiUrl.lastPathComponent.split(separator: ".")[0]
        print(name)
        cell.lbl.text = String(name)
        
        let filter = datalist.filter {
            $0["name"] as! String == name
        }
        if (filter.count > 0) {
            let partiData = filter[0]
            cell.img.sd_setImage(with: URL.init(string: (partiData["imgurl"] as! String))) { img, error, cache, url in
                
            }
        }
        cell.img.layer.cornerRadius = 5
        
        return cell
    }
    
    func getdata() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
             fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            tableView.reloadData()
           
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let audioUrl = fileURLs[indexPath.row].relativePath
 
//        let playerItem = AVPlayerItem.init(url: URL.init(string: audioUrl)!)
        do {
            //for local url AVAudioPlayer
            try player = AVAudioPlayer.init(contentsOf: URL.init(string: audioUrl)!)
            player.play()
        }
        catch {}
        
    }
}
