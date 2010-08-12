//
//  FileHelper.m
//  MobileHelper
//
//  Created by Dave Finster on 12/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileHelper.h"


@implementation FileHelper

+(NSString *) documentsDirectory{
	static NSString *docPath;
	if (docPath == nil) {
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		docPath = [[searchPaths objectAtIndex:0] retain];
	}
	return docPath;
}

+(NSString *) documentsPathForFileNamed:(NSString *)fileName{
	return [[FileHelper documentsDirectory] stringByAppendingPathComponent:fileName];
}

+(NSString *) temporaryDirectory{
	static NSString *tempPath;
	if (tempPath == nil) {
		tempPath = [NSTemporaryDirectory() retain];
	}
	return tempPath;
}

+(NSString *) temporaryPathForFileNamed:(NSString *)fileName{
	return [[FileHelper temporaryDirectory] stringByAppendingPathComponent:fileName];
}

+(NSString *) saveImageToFile:(UIImage *)image{
	NSString *fileName = [NSString stringWithFormat:@"%d%d.png", abs([[NSDate date] timeIntervalSince1970]), arc4random()];
	NSString *filePath = [FileHelper documentsPathForFileNamed:fileName];
	[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
	return fileName;
}

@end
