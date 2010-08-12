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
#import <UIKit/UIKit.h>

@interface FileHelper : NSObject {

}

/**
 * Returns the path to the documents directory of the current application
 */
+(NSString *) documentsDirectory;

/**
 * Returns the path to a file named "fileName" in the documents 
 * directory.
 */
+(NSString *) documentsPathForFileNamed:(NSString *)fileName;

/**
 * Returns the path to the temporary data directory of the 
 * current application
 */
+(NSString *) temporaryDirectory;

/**
 * Returns the path to a file named "fileName" in the temporary data 
 * directory of the current application
 */
+(NSString *) temporaryPathForFileNamed:(NSString *)fileName;

/**
 * Saves the specified image to the documents directory with a 
 * random filename based on the current time interval since 1970 
 * and a random number. Images are saved in PNG format. Returns 
 * the path to the newly created file.
 */
+(NSString *) saveImageToFile:(UIImage *)image;

@end
