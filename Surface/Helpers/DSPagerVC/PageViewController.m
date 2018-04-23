//
//  PageViewController.m
//  ContainerTabDemo
//
//  Created by Deepak Saxena on 03/05/17.
//  Copyright © 2017 rnf. All rights reserved.
//

#import "PageViewController.h"


@interface PageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,UIScrollViewDelegate >{
    
}

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;

    [self setViewControllers:@[_arrViewController[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageviewController Delegates and Datasources -

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.mDelegate pageViewDidScroll:scrollView];
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController{
    
    NSInteger currentIdx =  [_arrViewController indexOfObject:viewController];
    NSInteger prevIdx;
    if (_circular) {
        prevIdx = ((currentIdx-1)%_arrViewController.count);
        return _arrViewController[prevIdx];
    } else {
        if (currentIdx==0) {
        return nil;
        }
        prevIdx = currentIdx-1;
        return _arrViewController[prevIdx];
    }
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
   
    
    NSInteger currentIdx = [_arrViewController indexOfObject:viewController];
    NSInteger nextIdx;
    
    if (_circular) {
        nextIdx =((currentIdx+1)%_arrViewController.count);
        return _arrViewController[nextIdx];
    } else {
        if (currentIdx==_arrViewController.count-1) {
            return nil;
        }
        nextIdx = currentIdx+1;
        return _arrViewController[nextIdx];
    }
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
   
    if (_hidePageIndicator==YES) {
        return 0;
    }
    return _arrViewController.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
   
    return 0;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    _currentIndex = [_arrViewController indexOfObject:[self.viewControllers objectAtIndex:0]];
    [self.mDelegate scrolledToIndex:_currentIndex];
    
}

#pragma mark -  internal methods -
-(void)getToIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index>_currentIndex) {
        [self setViewControllers:@[_arrViewController[index]] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:nil];
    }
    else{
        [self setViewControllers:@[_arrViewController[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:animated completion:nil];
    }
    _currentIndex = index;
    
    [self.mDelegate scrolledToIndex:_currentIndex];

}

@end
