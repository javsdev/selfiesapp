//
//  SelfiesModel.m
//  selfies
//
//  Created by MAC01 on 7/17/15.
//  Copyright (c) 2015 javs. All rights reserved.
//

#import "SelfiesModel.h"

@implementation SelfiesModel

static SelfiesModel *selfiesModel = nil;

+(SelfiesModel *)sharedSelfiesModel {
    if (selfiesModel == nil) {
        selfiesModel = [[super alloc] init];
    }
    
    return selfiesModel;
}

@end
