//
//  JsonParser.h
//  selfies
//
//  Created by MAC01 on 7/17/15.
//  Copyright (c) 2015 javs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JsonParserDelegate <NSObject>

-(void)parseDidSuccessWithInfo:(NSArray *)info;
-(void)parseDidFailWithError:(NSError *)error;

@end

@interface JsonParser : UIViewController

@property(weak, nonatomic) id<JsonParserDelegate> delegate;

-(void)parseData:(NSData *) data;

@end
