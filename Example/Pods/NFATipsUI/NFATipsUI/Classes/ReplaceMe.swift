import NFAToolkit

public func noCount(_ str : String? , tip : String, delayTime : CGFloat = 4 , toSelf : Bool  = false) -> Bool{
    if str?.count ?? 0 == 0 {
      if toSelf {
        showTipsWindow("您的" + tip, delayTime: delayTime)
      }else{
        showTipsWindow(tip, delayTime: delayTime)
      }
      return true
    }
    return false
}


public func noCount(_ array : [String?] , tip : String, delayTime : CGFloat = 4 , toSelf : Bool  = false) -> Bool{
    for str in array {
        if noCount(str,tip: tip,delayTime: delayTime,toSelf: toSelf) {
            return true
        }
    }
    return array.count == 0
}

public func showTipsWindowNoHide(_ tips : String = "系统错误", delayTime : CGFloat = 4 ){
    showTipsWindow(tips, delayTime: delayTime, autuHide: false)
}

public func hideTipsWindowNoHide(){
    AppWindow().viewWithTag(999)?.isHidden = true
    AppWindow().viewWithTag(999)?.removeFromSuperview()
}

public  func showTipsWindow(_ tips : String = "系统错误", delayTime : CGFloat = 4 , autuHide : Bool = true){

    let tipsView =  AppWindow().viewWithTag(999) ?? UIView()
    if tipsView.tag == 999 &&  tipsView.alpha != 0 {
      return
    }
    tipsView.backgroundColor = UIColor.initString( "000000", alpha: 0.8)
    tipsView.tag = 999
    AppWindow().addSubview(tipsView)
    tipsView.alpha = 0

    let label = tipsView.viewWithTag(888) as? UILabel ?? UILabel()
    if label.tag != 888 {
        label.textAlignment  = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        tipsView.addSubview(label)
    }

    label.text = tips
    label.sizeToFit()
    tipsView.frame = CGRect(x: 0, y: 0, width: label.width + 20, height: label.height + 20)
    label.frame = CGRect(x: 10, y: 10, width: label.width, height: label.height)
    tipsView.center = AppWindow().center

    Tools.setCornerRadius(tipsView, rate: 5)
    
    UIView.animate(withDuration: 0.3, animations: {
      tipsView.alpha = 1
    }) { (finished) in
        if autuHide {
            UIView.animate(withDuration: 0.3, delay: TimeInterval(delayTime), options: UIView.AnimationOptions.curveEaseOut, animations: {
                tipsView.alpha = 0
            }, completion: { (b) in
                tipsView.removeFromSuperview()
            })
        }
    }
}
