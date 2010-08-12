/*
 * Copyright 2010 Dave Finster
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteHelper : NSObject {

}
/**
 * Provides access to a single session of the local database as defined in 
 * MobileHelper.h. If the file does not exist, it is created.
 */
+(sqlite3 *) defaultDatabase;

/**
 * Converts the specified string to UTF8 and returns the prepared sqlite3
 * statement ready for executing in sqlite3_step. Returns nil if the 
 * provided query could not be prepared
 */
+(sqlite3_stmt *) statementForQuery:(NSString *)query;

/**
 * Checks to see if a table with the name tableName exists in the default
 * database
 */
+(BOOL) tableExists:(NSString *)tableName;

/**
 * Converts an integer to a boolean. It uses basic interpretation of
 * booleans in that anything above 0 is YES, 0 is NO
 */
+(BOOL) booleanForInt:(NSInteger)integer;

/**
 * Checks to see if the specified integer value exists in the specified 
 * column in the specified table. 
 */
+(BOOL) integerValueExists:(NSInteger)value forColumn:(NSString *)columnName inTable:(NSString *)table;

/**
 * Checks to see if the specified string value exists in the specified 
 * column in the specified table. 
 */
+(BOOL) stringValueExists:(NSString *)value forColumn:(NSString *)columnName inTable:(NSString *)table;

/**
 * Converts a boolean to an integer using basic interpretation of 
 * booleans in that YES is 1 and NO is 0.
 */
+(NSInteger) intForBoolean:(BOOL)boolean;

/**
 * Retrieves an integer result from the column indexed by colNum from 
 * a successful query.
 */
+(NSInteger) integerFromQuery:(sqlite3_stmt *)statement inColumn:(NSInteger)colNum;

/**
 * Returns the number of rows in the specified table. Returns -1 if 
 * the table does not exist or another failure occured.
 */
+(NSInteger) numRecordsInTable:(NSString *)tableName;

/**
 * Returns the index of the column named "column" in the specified table. 
 * The returned index assumes a SELECT * query and uses the table structure 
 * as defined in the database.
 */
+(NSInteger) indexForColumn:(NSString *)column inTable:(NSString *)table;

/**
 * Retrieves an string result from the column indexed by colNum from 
 * a successful query.
 */
+(NSString *) stringFromQuery:(sqlite3_stmt *)statement inColumn:(NSInteger)colNum;

/**
 * Executes the provided query and returns the status code. This method 
 * is used for queries which produce no results, but the success of 
 * which still needs to be tracked.
 */
+(NSInteger) executeQuery:(NSString *)query;

/**
 * Executes the provided query, returning an array of dictionaries.
 * The keys of the dictionary correspond to the column names of the 
 * columns returned in the query, with the values all being NSString objects
 * Each entry in the array corresponds to a result row from the query
 */
+(NSArray *) resultsForQuery:(NSString *)query;

@end
