//
//  BaseViewController.swift
//  AutoData
//
//  Created by 聂飞安 on 2020/4/15.
//

import UIKit
import NFAToolkit
import WebKit

open class BaseViewController: UIViewController , IDataPost {
    
    open var callBack: CBWithParam?
    open var postData : AnyObject?
    open var loding = false
    open var viewType : ViewType? = .正常
    open var hiddenStatusBar = false
    
    public var subViewsData : [(AutoViewClass , Int)]! = [(AutoViewClass , Int)]()
        
    public func addAutoView(_ subs :[(AutoViewClass , Int)]){
        subViewsData = subs
    }
        
    public func addSubview(autoViewClass : AutoViewClass , index : Int) {
        self.view.addSubview(autoViewClass: autoViewClass, index: index)
    }
    
    public func getNomerView<T>(autoViewClass : AutoViewClass , index : Int , autoInit : Bool = false) -> T?{
        return getSubview(autoViewClass: autoViewClass, index: index, autoInit: autoInit) as? T
    }
    
        
    public func getSubview(autoViewClass : AutoViewClass , index : Int , autoInit : Bool = false) -> UIView?{
        return self.view.getSubview(autoViewClass: autoViewClass, index: index, autoInit: autoInit)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
        print("当前类:\(self.classForCoder)")
        #endif
        initializeView()
        
        // Do any additional setup after loading the view.
    }
    
    
   public func setupStatusBarNotification() {
        NotificationCenter.default.removeObserver(self, name: AppNotification.STATUS_BAR.Hidden, object: nil)
        NotificationCenter.default.removeObserver(self, name: AppNotification.STATUS_BAR.Show, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(hiddenMyStatusBar), name: AppNotification.STATUS_BAR.Hidden, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(showMyStatusBar), name: AppNotification.STATUS_BAR.Show, object: nil)
    }
    
    
    @objc open func backAction() {
        Tools.popView(self)
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
       return appStatusBarStyle
    }
    
    override open var prefersStatusBarHidden: Bool {
        return hiddenStatusBar
    }
    
    open func initializeView(){
        initializePage()
        initLayoutSubviews()
        initializeDelegate()
        initializeDraw()
        initializeData()
    }
    
    open func initializePage(){
        if subViewsData.count == 0 {
            return
        }
        for viewsData in subViewsData{
        let viewClass = viewsData.0
            for index in 0 ..< viewsData.1 {
               addSubview(autoViewClass: viewClass, index: index + 1)
            }
        }
    }

    open  func initLayoutSubviews(){
    }

    open  func initializeDelegate(){

    }
    
    open  func initializeDraw(){

    }
    
    open  func initializeData(){

    }
    

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -1500, vertical: 0), for: UIBarMetrics.default)
        if  viewType == .正常
        {
            ResidentManager.curViewController =  self
        }
    }
    
    private var blankImage: CustImageView?
    private var blankLabel: UILabel?
      
      open func showBlankDataTip(_ message : String = "暂无数据" , tipsImage : String , topConstant : CGFloat = AppHeight * 0.3, addInTheView : UIView , cb : @escaping CB) {
         if blankImage?.superview != nil {
             return
         }
         blankImage = CustImageView(image: UIImage(named: tipsImage))
         blankImage!.translatesAutoresizingMaskIntoConstraints = false
         let imageTop = NSLayoutConstraint(item: blankImage!, attribute: .top, relatedBy: .equal, toItem: addInTheView, attribute: .top, multiplier: 1, constant:topConstant)
         let imageCenterX = NSLayoutConstraint(item: blankImage!, attribute: .centerX, relatedBy: .equal, toItem: addInTheView, attribute: .centerX, multiplier: 1, constant: 0)
         addInTheView.addSubview(blankImage!)
         addInTheView.addConstraints([imageTop, imageCenterX])
         blankLabel = UILabel()
         blankLabel!.textColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
         blankLabel!.translatesAutoresizingMaskIntoConstraints = false
         addInTheView.addSubview(blankLabel!)
         blankLabel!.text = message
         blankLabel?.font = UIFont.systemFont(ofSize: 14)
         blankLabel?.textAlignment = .center
         blankImage?.addClickEvents(cb)
         let dataTop = NSLayoutConstraint(item: blankLabel!, attribute: .top, relatedBy: .equal, toItem: blankImage, attribute: .bottom, multiplier: 1, constant: 10)
         let dataCenterX = NSLayoutConstraint(item: blankLabel!, attribute: .centerX, relatedBy: .equal, toItem: blankImage, attribute: .centerX, multiplier: 1, constant: 0)
         addInTheView.addConstraints([dataTop, dataCenterX])
      }

      open func hiddenBlankDataTip() {
         blankImage?.removeFromSuperview()
         blankLabel?.removeFromSuperview()
         blankImage = nil
         blankLabel = nil
      }
    
    @objc open func hiddenMyStatusBar() {
        hiddenStatusBar = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc open func showMyStatusBar() {
        hiddenStatusBar = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
      
    
    open func postData(_ postData : AnyObject?) {
       self.postData = postData
    }

    open func regCallBack(_ cb : @escaping CBWithParam) {
       self.callBack = cb
    }

    deinit {
       #if DEBUG
       print("\(self.classForCoder)销毁")
       #endif
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func setLable(index : Int , numberOfLines : Int , font: UIFont , textColor : UIColor , text : String , lineSpacing : CGFloat , textAlignment : NSTextAlignment = .left){
       if let label = getSubview(autoViewClass: .label, index: index) as? UILabel {
           label.numberOfLines = numberOfLines
           label.font = font
           label.textColor = textColor
           label.text = text
           label.setLineSpacing(lineSpacing)
            label.textAlignment = textAlignment
       }
    }

}
