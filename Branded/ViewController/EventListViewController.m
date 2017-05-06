//
//  EventListViewController.m
//  Branded
//
//  Created by Mac on 5/4/17.
//  Copyright © 2017 DRCVideo. All rights reserved.
//

#import "EventListViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad

@interface EventListViewController ()
{
    UIView *tapView;
    UIView *sideMenuView;
    
    CGFloat screenW;
    CGFloat screenH;
    CGRect sideMenuFrame;
    
    NSInteger menupressed;
}
@end

@implementation EventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenW = [UIScreen mainScreen].bounds.size.width;
    screenH = [UIScreen mainScreen].bounds.size.height;
}

- (IBAction)sideMenu:(id)sender {
    [self canvasDragMenu];
}

-(void)canvasDragMenu{
    CGFloat toggleViewWidth;
    CGFloat toggleViewheight;
    
    if(IDIOM == IPAD){
        toggleViewWidth = screenW * 489/2048;
        toggleViewheight = screenH * 1958/2208;
    }else{
        toggleViewWidth = screenW * 489/1242;
        toggleViewheight = screenH * 1958/2208;
    }
    
    CGFloat subviewWidth = toggleViewWidth;
    CGFloat subviewHeight = toggleViewheight * 128/1958;
    
    if(menupressed == 0){
        
        tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        UITapGestureRecognizer *taped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMenu)];
        [tapView addGestureRecognizer:taped];
        [self.view addSubview: tapView];
        
        sideMenuView = [[UIView alloc]initWithFrame:CGRectMake(-screenW, self.header.frame.size.height, toggleViewWidth, toggleViewheight)];
        sideMenuFrame = sideMenuView.frame;
        
        UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, subviewWidth, subviewHeight)];
        addView.backgroundColor = [UIColor whiteColor];
        addView.layer.opacity = 1.0;
        addView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapForAdd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logout)];
        [addView addGestureRecognizer:tapForAdd];
        
        UIButton *addbutton = [[UIButton alloc]initWithFrame:CGRectMake(10, (subviewHeight - 21)/2, 21, 21)];
        [addbutton setBackgroundImage:[UIImage imageNamed:@"logouticon.png"] forState:UIControlStateNormal];
        [addbutton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, (subviewHeight - 20)/2, 200, 20)];
        addLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:3.0/255.0 blue:86.0/255.0 alpha:1.0];
        addLabel.text = @"LOGOUT";
        [addLabel setFont:[UIFont fontWithName:@"Century Gothic" size:16]];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, subviewHeight-1.5, subviewWidth, 1.5)];
        line.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:3.0/255.0 blue:86.0/255.0 alpha:1.0];
        
        [addView addSubview:addbutton];
        [addView addSubview:addLabel];
        [addView addSubview:line];
        
        UIView *logoutView = [[UIView alloc]initWithFrame:CGRectMake(0, subviewHeight, subviewWidth, subviewHeight)];
        logoutView.backgroundColor = [UIColor whiteColor];
        logoutView.layer.opacity = 0.8;
        
        UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, subviewHeight * 2 , toggleViewWidth, toggleViewheight * 1704/1958)];
        background.backgroundColor = [UIColor whiteColor];
        background.layer.opacity = 0.8;
        
        [sideMenuView addSubview:addView];
        [sideMenuView addSubview:logoutView];

        
        //animation
        CGRect newFrame = CGRectMake(0, self.header.frame.size.height, toggleViewWidth, toggleViewheight);
        [UIView animateWithDuration:0.5f animations:^{
            sideMenuView.frame = newFrame;
        }];
        [self.view addSubview:sideMenuView];
        menupressed = 1;
    }else{
        
        [tapView removeFromSuperview];
        CGRect newFrame = CGRectMake(-toggleViewWidth, self.header.frame.size.height, toggleViewWidth, toggleViewheight);
        [UIView animateWithDuration:0.5f animations:^{
            sideMenuView.frame = newFrame;
        }];
        
        menupressed = 0;
    }
    
}

//-(void)addVideosAndPhotos {
//    
//    OrderViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"orderVC"];
//    [[self navigationController]pushViewController:vc animated:YES];
//    [sideMenuView setFrame:sideMenuFrame];
//}

-(void)logout {
    
    NSString *string = @"logout";
    [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"loggedIn"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginVC"];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:loginVC];
    nc.navigationBar.barStyle = UIStatusBarStyleLightContent;
    nc.navigationBar.hidden = YES;
    appDelegate.window.rootViewController = nc;
    
}

-(void)dismissMenu {
    if(menupressed == 1){
        [self canvasDragMenu];
    }
}


@end

