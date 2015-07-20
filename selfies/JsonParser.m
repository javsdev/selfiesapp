//
//  JsonParser.m
//  selfies
//
//  Created by MAC01 on 7/17/15.
//  Copyright (c) 2015 javs. All rights reserved.
//

#import "JsonParser.h"
#import "SelfiesModel.h"

@implementation JsonParser

-(void)parseData:(NSData *)data{
    // Parse data
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *imagesInfo = [dataDictionary objectForKey:@"data"];
    
    // Call delegate method
    [self.delegate parseDidSuccessWithInfo:imagesInfo];
}

@end
