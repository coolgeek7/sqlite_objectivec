//
//  DbUtil.m
//  sqlite
//
//  Created by Hemant Raj Singh on 8/2/18.
//  Copyright © 2018 Hemant Raj Singh. All rights reserved.
//

#import "DbUtil.h"

@implementation DbUtil

//@synthesize databasePath;

+ (NSString *)createFileLocation:(NSString *)location{
    
    NSError *error;
    @try{
        if(![[NSFileManager defaultManager]fileExistsAtPath:location]){
            if(![[NSFileManager defaultManager] createDirectoryAtPath:location withIntermediateDirectories:YES attributes:nil error:&error]){
                NSLog(@"Create directory error: %@",&error);
                return NULL;
            }
        }
        return location;
    }
    @catch(NSException *exception){
        NSLog(@"Exception: %@",exception);
    }
}


- (void)initDatabase{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *fullPathDirectory = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"sqlite"]];
    NSString *createdPathDirectory = [DbUtil createFileLocation:fullPathDirectory];
    NSLog(@"Created path directory %@",createdPathDirectory);
    
    //Build path to database file
    databasePath = [[NSString alloc]initWithString:[createdPathDirectory stringByAppendingPathComponent:@"employees.db"]];
    NSLog(@"database path is %@",databasePath);
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    
    if([fileMgr fileExistsAtPath:databasePath]==NO){
        const char *dbPath = [databasePath UTF8String];
        
        if(sqlite3_open(dbPath, &mySqliteDb)==SQLITE_OK){
            char *errMsg;
            NSString *query = @"CREATE TABLE IF NOT EXISTS EMPLOYEES (";
            query = [query stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
            query = [query stringByAppendingString:@"name TEXT, "];
            query = [query stringByAppendingString:@"department TEXT, "];
            query = [query stringByAppendingString:@"age INTEGER)"];
            
            if(sqlite3_exec(mySqliteDb, [query UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
                NSLog(@"Failed to create table");
            }
            else{
                NSLog(@"Employees table created successfully");
            }
            sqlite3_close(mySqliteDb);
        }
        else{
            NSLog(@"Failed to open / create database");
        }
    }
    
    else{
        NSLog(@"File already exists");
    }
    
}

- (BOOL)saveEmployee:(Employee *)employee{
    
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    NSLog(@"From save employee db path: %@",dbpath);
    
    if(sqlite3_open(dbpath, &mySqliteDb)==SQLITE_OK){
        
        NSLog(@"Inserting data");
        NSString *query = [NSString stringWithFormat:@"INSERT INTO EMPLOYEES(name,department,age) VALUES(\"%@\",\"%@\",%ld)",employee.name,employee.department,(long)employee.age];
        
        const char *insert_stmt = [query UTF8String];
//        sqlite3_prepare_v2(mySqliteDb,insert_stmt,-1,&statement,NULL);
//        if(sqlite3_step(statement)==SQLITE_DONE){
//            success = true;
//        }
        char *errMsg;
        if(sqlite3_exec(mySqliteDb, insert_stmt, NULL, NULL, &errMsg)==SQLITE_OK){
            success = true;
            NSLog(@"Inserted successfully");
        }
        else{
            NSLog(@"Failed inserting error:%s",errMsg);
        }
        
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(mySqliteDb);
    
    return success;
}

- (BOOL)deleteEmployee:(Employee *)employee{
    
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbPath = [databasePath UTF8String];
    
    if(sqlite3_open(dbPath, &mySqliteDb)==SQLITE_OK){
        
        if(employee.employeeId>0){
            NSString *query = [NSString stringWithFormat:@"DELETE FROM EMPLOYEES WHERE id=?"];
            
            const char *delete_stmt = [query UTF8String];
            
            sqlite3_prepare_v2(mySqliteDb, delete_stmt, -1, &statement, NULL);
            sqlite3_bind_int(statement, 1, employee.employeeId);
            if(sqlite3_step(statement)==SQLITE_DONE){
                success = true;
            }
            else{
                NSLog(@"New data, nothing to delete");
                success = true;
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(mySqliteDb);
        }
        
    }
    
    
    return success;
}

- (Employee *)getEmployee:(NSInteger)employeeId{
    
    Employee *employee = [[Employee alloc]init];
    const char *dbPath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if(sqlite3_open(dbPath, &mySqliteDb)==SQLITE_OK){
        NSString *query = [NSString stringWithFormat:@"SELECT id,name,department,age FROM EMPLOYEES where id=%d",employeeId];
        const char *query_stmt = [query UTF8String];
        
        if(sqlite3_prepare_v2(mySqliteDb, query_stmt, -1, &statement, NULL)==SQLITE_OK){
            if(sqlite3_step(statement)==SQLITE_ROW){
                employee.employeeId = sqlite3_column_int(statement, 0);
                employee.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                employee.department = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                employee.age = sqlite3_column_int(statement, 3);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDb);
    }
    
    return employee;
}

- (NSMutableArray *)getEmployees{
    
    NSMutableArray *employeeList = [[NSMutableArray alloc]init];
    const char *dbPath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if(sqlite3_open(dbPath, &mySqliteDb)==SQLITE_OK){
        
        NSString *query = @"SELECT id,name,department,age FROM EMPLOYEES";
        const char query_stmt = [query UTF8String];
        
        if(sqlite3_prepare_v2(mySqliteDb,query_stmt,-1,&statement,NULL)==SQLITE_OK){
            
            while (sqlite3_step(statement)==SQLITE_ROW) {
                Employee *employee = [[Employee alloc]init];
                employee.employeeId = sqlite3_column_int(statement, 0);
                employee.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                employee.department = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                employee.age = sqlite3_column_int(statement, 4);
                [employeeList addObject:employee];
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(mySqliteDb);
        
    }
    
    return employeeList;
}

@end
