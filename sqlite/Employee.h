//
//  Employee.h
//  sqlite
//
//  Created by Hemant Raj Singh on 8/2/18.
//  Copyright © 2018 Hemant Raj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject

@property(nonatomic) NSInteger employeeId;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *department;
@property(nonatomic) NSInteger age;

@end
