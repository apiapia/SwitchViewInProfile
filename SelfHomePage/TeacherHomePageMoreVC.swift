//  TeacherHomePageMoreVC.swift
//  GGSTeacher
//  Created by cc mac mini on 16/5/13
//  Copyright © 2016年 庄宇飞. All rights reserved.
//  Update by 布袋 on 07/25/2017 用KVO来监听所有的TableView

public let HomeWidth = UIScreen.main.bounds.size.width
public let HomeHeight = UIScreen.main.bounds.size.height

import UIKit

class TeacherHomePageMoreVC: UIViewController,UIScrollViewDelegate{
     dynamic var offerX:CGFloat = 0.0
    var headView:TeacherHomePageMoreView!
    
    var navView:UIToolbar?
    lazy var backScrollView:UIScrollView = {
        let backScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: HomeWidth, height: HomeHeight))
        backScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width * 3  , height: HomeHeight)
        backScrollView.delegate = self
        backScrollView.showsHorizontalScrollIndicator = false
        backScrollView.showsVerticalScrollIndicator = false
        backScrollView.isPagingEnabled = true
        backScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(136, 0, 0, 0)
        backScrollView.backgroundColor = UIColor.cyan 
        return backScrollView
    }()
    
    
    var arrs = ["资料","辅导","更多"]
    var toorView:UIView!
    var toorViewH:UIToolbar!
    var scrollLineView:UIView!
    var scrollLineViewH:UIView!
    
    var firstVC:ChildFirstViewController?
    var secondVC:ChildSecondViewController?
    var thirdVC:ChildThirdViewController?
    
    var isScroll:Bool = true
    var oldF:CGFloat = 0.0
    var orginW:CGFloat = UIScreen.main.bounds.size.width/7
    var s:NSInteger = 0
    
    deinit{
        firstVC!.removeObserver(self, forKeyPath: "offerY")
        secondVC!.removeObserver(self, forKeyPath: "offerY")
        thirdVC!.removeObserver(self, forKeyPath: "offerY")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
//    func back(){
//        self.navigationController?.popViewController(animated: true)
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
           //FIXME:添加控制器
        self.view.addSubview(backScrollView)
        
        headView = Bundle.main.loadNibNamed("TeacherHomePageMoreView", owner: self, options: nil)?.last as! TeacherHomePageMoreView
        headView.frame = CGRect(x: 0, y: 0, width: kWidth, height: 200)
        self.view.insertSubview(headView, aboveSubview: backScrollView)
        
        self.addController()
        self.navTitleView()
        self.addButton()
        
       
    }
    //FIXME:添加控制器
    func addController(){
//        weak var weakSelf = self
//        firstVC.firstBlock = {(isScroll:Bool)->Void in
//            self.isScroll = isScroll
//            weakSelf?.isTouchToButton()
//        }
        // 填加控制器
        firstVC = ChildFirstViewController()
        self.addChildViewController(firstVC!)
        firstVC!.addObserver(self, forKeyPath: "offerY", options: NSKeyValueObservingOptions.new, context: nil)
        // 填加控制器视图
        firstVC!.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.backScrollView.addSubview(firstVC!.view)
        
//        secondVC.secondBlock = {(isScroll:Bool)->Void in
//        self.isScroll = isScroll
//           weakSelf?.isTouchToButton()
//        }
        secondVC = ChildSecondViewController()
        self.addChildViewController(secondVC!)
        secondVC!.addObserver(self, forKeyPath: "offerY", options: NSKeyValueObservingOptions.new, context: nil)
        secondVC!.view.frame = CGRect(x: view.bounds.width * 1, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.backScrollView.addSubview(secondVC!.view)
        
    
//        thirdVC.threeBlock = {(isScroll:Bool)->Void in
//            self.isScroll = isScroll
//            weakSelf?.isTouchToButton()
//        }
      
        thirdVC = ChildThirdViewController()
        self.addChildViewController(thirdVC!)
        thirdVC!.addObserver(self, forKeyPath: "offerY", options: NSKeyValueObservingOptions.new, context: nil)
        thirdVC!.view.frame = CGRect(x: view.bounds.width * 2, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.backScrollView.addSubview(thirdVC!.view)
    }
   
    //FIXME:---判断button是否可点击
    func isTouchToButton(){
//        if self.isScroll == true{
//            self.toorView.isUserInteractionEnabled = true
//            self.toorViewH.isUserInteractionEnabled = true
//        }else{
//
//            self.toorView.isUserInteractionEnabled = false
//            self.toorViewH.isUserInteractionEnabled = false
//        }
    }
    
    //FIXME:KVO接收
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offsetY = change![NSKeyValueChangeKey.newKey] as! CGFloat
        let s = offsetY - oldF
        oldF = offsetY
        self.toorView.frame.origin.y -= s
        self.headView.frame.origin.y -= s 
        
        if offsetY >= Header_Height {
            self.toorViewH.isHidden = false
            self.toorViewH.alpha = 1
        }else{
        
            self.toorViewH.isHidden = true
        }
        
        if offsetY > 0{
            self.navView!.alpha = ((offsetY-10)/100)
        }else if offsetY == 0{
            UIView.animate(withDuration: 0.23, animations: { () -> Void in
                self.navView!.alpha = ((offsetY-10)/100)
            })
        }
        
      // MARK: - 监听VC的上下滑动Y值，并同步 Fix by 布袋 2017-7-25  
        let offer:CGFloat = backScrollView.contentOffset.x
        let i = offer / backScrollView.frame.size.width
        switch i {
        case 0:
            print("第1个VC")
            secondVC?.tbView.contentOffset = CGPoint(x: 0, y: offsetY)
            thirdVC?.tbView.contentOffset = CGPoint(x: 0, y: offsetY)
        case 1:
             print("第2个VC")
             firstVC?.tbView.contentOffset = CGPoint(x: 0, y: offsetY)
             thirdVC?.tbView.contentOffset = CGPoint(x: 0, y: offsetY)
        default:
             print("第3个VC")
             secondVC?.tbView.contentOffset = CGPoint(x: 0, y: offsetY)
             firstVC?.tbView.contentOffset = CGPoint(x: 0, y: offsetY)
        }
        
    }
    
    //FIXME:添加控件
    func navTitleView(){
        navView = UIToolbar(frame: CGRect(x: 0, y: 0, width: kWidth, height: 64))
        navView!.backgroundColor = UIColor.white
        navView!.layer.shadowColor = UIColor.gray.cgColor
        navView!.layer.shadowOpacity = 0.5
        navView!.layer.shadowOffset = CGSize(width: 0, height: 0.2)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: kWidth, height: 20))
        titleLabel.textColor = UIColor.black
        titleLabel.text = "个人主页"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        titleLabel.textAlignment = .center
        navView!.addSubview(titleLabel)
        navView!.alpha = 0
        self.view.addSubview(navView!)
        
        toorViewH = UIToolbar(frame: CGRect(x: 0, y: 64, width: kWidth, height: 40))
        toorViewH.isHidden = true
        self.view.insertSubview(toorViewH, aboveSubview: backScrollView)
        
        scrollLineViewH = UIView(frame: CGRect(x: orginW, y: 37, width: orginW, height: 3))
        scrollLineViewH.backgroundColor = UIColor.green
        toorViewH.addSubview(scrollLineViewH)
        
        
        toorView = UIView(frame: CGRect(x: 0, y: 200, width: kWidth, height: 40))
        toorView.backgroundColor = UIColor(colorLiteralRed: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha:1)
        toorView.layer.shadowColor = UIColor.gray.cgColor
        self.view.insertSubview(toorView, aboveSubview: backScrollView)
        
        scrollLineView = UIView(frame: CGRect(x: orginW, y: 37, width: orginW, height: 3))
        scrollLineView.backgroundColor = UIColor.green
        toorView.addSubview(scrollLineView)
        
    }

    
    //FIXME:添加button
    func addButton(){
        for i in 0 ..<  arrs.count {
            let W:CGFloat = orginW
            let H:CGFloat = 40
            let Y:CGFloat = 0
            let X:CGFloat = CGFloat(i) * (W + orginW) + W
            
            let button:UIButton = UIButton()
            button.frame = CGRect(x: X, y: Y, width: W, height: H)
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.setTitle(arrs[i], for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            button.tag = i
            button.addTarget(self, action: #selector(TeacherHomePageMoreVC.buttonAction(_:)), for: .touchUpInside)
            self.toorView.addSubview(button)
            // self.toorView.bringSubview(toFront: (firstVC?.view)!)
            
            let buttonH:UIButton = UIButton()
            buttonH.frame = CGRect(x: X, y: Y, width: W, height: H)
            buttonH.setTitleColor(UIColor.black, for: UIControlState())
            buttonH.setTitle(arrs[i], for: UIControlState())
            buttonH.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            buttonH.tag = i
            buttonH.addTarget(self, action: #selector(TeacherHomePageMoreVC.buttonAction(_:)), for: .touchUpInside)
            self.toorViewH.addSubview(buttonH)
            // self.toorViewH.bringSubview(toFront: (firstVC?.view)!)
           // self.view.insertSubview(toorViewH, aboveSubview: backScrollView)
        }
    }
    
    //FIXME:button点击事件
    func buttonAction(_ sender:UIButton){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let originX = CGFloat(sender.tag) * (self.orginW + self.orginW) + self.orginW
                self.scrollLineViewH.frame.origin.x  = originX
                self.scrollLineView.frame.origin.x  = originX
            print (sender.tag)
            switch sender.tag {
            case 0:
                self.backScrollView.contentOffset.x = 0
            case 1:
                self.backScrollView.contentOffset.x = HomeWidth
            default:
                self.backScrollView.contentOffset.x = HomeWidth * 2

            }
        })
    }
    
    
    //FIXME:-----scrollView delegate  2017.7.24 ,竖向的时候采用上方的KVO,观查offsetY值
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.offerX = scrollView.contentOffset.x
//        let offsetY = scrollView.contentOffset.y
//        
//        print ("当前VC的offerY\(offsetY)")
//        //FIXME: 判断当前显示的视图是firstVC，就改变其他2个VC中的scroll偏移
//        if self.view === firstVC?.view.self {
//            print("firstVC.view")
//            secondVC?.tbView.contentOffset = CGPoint(x: 0, y: offsetY)
//            thirdVC?.tbView.contentOffset = CGPoint(x: 0, y: offsetY)
//        }
//        
        
    }
    // 底部小滑条
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offer:CGFloat = scrollView.contentOffset.x
        let i = offer / backScrollView.frame.size.width
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let originX = CGFloat(i) * (self.orginW + self.orginW) + self.orginW
            self.scrollLineViewH.frame.origin.x  = originX
            self.scrollLineView.frame.origin.x  = originX
        })
    }

}

// Swift - 获取当前的ViewController
extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?{
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController) }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}



