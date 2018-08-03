//
//  DbUtil.h
//  sqlite
//
//  Created by Hemant Raj Singh on 8/2/18.
//  Copyright © 2018 Hemant Raj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Employee.h"

static NSString *databasePath;
@interface DbUtil : NSObject{
    sqlite3 *mySqliteDb;
}

//@property (nonatomic,strong) NSString *databasePath;

+(NSString *) createFileLocation:(NSString *) location;
-(void) initDatabase;
-(BOOL) saveEmployee:(Employee *)employee;
-(BOOL) deleteEmployee:(Employee *)employee;
-(NSMutableArray *) getEmployees;
-(Employee *) getEmployee:(NSInteger)employeeId;

@end
