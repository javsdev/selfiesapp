//
//  Selfie.h
//  selfies
//
//  Created by MAC01 on 7/17/15.
//  Copyright (c) 2015 javs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Selfie : UICollectionViewCell

@property(strong, nonatomic) NSString *urlThumbnail;
@property(strong, nonatomic) NSData *thumbnailData;
@property(strong, nonatomic) NSString *urlLow;
@property(strong, nonatomic) NSData *lowData;
@property(strong, nonatomic) NSString *urlStandard;
@property(strong, nonatomic) NSData *standardData;

@end
