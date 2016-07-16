//
//  DirectoryReader.h
//  AppExplorer
//
//  Created by Cardasis, Jonathan (J.) on 7/13/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectoryReader : NSObject

+ (void) printContents: (const char*) path;
+ (BOOL) is_file: (const char*) path;
+ (int64_t) size_of_file: (const char*) path;
+ (BOOL) is_dir: (const char*) path;



@end
