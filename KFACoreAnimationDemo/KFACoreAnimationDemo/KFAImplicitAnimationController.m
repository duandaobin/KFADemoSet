//
//  KFAImplicitAnimationController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/25.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFAImplicitAnimationController.h"

@interface KFAImplicitAnimationController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *layView;
@property (nonatomic, strong) CALayer *colorLayer;

@property (nonatomic, copy) NSArray *images;

@end

@implementation KFAImplicitAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addColorLayers];
}

- (void)addColorLayers {
    
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    self.colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    // 添加一个自定义行为
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor":transition};
    
    [self.layView.layer addSublayer:self.colorLayer];
}

- (IBAction)changeColor:(id)sender {
    
    [self changeBackgroundColor];
    
    [self changeImage];
}

- (void)changeImage {
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    [self.imgView.layer addAnimation:transition forKey:nil];
    UIImage *currentImage = self.imgView.image;
    NSUInteger index = [self.images indexOfObject:currentImage];
    index = (index + 1) % self.images.count;
    self.imgView.image = self.images[index];
    
}

- (void)changeBackgroundColor {
    CGFloat red = arc4random()/(CGFloat)INT_MAX;
    CGFloat blue = arc4random()/(CGFloat)INT_MAX;
    CGFloat green = arc4random()/(CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)images {
    if (!_images) {
        _images = @[[UIImage imageNamed:@"animationPic"], [UIImage imageNamed:@"dial"], [UIImage imageNamed:@"hourHand"], [UIImage imageNamed:@"plane"], [UIImage imageNamed:@"secondHand"]];
    }
    return _images;
}

@end
