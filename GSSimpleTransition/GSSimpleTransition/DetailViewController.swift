//
//  DetailViewController.swift
//  GSSimpleTransition
//
//  Created by gina on 2018/11/15.
//  Copyright © 2018 gina. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    let transition = GSTransition()
    let detailInfoData = Info()
    var selectedCellFrame = CGRect.zero
    var tempImageRef : CGImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "DetailVC"
        
        detailImageView.image = UIImage(named: detailInfoData.imageName)
        detailTextView.text = detailInfoData.message
        let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePopRecognizer(gestureRecognizer:)))
        panGesture.edges = .left
        view.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    @objc private func handlePopRecognizer(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        var progress = gestureRecognizer.translation(in: view).x / view.bounds.size.width
        progress = min(1.0 ,max(0.0 ,progress))

        if gestureRecognizer.state == .began {
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
        }else if (gestureRecognizer.state == .changed) {
            if progress > 0 {
                percentDrivenTransition!.update(progress)
            }
        }else if (gestureRecognizer.state == .cancelled || gestureRecognizer.state == .ended) {
            if progress > 0.5{
                percentDrivenTransition!.finish()
            }else {
                percentDrivenTransition!.cancel()
            }
            percentDrivenTransition = nil
        }
    }
}

//MARK: - UINavigationControllerDelegate
extension DetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.duration = 1
        transition.style = GSTransitionStyle(rawValue: detailInfoData.style!)!
        transition.selectedFrame = self.selectedCellFrame
        transition.tempImageRef = tempImageRef
        if operation == .pop {
            transition.operation = .pop
            return transition
        }
        
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return percentDrivenTransition
    }
}
