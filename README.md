#PageNavigation

在iOS5之后，可以使用分页控制器（UIPageViewController)构建电子书导航模式。分页控制器需要放置在一个父视图控制器中，在分页控制器下面是子视图控制器，每个子视图控制器对于图中的一个页面。具体实现效果如下：

![](5月-28-2016 18-35-50.gif)

### 主要实现要点：

* 实现UIPageViewController类，在viewDidLoad方法中创建并初始化首页
```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //创建分页控制器实例,指定为翻书效果样式和垂直翻页方式
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
```

* 实现UIPageViewControllerDataSource协议：
```swift
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

```

*实现UIPageViewControllerDelegate协议，书脊位置：.Min、.Max、.Mid分别定义书脊位置在最左/上、最右/下、中间位置
```swift
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
```
