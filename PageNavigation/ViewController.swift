//
//  ViewController.swift
//  PageNavigation
//
//  Created by 张楚昭 on 16/5/28.
//  Copyright © 2016年 tianxing. All rights reserved.
//

import UIKit

/**
 标记翻页的方向
 
 - Before: 向前翻
 - After:  向后翻
 */
enum DirectionForward{
    case Before
    case After
}

class ViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //保存当前页面的索引
    var pageIndex = 0
    //保存当前翻页的方向
    var directionForward = DirectionForward.After
    //保存分页控制器实例
    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //创建分页控制器实例
        self.pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Vertical, options: nil)
        //设置pageViewController的委托对象为当前视图控制器
        self.pageViewController.delegate = self
        //设置pageViewController的数据源对象为当前视图控制器
        self.pageViewController.dataSource = self
        //设置pageViewController的首页
        let mainStoryboard = self.storyboard
        let page1ViewController = mainStoryboard?.instantiateViewControllerWithIdentifier("page1")
        //首页中显示几个视图跟书脊类型有关，Mid则需要显示两个视图，Min和Max只需显示一个视图
        let viewControllers: NSArray = [page1ViewController!]
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.view.addSubview(self.pageViewController.view)
    }

    //实现数据源协议UIPageViewControllerDataSource方法
    //返回当前视图控制器之前的视图控制器，用于上一个页面的显示
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        pageIndex -= 1
        if pageIndex < 0{
            pageIndex = 0
            return nil
        }
        directionForward = .Before
        let mainStoryboard = self.storyboard
        let pageID = NSString(format: "page%i", pageIndex + 1)
        let pvController = mainStoryboard?.instantiateViewControllerWithIdentifier(pageID as String)
        return pvController
    }
    //返回当前视图控制器之后的视图控制器，用于下一个页面的显示
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        pageIndex += 1
        if pageIndex > 2{
            pageIndex = 2
            return nil
        }
        directionForward = .After
        let mainStoryboard = self.storyboard
        let pageID = NSString(format: "page%i", pageIndex + 1)
        let pvController = mainStoryboard?.instantiateViewControllerWithIdentifier(pageID as String)
        return pvController
    }
    
    //实现委托协议UIPageViewControllerDelegage
    //设置是否双面显示和书脊的位置
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        self.pageViewController.doubleSided = false
        return .Min
    }
    //翻页动作完成后触发的方法
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //如果没有翻页成功，则需要重置pageIndex
        if completed == false{
            if directionForward == DirectionForward.After{
                pageIndex -= 1
            }
            if directionForward == DirectionForward.Before {
                pageIndex += 1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

