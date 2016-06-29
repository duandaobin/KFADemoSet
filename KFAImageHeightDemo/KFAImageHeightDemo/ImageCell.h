//
//  ImageCell.h
//  KFAImageHeightDemo
//
//  Created by 柯梵Aaron on 16/6/29.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) void(^LoadedImageBlock)(NSString *, CGFloat);

@end
