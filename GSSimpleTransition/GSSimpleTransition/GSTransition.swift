//
//  GSTransition.swift
//  GSSimpleTransition
//
//  Created by gina on 2018/11/15.
//  Copyright © 2018 gina. All rights reserved.
//

import UIKit

enum GSTransitionStyle: Int {
    case None = 1
    case Up
    case Open
}
class GSTransition:NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationController.Operation?
    var duration: TimeInterval = 0.5
    var selectedFrame = CGRect.zero
    var style: GSTransitionStyle = .None
    var tempImageRef : CGImage!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let fromView = fromVC.view
        
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = toVC.view
        
        let containerView = transitionContext.containerView
        
        switch style {
        case .None:
            containerView.addSubview(fromView!)
            containerView.addSubview(toView!)
            toView?.alpha = 0
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView?.alpha = 0
                toView?.alpha = 1
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
            break;
        case .Up:
            let finalFrameForVC = transitionContext.finalFrame(for: toVC)
            let bounds = UIScreen.main.bounds
            
            if operation == .push {
                toVC.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
            }else{
                toVC.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: -bounds.size.height)
            }
            containerView.addSubview(toView!)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView?.alpha = 0.5
                toView?.frame = finalFrameForVC
            }, completion: { finished in
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                    toView?.alpha = 1
                }, completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    fromView?.alpha = 1.0
                })
                
            })
            
            break;
            
        case .Open:
            let finalFrame = transitionContext.finalFrame(for: toVC)
            toView?.frame = finalFrame
            
            var snapShot = UIImage()
            let bounds = CGRect(x: 0, y: 0, width: (fromView?.bounds.size.width)!, height: (fromView?.bounds.size.height)!)
            
            var imageViewTop:UIImageView?
            var imageViewBottom:UIImageView?
            // selectedFrame是使用者所點選cell的屬性frame
            let topHeight = selectedFrame.origin.y
            
            let imageViewTopFrame = CGRect(x: 0, y: 0, width: bounds.width, height: topHeight)
            let imageViewBottomFrame = CGRect(x: 0,
                                              y: topHeight,
                                              width: bounds.width,
                                              height: bounds.height - selectedFrame.origin.y)
            if operation == .push {
                // 抓一張SourceView的圖（HomeViewController）
                UIGraphicsBeginImageContextWithOptions((fromView?.bounds.size)!, true, 1)
                fromView?.drawHierarchy(in: bounds, afterScreenUpdates: false)
                snapShot = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                // SnapShot的圖
                 tempImageRef = snapShot.cgImage!
            }
            let topImageRef = tempImageRef.cropping(to: imageViewTopFrame)
            let bottomImageRef = tempImageRef.cropping(to: imageViewBottomFrame)
            
            // 上半部的圖片
            if topImageRef != nil {
                imageViewTop = UIImageView(image: UIImage(cgImage: topImageRef!, scale: snapShot.scale, orientation: UIImage.Orientation.up))
                imageViewTop?.frame = imageViewTopFrame
            }
            
            // 下半部的圖片
            if (bottomImageRef != nil) {
                imageViewBottom = UIImageView(image: UIImage(cgImage: bottomImageRef!, scale: snapShot.scale, orientation: UIImage.Orientation.up))
                imageViewBottom!.frame = imageViewBottomFrame
            }
            
            toView?.alpha = 0
            fromView?.alpha = 0
            
            let backgroundView = UIView(frame: bounds)
            backgroundView.backgroundColor = UIColor.black
            
            if self.operation == .push {
                containerView.addSubview(backgroundView)
                containerView.addSubview(toView!)
                containerView.addSubview(imageViewTop!)
                containerView.addSubview(imageViewBottom!)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                    imageViewTop!.frame = CGRect(x: 0,
                                                      y: -imageViewTop!.frame.height,
                                                      width: imageViewTop!.frame.width,
                                                      height: imageViewTop!.frame.height)
                    
                    imageViewBottom!.frame = CGRect(x: 0,
                                                         y: bounds.height,
                                                         width: imageViewBottom!.frame.width,
                                                         height: imageViewBottom!.frame.height)
                    
                    toView?.alpha = 1
                    
                }, completion: { finished in
                    imageViewTop?.removeFromSuperview()
                    imageViewBottom?.removeFromSuperview()
                    backgroundView.removeFromSuperview()
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
            } else {
                imageViewTop!.frame = CGRect(x: 0,
                                             y: -imageViewTop!.frame.height,
                                             width: imageViewTop!.frame.width,
                                             height: imageViewTop!.frame.height)
                
                imageViewBottom!.frame = CGRect(x: 0,
                                                y: bounds.height,
                                                width: imageViewBottom!.frame.width,
                                                height: imageViewBottom!.frame.height)
                fromView?.alpha = 1
                
                containerView.addSubview(backgroundView)
                containerView.addSubview(fromView!)
                containerView.addSubview(toView!)
                containerView.addSubview(imageViewTop!)
                containerView.addSubview(imageViewBottom!)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                    imageViewTop!.frame = CGRect(x: 0,
                                                      y: 0,
                                                      width: imageViewTop!.frame.width,
                                                      height: imageViewTop!.frame.height)
                    
                    imageViewBottom!.frame = CGRect(x: 0,
                                                         y: bounds.height - imageViewBottom!.frame.height,
                                                         width: imageViewBottom!.frame.width,
                                                         height: imageViewBottom!.frame.height)
                    
                    
                    fromView?.alpha = 0
                    
                }, completion: { finished in
                    imageViewTop?.removeFromSuperview()
                    imageViewBottom?.removeFromSuperview()
                    backgroundView.removeFromSuperview()
                    
                    toView?.alpha = 1
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
            }
            break;
        }
    }
}


extension GSTransition: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}


