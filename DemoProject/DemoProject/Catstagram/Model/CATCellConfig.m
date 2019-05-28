//
//  CATCellConfig.m
//  Catstagram-Starter
//
//  Created by Luke Parham on 4/10/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

#import "CATCellConfig.h"

@interface CATCellConfigName : NSObject
@end

@implementation CATCellConfigName : NSObject
@end

@interface CATCellConfig ()
@property (nonatomic, retain) CATCellConfigName *configName;
@end

@implementation CATCellConfig

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    self.configName = [[CATCellConfigName alloc] init];
    //[self.configName release];
    
    return self;
}

- (void)saveConfig
{
    NSLog(@"%@", self.configName);
}

@end
