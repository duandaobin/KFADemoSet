//
//  ImageCell.m
//  KFAImageHeightDemo
//
//  Created by 柯梵Aaron on 16/6/29.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "ImageCell.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface ImageCell ()
{
    CGFloat _lastHeight;
}

@property (nonatomic, strong) UIImageView *customImage;

@end

@implementation ImageCell

- (void)dealloc {
    
    [_customImage removeObserver:self forKeyPath:@"image"];
    _customImage = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    id image = change[@"new"];
    if ([image isKindOfClass:[UIImage class]]) {
        
        UIImage *img = (UIImage *)image;
        CGFloat height = [self heightWithImageSize:img.size];
        if (height != _lastHeight) {
            _lastHeight = height;
            
            if (self.LoadedImageBlock) {
                self.LoadedImageBlock(self.imageUrl, height);
            }
        }
        
    }
}

- (CGFloat)heightWithImageSize:(CGSize)imageSize {
    
    CGFloat width = kScreenWidth;
    CGFloat height = width * (imageSize.height/imageSize.width);
    if (width > imageSize.width) {
        height = imageSize.height;
    }
    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.customImage.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = [imageUrl copy];
    
    [self.customImage sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    
    [self layoutIfNeeded];
}

- (UIImageView *)customImage {
    if (!_customImage) {
        _customImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _customImage.backgroundColor = [UIColor clearColor];
        _customImage.contentMode = UIViewContentModeScaleAspectFit;
        [_customImage addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        [self.contentView addSubview:_customImage];
    }
    return _customImage;
}

@end
