//
//  SelfiesModel.h
//  selfies
//
//  Created by MAC01 on 7/17/15.
//  Copyright (c) 2015 javs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfiesModel : UIViewController

@property NSArray *selfies;

+(SelfiesModel *)sharedSelfiesModel;

@end
