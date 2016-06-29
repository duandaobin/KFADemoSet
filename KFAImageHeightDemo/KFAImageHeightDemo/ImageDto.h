//
//  ImageDto.h
//  KFAImageHeightDemo
//
//  Created by 柯梵Aaron on 16/6/29.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDto : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) BOOL isResetHeight;

@end
