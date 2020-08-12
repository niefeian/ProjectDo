//
//  BaseFullPopVC.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/7/2.
//

import UIKit
import NFAToolkit

open class BaseFullPopVC: BasePopVC {

//    open var preventOcclusionViews : [UIView]! = [UIView]()
    open var preventOcclusion : UIView!
    open var offsizeTop : CGFloat! = 0
    
    open var textFields = [UITextField]()
    open var isShowTextField = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        regisPopSize(CGSize(width: AppWidth, height: AppHeight))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        registerKeyboardNotification()
        // Do any additional setup after loading the view.
    }
    
    
    @objc open func tapGesture(){
        
    }
    
    
    open func registerKeyboardNotification()
    {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
          
   @objc func keyboardWillShow(notification: NSNotification) {
       let userInfo = notification.userInfo! as NSDictionary
        let keyboardBounds = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        if keyboardBounds == nil {
            return
        }
        isShowTextField = true
//    preventOcclusionViews.count > 0 &&
        if preventOcclusion != nil
        {
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let h : CGFloat = (StatusBarH == 44) ?  33 : 0
            var deltaY = keyboardBounds!.height - 1 - h// 减去分割线高度 1
            if deltaY < 0 {
                deltaY = 270
            }
            let preventOcclusionY = preventOcclusion.frame.origin.y + offsizeTop
            if deltaY > preventOcclusionY
            {
                let animation:(() -> Void) = {
//                    for subView in self.preventOcclusionViews
//                    {
//
//                    }
                    self.view.transform = CGAffineTransform(translationX: 0, y: deltaY - preventOcclusionY)
                }
                if duration > 0 {
                    let options = UIView.AnimationOptions(rawValue: UInt((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
                    UIView.animate(withDuration: duration, delay: 0, options: options, animations: animation, completion: nil)
                } else {
                    animation()
                }
            }
        }
        
   }

   @objc func keyboardWillHide(notification: NSNotification) {
        isShowTextField = false
        if preventOcclusion != nil
        {
            let animation:(() -> Void) = {
                self.view.transform = .identity
//               for subView in self.preventOcclusionViews
//                {
//                    subView.transform = .identity
//                }
            }
            let userInfo = notification.userInfo! as NSDictionary
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            if duration > 0 {
              let options = UIView.AnimationOptions(rawValue: UInt((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
              UIView.animate(withDuration: duration, delay: 0, options: options, animations: animation, completion: nil)
            } else {
              animation()
            }
        }
      
   }

    @objc open func closePop()
    {
        disappear?()
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

extension BaseFullPopVC : UIGestureRecognizerDelegate{
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if  "\(touch.view!.classForCoder)" == "UITextField"
        {
            return false
        }
        
        for textField in textFields{
            if textField.isFirstResponder {
                textField.resignFirstResponder()
                return true
            }
        }
        
        //主view
        if touch.view?.tag == 0 {
            closePop()
        }
        
        return false
    }
}
