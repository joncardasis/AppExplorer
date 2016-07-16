//
//  DirectoryReader.m
//  AppExplorer
//
//  Created by Cardasis, Jonathan (J.) on 7/13/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

#import "DirectoryReader.h"

#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>

@implementation DirectoryReader


+ (void) printContents: (const char*) path{
    DIR *d;
    struct dirent *dir;
    d = opendir(path);
    if (d){
        while((dir = readdir(d)) != NULL){
            NSLog(@"%s", dir->d_name);
        }
    }
}

+ (BOOL) is_file: (const char*) path {
    struct stat path_stat;
    stat(path, &path_stat);
    return S_ISREG(path_stat.st_mode);
}

+ (int64_t) size_of_file: (const char*) path{
    struct stat path_stat;
    if (stat(path, &path_stat) != 0)
        return false;
    return path_stat.st_size;
}

+ (BOOL) is_dir: (const char*) path {
    struct stat path_stat;
    if (stat(path, &path_stat) != 0)
        return false;
    return S_ISDIR(path_stat.st_mode);
}

@end
