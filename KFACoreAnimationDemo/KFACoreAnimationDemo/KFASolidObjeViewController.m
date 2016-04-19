//
//  KFASolidObjeViewController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/15.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFASolidObjeViewController.h"
#import <GLKit/GLKit.h>

@interface KFASolidObjeViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *faces;

@end

@implementation KFASolidObjeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addFaces];
}

#pragma mark -
#pragma mark methods

- (void)addFaces {
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.containerView.layer.sublayerTransform = perspective;
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 50);
    [self addFace:0 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(50, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, -50, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, 50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(-50, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, -50);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    UIView *face = self.faces[index];
    [self.containerView addSubview:face];
    face.frame = CGRectMake(0, 0, 100, 100);
    face.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    face.layer.transform = transform;
    
    // 调整光线效果
    [self applyLightToFace:face.layer];
}

- (void)applyLightToFace:(CALayer *)face {
    
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    // GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(0, 1, -0.5));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    CGFloat shadow = 1 + dotProduct - 0.5;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
