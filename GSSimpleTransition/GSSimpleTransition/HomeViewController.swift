//
//  HomeViewController.swift
//  GSSimpleTransition
//
//  Created by gina on 2018/11/15.
//  Copyright © 2018 gina. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var HomeTabelView: UITableView!
    let transition = GSTransition()
    var infoData = [Info]()
    var selectedCellFrame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: "HomeCell", bundle: nil)
        HomeTabelView.register(cellNib, forCellReuseIdentifier: "HomeCell")
        for i in 1...3 {
            let info = Info()
            info.title = "第\(i)個"
            info.imageName = "apple0\(i).png"
            info.message = "第\(i)個內容，test"
            info.style = i
            infoData.append(info)
        }
        for i in 4...5 {
            let info = Info()
            info.title = "第\(i)個"
            info.imageName = "apple0\(i).png"
            info.message = "第\(i)個內容，test"
            info.style = i-2
            infoData.append(info)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
        title = "HomeVC"

    }
    
    @IBAction func pushButtonClicked(_ sender: Any) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.modalPresentationStyle = .custom
        detailVC.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell

        cell.setInfo(info: infoData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

}

// MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCellFrame = tableView.convert(tableView.cellForRow(at: indexPath)!.frame, to: tableView.superview)
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.detailInfoData.imageName = infoData[indexPath.row].imageName
        detailVC.detailInfoData.message = infoData[indexPath.row].message
        detailVC.detailInfoData.title = infoData[indexPath.row].title
        detailVC.detailInfoData.style = infoData[indexPath.row].style
        transition.style = GSTransitionStyle(rawValue: infoData[indexPath.row].style!)!
        detailVC.selectedCellFrame = self.selectedCellFrame
        
        UIGraphicsBeginImageContextWithOptions((self.view.bounds.size), true, 1)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: false)
        var snapShot = UIImage()
        snapShot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let tempImageRef = snapShot.cgImage!
        detailVC.tempImageRef = tempImageRef
        
        detailVC.modalPresentationStyle = .custom
        detailVC.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: UINavigationControllerDelegate
extension HomeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.duration = 1
        transition.selectedFrame = self.selectedCellFrame
        if operation == UINavigationController.Operation.push {
            transition.operation = UINavigationController.Operation.push

            return transition
        }
        return nil
    }
}

class Info {
    var imageName:String!
    var title:String!
    var message:String!
    var style:Int!
}
