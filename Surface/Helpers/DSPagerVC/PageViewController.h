//
//  PageViewController.h
//  ContainerTabDemo
//
//  Created by Deepak Saxena on 03/05/17.
//  Copyright © 2017 rnf. All rights reserved.

#import <UIKit/UIKit.h>

@class PageViewController;

@protocol PageViewControllerProtocol <NSObject>

-(void)scrolledToIndex:(NSInteger)index;
-(void)pageViewDidScroll:(UIScrollView*)scrollView;

@end

@interface PageViewController : UIPageViewController

@property(nonatomic,strong) NSArray<UIViewController*> *arrViewController;

@property(nonatomic,weak) id <PageViewControllerProtocol> mDelegate ;

@property(assign,nonatomic,readonly) NSInteger currentIndex;
@property(assign,nonatomic) BOOL circular;
@property(assign,nonatomic) BOOL hidePageIndicator;


-(void)getToIndex:(NSInteger)index animated:(BOOL)animated;

@end
