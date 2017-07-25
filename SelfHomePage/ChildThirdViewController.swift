//
//  ChildThirdViewController.swift
//  GGSTeacher
//
//  Created by cc mac mini on 16/5/13.
//  Copyright © 2016年 庄宇飞. All rights reserved.
//  Update by 布袋 on 07/25/2017

import UIKit

typealias BlessBlock = (_ blessBlock:Bool) -> Void
class ChildThirdViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

  
    var tbView:UITableView!
    dynamic var offerY:CGFloat = 0.0
    var headView:TeacherHomePageMoreView!
    var threeBlock:BlessBlock?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTableView()
    }
    
     //FIXME:-----接收的通知
//    func notiAction(_ notification:Notification){
//        var dic = notification.userInfo
//        let y:CGFloat = (dic!["inforY"] as? CGFloat)!
//        if y >= Header_Height{
//            if tbView.contentOffset.y < Header_Height{
//                tbView.contentOffset.y = Header_Height
//            }
//        }else{
//            tbView.contentOffset.y = y
//        }
//    }
    
     //FIXME:-----创建 tableView
    func createTableView(){
        tbView = UITableView(frame: CGRect(x: 0, y: 0, width:kWidth , height: kHeight), style:UITableViewStyle.grouped)
        tbView.dataSource = self
        tbView.delegate = self
        self.view.addSubview(tbView!)
        
        headView = Bundle.main.loadNibNamed("TeacherHomePageMoreView", owner: self, options: nil)?.last as! TeacherHomePageMoreView
        headView.frame = CGRect(x: 0, y: 0, width: kWidth, height: 200)
        self.tbView.tableHeaderView = headView
        
        self.tbView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ChildThirdViewController.notiAction(_:)), name: NSNotification.Name(rawValue: "inforSwift"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ChildThirdViewController.notiAction(_:)), name: NSNotification.Name(rawValue: "turorSwift"), object: nil)

    }
//    
//    deinit{
//        NotificationCenter.default.removeObserver(self)
//    }
    
    //FIXME:-----tableView delegate
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return 1
        }else{
            
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let identity:String = "cell"
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: identity, for: indexPath)
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: identity)
        }
        cell.textLabel?.text = "FEI       ->\(indexPath.row)"
        if (indexPath.row % 3) == 0{
            cell.backgroundColor = UIColor.purple
        }else{
             cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 40
        }else{
            
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
     //FIXME:-----scrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.offerY = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(threeBlock != nil){
            threeBlock!(true)
        }
        let offer:CGFloat = scrollView.contentOffset.y
        tbView.contentOffset.y = offer
        var dic:Dictionary<String,CGFloat> = Dictionary()
        dic["inforY"] = offer
        NotificationCenter.default.post(name: Notification.Name(rawValue: "BlessSwift"), object: nil, userInfo: dic)
        
  }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(threeBlock != nil){
            threeBlock!(false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {//手指松开
       
        if decelerate == false{
           self.scrollViewDidEndDecelerating(scrollView)
        }
    }
}
