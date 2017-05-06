//
//  LoginViewController.m
//  DanceBUG
//
//  Created by Neth-Mobile on 11/9/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "EventListViewController.h"

@interface LoginViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property NSString *username;
@property NSString *password;
@property UIActivityIndicatorView *spinner;

@property NSMutableArray *request;
@end

@implementation LoginViewController

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * 1.5);
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    //set up layer
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, height)];
    
    self.usernameTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    self.usernameTextField.layer.borderWidth = 1;
    self.usernameTextField.layer.cornerRadius = 5;
    
    self.usernameTextField.leftView = paddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTextField.delegate = self;
    
    self.passwordTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.passwordTextField.layer.borderWidth = 1;
    self.passwordTextField.layer.cornerRadius = 5;
    
    UIView *paddingViewOfPW = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, height)];
    self.passwordTextField.leftView = paddingViewOfPW;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.frame = CGRectMake(width * 0.45, height * 0.45, width * 0.1, width * 0.1);
    _spinner.color = [UIColor whiteColor];
    _spinner.hidesWhenStopped = YES;
    
}

- (IBAction)loginButtonPress:(id)sender {
    [self dismissKeyboard];
    [self login];
}

-(void)login {
    
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    
    _username = self.usernameTextField.text;
    _password = self.passwordTextField.text;
    
    NSDictionary *dictionary = @{@"username" : _username,
                                 @"password" : _password,
                                 @"device" : @{ @"model" : @"Roku 2 XS",
                                                @"hardware" : @"3050X",
                                                @"firmware" : @"7.1.1185",
                                                @"id" : @"407BBFB9-847D-40EF-9797-B37103DD4A66",
                                                @"aspect_ratio" : @"16x9",
                                                @"video_mode" : @"720p"
                                                },
                                 @"app" : @{ @"name" : @"DanceBug",
                                             @"version" : @"1.1.52"
                                             }
                                 };
    NSError *error = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dancebug.com/rest/mobi/login/index.php"]];
    [request setHTTPMethod:@"POST"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(data){
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"============%@", json);
            NSString *error = [json objectForKey:@"error"];
            if([error isEqualToString:@"200"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_spinner stopAnimating];
                    NSString *string = @"Success";
                    [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"loggedIn"];
                    [self moveToEventListVC];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_spinner stopAnimating];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Invalid Login Information" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Please Check Your Network Connectivity!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:done];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
    }];
    [task resume];

}

-(void) moveToEventListVC {
    
    EventListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventListVC"];
    [[self navigationController]pushViewController:vc animated:YES];
}

//- (IBAction)creatAccountButtonPress:(id)sender {
//    
//    SignUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpVC"];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//-(void) moveToMetaDataVC {
//    
//    MetaDataViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"metaDataVC"];
//    [[self navigationController]pushViewController:vc animated:YES];
//}
//
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    CGRect newFrame = CGRectMake(0, -self.view.frame.size.height * 0.23, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView animateWithDuration:0.3f animations:^{
//        self.view.frame = newFrame;
//    }];
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.usernameTextField){
        [self.passwordTextField becomeFirstResponder];
    }else{
        [self dismissKeyboard];
        [self login];
    }
    return YES;
}
-(void)dismissKeyboard {
    
    CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = newFrame;
    }];
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissKeyboard];
}

- (IBAction)forgotPassword:(id)sender {
    [self dismissKeyboard];
    NSString * username;
    _username = self.usernameTextField.text;
    if(_username.length>0){
        username = _username;
    }else{
        self.usernameTextField.layer.borderColor = [[UIColor redColor]CGColor];
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"This field is required" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]}];
        self.usernameTextField.attributedPlaceholder = str;
        return;
    }
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    NSDictionary *dictionary = @{@"username" : username,
                                 @"apikey": @"407BBFB9-847D-40EF-9797-B37103DD4A66"
                                };
    NSError *error = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://dancebug.com/rest/mobi/forgot_password/index.php"]];
    [request setHTTPMethod:@"POST"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];

    [request setHTTPBody:jsonData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(data){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *responseStr = [json objectForKey:@"response"];
            NSString *message = [json objectForKey:@"message"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseStr message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_spinner stopAnimating];
            });
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Please Check Your Network Connectivity!" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_spinner stopAnimating];
            });
        }
    }];
    [task resume];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.placeholder = @"";
    textField.layer.borderColor = [[UIColor whiteColor]CGColor];
}

@end
