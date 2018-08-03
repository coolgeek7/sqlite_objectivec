//
//  ViewController.h
//  sqlite
//
//  Created by Hemant Raj Singh on 8/2/18.
//  Copyright © 2018 Hemant Raj Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbUtil.h"
#import "Employee.h"

@interface ViewController : UIViewController{
    DbUtil *dbUtil;
}
@property (weak, nonatomic) IBOutlet UIButton *btnInsert;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnFindEmployee;
@property (weak, nonatomic) IBOutlet UIButton *btnListEmployee;


@end

