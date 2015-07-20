//
//  WebServiceRequester.m
//  selfies
//
//  Created by MAC01 on 7/17/15.
//  Copyright (c) 2015 javs. All rights reserved.
//

#import "WebServiceRequester.h"

static NSString *const API_REQUEST_URL = @"https://api.instagram.com/v1/tags/selfie/media/recent?client_id=5a96941ebb2e4a9e887d4aa9256d85b9";

@implementation WebServiceRequester

-(void)requestImages {
    // Create request with instagram api url
    NSURL *url = [NSURL URLWithString:API_REQUEST_URL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // Create the connection asynchronously and when it finish call delegate
    // methods in the main thread
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            NSLog(@"Handle error");
        } else {
            // Notify delegate
            [self.delegate requestDidSuccessWithData:data];
        }
    }];
}

@end
