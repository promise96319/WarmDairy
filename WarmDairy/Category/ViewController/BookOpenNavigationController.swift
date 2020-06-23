//
//  BookOpenNavigationController.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/4/20.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

class BookOpenNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
}

extension BookOpenNavigationController {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return nil
        }
        
        if operation == .pop {
            return nil
        }
        
        return nil
    }
}

class BookOpenTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var transforms = [UICollectionViewCell: CATransform3D]() //2
    var toViewBackgroundColor: UIColor? //3
    var isPush = true //4
    
    //5
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      
    }
    
    func makePerspectiveTransform() -> CATransform3D {
      var transform = CATransform3DIdentity
      transform.m34 = 1.0 / -2000
      return transform
    }
    
    func closePageCell(cell: CategorySectionCell) {
      // 1
      var transform = self.makePerspectiveTransform()
      // 2
      if cell.layer.anchorPoint.x == 0 {
        // 3
        transform = CATransform3DRotate(transform, CGFloat(0), 0, 1, 0)
        // 4
        transform = CATransform3DTranslate(transform, -0.7 * cell.layer.bounds.width / 2, 0, 0)
        // 5
        transform = CATransform3DScale(transform, 0.7, 0.7, 1)
       }
       // 6
       else {
         // 7
        transform = CATransform3DRotate(transform, CGFloat.pi, 0, 1, 0)
         // 8
         transform = CATransform3DTranslate(transform, 0.7 * cell.layer.bounds.width / 2, 0, 0)
         // 9
         transform = CATransform3DScale(transform, 0.7, 0.7, 1)
        }

        //10
        cell.layer.transform = transform
    }
    
    func setStartPositionForPush(fromVC: UIViewController, toVC: UIViewController) {
//      // 1
//      toViewBackgroundColor = fromVC.collectionView?.backgroundColor
//      toVC.collectionView?.backgroundColor = nil
//
//      //2
//      fromVC.selectedCell()?.alpha = 0

      //3
//      for cell in toVC.collectionView!.visibleCells() as! [BookPageCell] {
//        //4
//        transforms[cell] = cell.layer.transform
//        //5
//        closePageCell(cell)
//        cell.updateShadowLayer()
//        //6
//        if let indexPath = toVC.collectionView?.indexPathForCell(cell) {
//          if indexPath.row == 0 {
//            cell.shadowLayer.opacity = 0
//          }
//        }
//      }
    }
}
