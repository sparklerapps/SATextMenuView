//
//  ViewController.m
//  SATextTabMenuDemo
//
//  Created by katsuhisa.ishii on 2013/11/26.
//  Copyright (c) 2013年 katsuhisa.ishii. All rights reserved.
//

#import "ViewController.h"

#import "SATextMenuView.h"

@interface ViewController ()
<
SATextMenuViewDelegate
>

@property(nonatomic,weak) IBOutlet UILabel* label;

@property(nonatomic,strong) SATextMenuView* menu;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init
    _menu = [[SATextMenuView alloc] initWithFrame:CGRectMake(0,
                                                             self.view.bounds.size.height - 100,
                                                             self.view.bounds.size.width,
                                                             100)];
    
    //set delegate
    _menu.delegate = self;
    
    //set titles
    [_menu setupWithTitles:@[@"menu1",@"menu2",@"menu3\n(multi line)",@"menu4",@"menu5",@"menu6"]];
    
    [self.view addSubview:_menu];
    
    //initial selected index
    [_menu selectMenuWithIndex:0 move:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButton:(UIButton*)sender
{
    [_menu selectMenuWithIndex:sender.tag move:YES];
}

//--------------------------------------------------
#pragma mark - Delegate
//--------------------------------------------------
#pragma mark === SATextMenuViewDelegate ===
//--------------------------------------------------
- (void)textMenuView:(SATextMenuView*)menu index:(NSInteger)index title:(NSString *)title
{
    title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    [_label setText:[NSString stringWithFormat:@"selected menu\nindex[%ld]\ntitle[%@]",index,title]];
}

@end
