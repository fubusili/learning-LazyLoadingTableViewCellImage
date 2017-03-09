//
//  ViewController.swift
//  TableLazyLaodingImage
//
//  Created by hc_cyril on 2017/3/8.
//  Copyright © 2017年 Clark. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

private let cellIdentifier = "cellIdentifier"
private let url = "https://api.dribbble.com/v1/shots?sort=&access_token=a589847521cfb6420457b84d97addee8c7b108ad49d9a5768f66109bc0bbea21"

class ViewController: UITableViewController {
    
    var imageItems = Array<Any>()
    var targetRect = CGRect()
    var isTarget = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        Alamofire.request(url).responseJSON{ response in
            
            print(response.data ?? "response.data == nil")
            print(JSON(data: response.data!))
            Alamofire.request(url).validate().responseJSON { resopnse in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    self.imageItems =  json.arrayValue
                    self.tableView.reloadData()
                case .failure (let error):
                    print(error)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableView delegate and datoSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ImageTableViewCell
        self.setup(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width / 3 * 2
        
    }
    
    //MARK: UIScrollDelegate
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isTarget = false
        self.loadImageForVisibleCells()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.targetRect = CGRect(x: targetContentOffset.pointee.x, y: targetContentOffset.pointee.y, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        self.isTarget = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isTarget = false
        self.loadImageForVisibleCells()
    }
    
    //MARK: method
    func objectForRow(at indexPath:IndexPath) -> JSON? {
        if  indexPath.row < self.imageItems.count {
            return self.imageItems[indexPath.row] as? JSON
        }
        return nil
    }
    
    func loadImageForVisibleCells() {
        let visibleCells = self.tableView.visibleCells
        for cell in visibleCells {
            self.setup(cell: cell as! ImageTableViewCell, atIndexPath: self.tableView.indexPath(for: cell)!)
        }
    }
    
    func setup(cell: ImageTableViewCell, atIndexPath indexPath: IndexPath) {
        
        if let obj = self.objectForRow(at:indexPath) {
            
            if let urlStr = obj["images"]["normal"].string  {
                let url = URL(string: urlStr)

                if (cell.photoView.kf.webURL != url) {
                    cell.photoView.alpha = 0.0;
                    let cellFrame = self.tableView.rectForRow(at: indexPath)
                    var shouldLoadImage = true
                    if self.isTarget && !self.targetRect.intersects(cellFrame) {
                        let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: urlStr, options: nil)
                        if image == nil {
                            shouldLoadImage = false
                        }
                    }
                    if shouldLoadImage {
                        cell.photoView?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, type, urls) in
                            if error == nil && url == urls {
                                UIView.animate(withDuration: 0.25, animations: {
                                    cell.photoView.alpha = 1.0
                                })
                            }
                        })
                    }
                }

            }
        }
        
    }
    
    

}

