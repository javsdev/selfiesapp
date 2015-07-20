//
//  ViewController.m
//  selfies
//
//  Created by MAC01 on 7/17/15.
//  Copyright (c) 2015 javs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "WebServiceRequester.h"
#import "JsonParser.h"
#import "SelfiesModel.h"
#import "ImageUICollectionViewCell.h"
#import "Selfie.h"

@interface ViewController ()

@property(strong, nonatomic) WebServiceRequester *requester;
@property(strong, nonatomic) JsonParser *parser;
@property(strong, nonatomic) SelfiesModel *model;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(strong, nonatomic) NSOperationQueue *downloadImageOperationQueue;

// To track the direction of scrolling
@property(assign, nonatomic) float firstPosition;
@property(assign, nonatomic) BOOL isRequesting;
@property(assign, nonatomic) int nLoading;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isRequesting = NO;
    
    self.nLoading = 1;
    // Create web service requester to get instagram info
    self.requester = [[WebServiceRequester alloc] init];
    self.requester.delegate = self;
    [self.requester requestImages];
    
    // Create json parser
    self.parser = [[JsonParser alloc] init];
    self.parser.delegate = self;
    
    // Get model
    self.model = [SelfiesModel sharedSelfiesModel];
    
    // Create the operation queue for downloading images
    self.downloadImageOperationQueue = [[NSOperationQueue alloc] init];
    self.downloadImageOperationQueue.name = @"Download Image Queue";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebServiceRequester delegate methods
-(void)requestDidFailWithError:(NSError *)error{
    
}

-(void)requestDidSuccessWithData:(NSData *)data{
    [self.parser parseData:data];
}

#pragma mark - JsonParser delegate methods
-(void)parseDidFailWithError:(NSError *)error{
    
}

-(void)parseDidSuccessWithInfo:(NSArray *)info{
    // Save to model
    if (self.model.selfies == nil) {
        self.model.selfies = @[];
    }
    
    NSMutableArray *selfies = [[NSMutableArray alloc] init];
    for (NSDictionary *imageInfo in info) {
        Selfie *selfie = [[Selfie alloc] init];
        selfie.urlThumbnail = [[[imageInfo objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
        
        [selfies addObject:selfie];
    }
    
    self.model.selfies = [self.model.selfies arrayByAddingObjectsFromArray: selfies];
    
    self.nLoading--;
    
    // Update collection view
    [self.collectionView reloadData];
    
    self.isRequesting = NO;
}

#pragma mark - UICollectionView delegate methods
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InstagramImageCell" forIndexPath:indexPath];
    
    if (indexPath.row >= [self.model.selfies count]) {
        return cell;
    }
    
    cell.alpha = 0.0f;
    
    Selfie *selfie = [self.model.selfies objectAtIndex:indexPath.row];
    
    // If there is the image in the cache set it, otherwise load it from url.
    if (selfie.thumbnailData != nil) {
        [cell.imageView setImage:[UIImage imageWithData:selfie.thumbnailData]];
        
        cell.alpha = 1.0f;
    } else if(selfie.urlThumbnail != nil) {
        [self.downloadImageOperationQueue addOperationWithBlock:^{
            NSURL *url = [NSURL URLWithString:selfie.urlThumbnail];
            
            selfie.thumbnailData = [NSData dataWithContentsOfURL:url];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [cell.imageView setImage:[UIImage imageWithData:selfie.thumbnailData]];
                
                [UIView animateWithDuration:0.3 animations:^{
                    cell.alpha = 1.0f;
                }];
            }];
        }];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 3 == 0)
        return CGSizeMake(320, 320);
    else
        return CGSizeMake(150, 150);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.model.selfies != nil)
        return [self.model.selfies count] + self.nLoading * 20;
    else
        return 0;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.firstPosition = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float currentPosition = scrollView.contentOffset.y;
    float scrollViewHeight = scrollView.frame.size.height;
    float contentHeight = scrollView.contentSize.height;
    if (currentPosition > self.firstPosition &&
        (currentPosition + scrollViewHeight) > (contentHeight - scrollViewHeight)
        ) {
        self.nLoading++;
        
        [self.collectionView reloadData];
        
        NSLog(@"scroll");
        self.isRequesting = YES;
        [self.requester requestImages];
    }
}

@end
