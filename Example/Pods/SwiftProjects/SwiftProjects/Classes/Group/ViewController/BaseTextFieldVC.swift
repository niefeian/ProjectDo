//
//  BaseTextFieldVC.swift
//  ZaiyiGouwuSQYHbuy
//
//  Created by 聂飞安 on 2020/6/11.
//  Copyright © 2020 zaiyici. All rights reserved.
//

import UIKit
import NFAToolkit

open class BaseTextFieldVC: BaseProVC {

   open var keyboardWillShows = [UIView]()
   open var textFields = [UITextField]()
   open var isShowTextField = false
   override open func viewDidLoad() {
       super.viewDidLoad()
       registerKeyboardNotification()
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
       self.view.addGestureRecognizer(tapGesture)
       // Do any additional setup after loading the view.
   }
   
   @objc func tapGesture(){
          
   }
   
   
   open func registerKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: AppNotification.Keyboard.AllHide, object: nil)

         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    
        NotificationCenter.default.addObserver(self, selector: #selector(allHide), name: AppNotification.Keyboard.AllHide, object: nil)
      }
    
    @objc func allHide(){
        for textField in textFields{
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
        }
    }
         
    @objc open func keyboardWillShow(notification: NSNotification) {
          let userInfo = notification.userInfo! as NSDictionary
           let keyboardBounds = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
           if keyboardBounds == nil {
               return
           }
           isShowTextField = true
           let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
           let h : CGFloat = (StatusBarH == 44) ?  33 : 0
           var deltaY = keyboardBounds!.height - 1 - h// 减去分割线高度 1
           if deltaY < 0 {
               deltaY = 270
           }
           let animation:(() -> Void) = {
              for view in self.keyboardWillShows{
               if let tableView = view as? UITableView {
                   tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: 160)
               }else{
                   view.transform = CGAffineTransform(translationX: 0, y: -160)
               }
              }
           }
           if duration > 0 {
               let options = UIView.AnimationOptions(rawValue: UInt((userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
               UIView.animate(withDuration: duration, delay: 0, options: options, animations: animation, completion: nil)
           } else {
               animation()
           }
      }

      @objc open func keyboardWillHide(notification: NSNotification) {
            isShowTextField = false
          let animation:(() -> Void) = {
              for view in self.keyboardWillShows{
                  view.transform = .identity
              }
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

extension BaseTextFieldVC : UIGestureRecognizerDelegate{
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let vString = "\(touch.view!.classForCoder)"
        if  vString == "UITextField" {
            return false
        }
        
        if isShowTextField {
           for textField in textFields{
                if textField.isFirstResponder {
                    textField.resignFirstResponder()
                    return true
                }
            }
        }
        return false
    }
}
