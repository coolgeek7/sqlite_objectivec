//
//  ViewController.m
//  sqlite
//
//  Created by Hemant Raj Singh on 8/2/18.
//  Copyright © 2018 Hemant Raj Singh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dbUtil = [[DbUtil alloc]init];
    [dbUtil initDatabase];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)insertEmployee:(id)sender {
    
    dbUtil = [[DbUtil alloc]init];
    Employee *employee = [[Employee alloc]init];
    employee.name = @"user1";
    employee.department = @"New User";
    employee.age = 20;
    BOOL success = [dbUtil saveEmployee:employee];
    if(success == YES){
        NSLog(@"Employee saved successfully");
    }else{
        NSLog(@"Error");
//        ViewController *viewController = [[ViewController alloc]init];
//        [viewController createAlert:@"Error inserting employee"];
    }
    
    
}

- (IBAction)deleteEmployee:(id)sender {
}
- (IBAction)findEmployee:(id)sender {
}
- (IBAction)listEmployee:(id)sender {
}


-(IBAction) createAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    int duration = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
