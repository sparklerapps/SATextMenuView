//
//  SATextMenuView.h
//  SATextTabMenuDemo
//
//  Created by katsuhisa.ishii on 2013/11/26.
//  Copyright (c) 2013年 katsuhisa.ishii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SATextMenuView;

@protocol SATextMenuViewDelegate

- (void)textMenuView:(SATextMenuView*)menu index:(NSInteger)index title:(NSString*)title;

@end


@interface SATextMenuView : UIView

@property(nonatomic,weak) id<SATextMenuViewDelegate> delegate;

//enable menu property
@property(nonatomic,strong) UIFont* enableFont;
@property(nonatomic,strong) UIColor* enableColor;

//disable menu property
@property(nonatomic,strong) UIFont* disableFont;
@property(nonatomic,strong) UIColor* disableColor;

- (void)setupWithTitles:(NSArray*)titles;
- (void)selectMenuWithIndex:(NSInteger)index move:(BOOL)move;

@end
