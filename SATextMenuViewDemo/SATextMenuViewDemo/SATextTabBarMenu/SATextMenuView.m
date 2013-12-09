//
//  SATextMenuView.m
//  SATextTabMenuDemo
//
//  Created by katsuhisa.ishii on 2013/11/26.
//  Copyright (c) 2013年 katsuhisa.ishii. All rights reserved.
//

#import "SATextMenuView.h"

@interface SATextMenuView ()
<
UIScrollViewDelegate
>

@property(nonatomic,strong) NSMutableArray* menuArr;
@property(nonatomic,strong) UIPageControl* pageControl;
@property(nonatomic,strong) UIScrollView* scrollView;

@end

@implementation SATextMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _enableFont = [UIFont fontWithName:@"Helvetica" size:17.0f];
    _enableColor = [UIColor colorWithRed:0
                                   green:0.4784314
                                    blue:1
                                   alpha:1];
    
    _disableFont = [UIFont fontWithName:@"Helvetica Light" size:15.0f];
    _disableColor = [UIColor grayColor];
    
    //PageControl
    CGFloat pageControlHeight = 37.0f;
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                   self.frame.size.height - pageControlHeight,
                                                                   self.frame.size.width,
                                                                   pageControlHeight)];
    [self addSubview:_pageControl];
    
    //ScrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
}

//--------------------------------------------------
#pragma mark - Public
//--------------------------------------------------
- (void)setupWithTitles:(NSArray*)titles
{
    _scrollView.delegate = self;
    _menuArr = [NSMutableArray new];
    
    for (NSString* title in titles) {
        [self addMenuWithTitle:title];
    }
    
    [self createMenu];
}

- (void)selectMenuWithIndex:(NSInteger)index
{
    NSMutableDictionary* menuDic = _menuArr[index];
    UIButton* btn = menuDic[@"button"];
    
    [self actionMenuButton:btn];
}

- (void)selectMenuWithIndex:(NSInteger)index move:(BOOL)move
{
    [self selectMenuWithIndex:index];
    if( move ){
        CGFloat x = (self.frame.size.width / 3) * index;
        _pageControl.currentPage = x / self.frame.size.width;
        
        [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * self.frame.size.width, 0) animated:YES];
        
    }
}

//--------------------------------------------------
#pragma mark - Private
//--------------------------------------------------
- (void)addMenuWithTitle:(NSString*)title
{
    NSMutableDictionary* menuDic = [ @{@"title":title} mutableCopy];
    [_menuArr addObject:menuDic];
}

- (void)createMenu
{
    NSInteger tag = 0;
    CGFloat width = self.frame.size.width / 3;
    CGFloat height = self.frame.size.height;
    CGFloat right = 0;
    BOOL isFirst = YES;
    
    for (NSMutableDictionary* menuDic in _menuArr) {
        NSString* title = menuDic[@"title"];
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = CGRectMake(right, 0, width,height);
        btn.tag = tag;
        [btn.titleLabel setFont:_disableFont];
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btn.titleLabel.numberOfLines = 2;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:_disableColor forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        menuDic[@"button"] = btn;
        
        [_scrollView addSubview:btn];
        
        [btn addTarget:self action:@selector(actionMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        
        right += width;
        tag++;
        isFirst = NO;
    }
    
    //add remainder width
    NSInteger remainder = _menuArr.count % 3;
    right += (width * remainder);
    
    _pageControl.pageIndicatorTintColor = _disableColor;
    _pageControl.currentPageIndicatorTintColor = _enableColor;
    _pageControl.numberOfPages = ([_menuArr count] / 3) + 1;
    if( ([_menuArr count] % 3 == 0) && (_pageControl.numberOfPages >= 1) ){
        _pageControl.numberOfPages--;
    }
    _pageControl.currentPage = 0;
    _pageControl.alpha = 0.8f;
    
    if( _pageControl.numberOfPages <= 1 ){
        _pageControl.hidden = YES;
    }
    
    _scrollView.contentSize = CGSizeMake(right, 44.0f);
}

//--------------------------------------------------
#pragma mark - Delegate
//--------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / self.frame.size.width;
    if( scrollView.contentOffset.x > self.frame.size.width * _pageControl.currentPage ){
        _pageControl.currentPage++;
    }
}

//--------------------------------------------------
#pragma mark - Action
//--------------------------------------------------
- (void)actionPageControl:(id)sender
{
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*_pageControl.currentPage, 0) animated:YES];
}

- (void)actionMenuButton:(id)sender
{
    NSLog(@"actionMenuButton");
    
    UIButton* targetBtn = (UIButton*)sender;
    
    for (UIView* subView in [_scrollView subviews]) {
        if( [subView isKindOfClass:[UIButton class]] == NO ){
            continue;
        }
        
        UIButton* btn = (UIButton*)subView;
        if( targetBtn.tag == btn.tag ){
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 [btn setTitleColor:_enableColor forState:UIControlStateNormal];
                                 [btn.titleLabel setFont:_enableFont];
                                 btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:0.2f
                                                  animations:^{
                                                      btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                  }
                                                  completion:nil];
                             }];
        }
        else{
            [btn setTitleColor:_disableColor forState:UIControlStateNormal];
            [btn.titleLabel setFont:_disableFont];
        }
        
    }
    
    if( _delegate ){
        [_delegate textMenuView:self index:targetBtn.tag title:targetBtn.titleLabel.text];
    }
}

@end
