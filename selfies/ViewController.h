//
//  ViewController.h
//  selfies
//
//  Created by MAC01 on 7/17/15.
//  Copyright (c) 2015 javs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceRequester.h"
#import "JsonParser.h"

@interface ViewController : UIViewController<WebServiceDelegate, JsonParserDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end

