//  Invocator.m
//
//  Created by Jonathan Cardasis on 8/8/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//
//  This class uses the ObjC exclusive NSInvocation in order to call selectors on
//  a class with ANY of arguments.
//
//

#import <UIKit/UIKit.h>
@import Foundation;


@interface Invocator : NSObject
+ (nullable id) performClassSelector:(nonnull SEL)selector target:(nonnull id)target args: (nullable NSArray*)args;
@end

@implementation Invocator
/*
 Will perform a selector on a Class for any number of args.
*/
+ (nullable id) performClassSelector:(nonnull SEL)selector target:(nonnull id)target args: (nullable NSArray*)args {
    NSMethodSignature *methodSignature = [UIImage methodSignatureForSelector:selector];
    NSInvocation *methodInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    [methodInvocation setTarget:[target class]];
    [methodInvocation setSelector: selector];
    
    //Assign arguments to invocation
    for(int i=0; i < args.count; i++){
        id arg = [args objectAtIndex:i];

        /* Assign proper format if the object is a double or float */
        /* NOTE THIS FUNCTION DOES NOT FULLY SUPPORT BOOLS and Swift BOOLEANS! */
        if([arg isKindOfClass: [NSNumber class]]){
            CFNumberType argType = CFNumberGetType((CFNumberRef)arg);
            
            if(argType == kCFNumberDoubleType || argType == kCFNumberFloat64Type){
                double num = [arg doubleValue];
                [methodInvocation setArgument:&num atIndex:i+2];
            }
            else if (argType == kCFNumberFloatType || argType == kCFNumberFloat32Type){
                float num = [arg floatValue];
                [methodInvocation setArgument:&num atIndex:i+2];
            }
            else{
                [methodInvocation setArgument:&arg atIndex:i+2];
            }
        }
        
        else{
            [methodInvocation setArgument:&arg atIndex:i+2];
        }
    }
    
    //Execute
    [methodInvocation invoke];
    id __unsafe_unretained result;
    [methodInvocation getReturnValue:&result];
    
    return result;
}

@end
