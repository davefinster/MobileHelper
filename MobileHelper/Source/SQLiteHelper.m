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

#import "SQLiteHelper.h"
#import "MobileHelper.h"

@implementation SQLiteHelper

+(sqlite3 *) defaultDatabase{
	static sqlite3 *db;
	@synchronized(self){
		if (db == nil) {
			sqlite3_open([DEFAULT_DATABASE_PATH UTF8String], &db);
		}
	}
	return db;
}

+(sqlite3_stmt *) statementForQuery:(NSString *)query{
	sqlite3_stmt *preparedStatement;
	const char *utfStatement = [query UTF8String];
	sqlite3_prepare_v2([SQLiteHelper defaultDatabase], utfStatement, -1, &preparedStatement, NULL);
	return preparedStatement;
}

+(BOOL) tableExists:(NSString *)tableName{
	NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@'", tableName];
	sqlite3_stmt *statement = [SQLiteHelper statementForQuery:query];
	NSInteger result = 0;
	if (sqlite3_step(statement) == SQLITE_ROW) {
		result = [SQLiteHelper integerFromQuery:statement inColumn:0];
	}
	sqlite3_finalize(statement);
	return [SQLiteHelper booleanForInt:result];
}
			
+(BOOL) booleanForInt:(NSInteger)integer{
	if (integer > 0) {
		return YES;
	}else {
		return NO;
	}
}

+(BOOL) integerValueExists:(NSInteger)value forColumn:(NSString *)columnName inTable:(NSString *)table{
	NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@=%d", table, columnName, value];
	sqlite3_stmt *statement = [SQLiteHelper statementForQuery:query];
	NSInteger result = -1;
	if (sqlite3_step(statement)) {
		result = [SQLiteHelper integerFromQuery:statement inColumn:0];
	}
	sqlite3_finalize(statement);
	return [SQLiteHelper booleanForInt:result];
}

+(BOOL) stringValueExists:(NSString *)value forColumn:(NSString *)columnName inTable:(NSString *)table{
	NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@='%@'", table, columnName, value];
	sqlite3_stmt *statement = [SQLiteHelper statementForQuery:query];
	NSInteger result = -1;
	if (sqlite3_step(statement)) {
		result = [SQLiteHelper integerFromQuery:statement inColumn:0];
	}
	sqlite3_finalize(statement);
	return [SQLiteHelper booleanForInt:result];
}

+(NSInteger) intForBoolean:(BOOL)boolean{
	if (boolean) {
		return 1;
	}else {
		return 0;
	}
}

+(NSInteger) integerFromQuery:(sqlite3_stmt *)statement inColumn:(NSInteger)colNum{
	return [[SQLiteHelper stringFromQuery:statement inColumn:colNum] intValue];
}

+(NSInteger) numRecordsInTable:(NSString *)tableName{
	NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM %@", tableName];
	sqlite3_stmt *statement = [SQLiteHelper statementForQuery:query];
	NSInteger count = -1;
	if (sqlite3_step(statement) == SQLITE_ROW) {
		count = [SQLiteHelper integerFromQuery:statement inColumn:0];
	}
	sqlite3_finalize(statement);
	return count;
}

+(NSInteger) indexForColumn:(NSString *)column inTable:(NSString *)table{
	static NSMutableDictionary *tableData;
	@synchronized(self){
		if (tableData == nil) {
			tableData = [[NSMutableDictionary alloc] init];
		}
	}
	if (![[tableData allKeys] containsObject:table]) {
		NSString *query = [NSString stringWithFormat:@"pragma table_info(%@)", table];
		sqlite3_stmt *statement = [SQLiteHelper statementForQuery:query];
		if (statement) {
			NSMutableArray *columns = [[NSMutableArray alloc] init];
			while (sqlite3_step(statement) == SQLITE_ROW) {
				NSString *columnName = [SQLiteHelper stringFromQuery:statement inColumn:1];
				[columns addObject:columnName];
			}
			[tableData setValue:columns forKey:table];
			[columns release];
			sqlite3_finalize(statement);
		}else {
			return -1;
		}
	}
	NSMutableArray *array = [tableData valueForKey:table];
	NSInteger index = -1;
	for (int i = 0; i < [array count]; i++) {
		if ([(NSString *)[array objectAtIndex:i] isEqualToString:column]) {
			index = i;
			break;
		}
	}
	return index;
}

+(NSString *) stringFromQuery:(sqlite3_stmt *)statement inColumn:(NSInteger)colNum{
	const char *columnText = (const char *)sqlite3_column_text(statement, colNum);
	if (columnText != NULL) {
		return [NSString stringWithUTF8String:columnText];
	}else {
		return @"";
	}
}

+(NSArray *) resultsForQuery:(NSString *)query{
	sqlite3_stmt *statement = [SQLiteHelper statementForQuery:query];
	NSMutableArray *array = nil;
	if (statement) {
		array = [[NSMutableArray alloc] init];
		NSInteger numColumns = -1;
		while (sqlite3_step(statement) == SQLITE_ROW) {
			if (numColumns == -1) {
				numColumns = sqlite3_column_count(statement);
			}
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
			for (int i = 0; i < numColumns; i++) {
				NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
				[dict setValue:[SQLiteHelper stringFromQuery:statement inColumn:i] forKey:columnName];
				[columnName release];
			}
			[array addObject:dict];
			[dict release];
		}
		[array autorelease];
	}
	return array;
}

@end
