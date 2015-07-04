//
//  ViewController.m
//  KFACamenaDemo
//
//  Created by 柯梵Aaron on 15/6/18.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *displayPicture;

- (IBAction)takePhotos:(id)sender;
- (IBAction)takePhotoGraph:(id)sender;
- (IBAction)flashLight:(id)sender;
- (IBAction)fetchPicture:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 拍照
- (IBAction)takePhotos:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePC = [self createWith:UIImagePickerControllerSourceTypeCamera];
        // 设置为拍照(默认是拍照，可以不写)
        imagePC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imagePC animated:YES completion:nil];
    }else {
        [self showAlertViewWith:@"当前的摄像头不可用"];
    }
}

#pragma mark - 摄像
- (IBAction)takePhotoGraph:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePC = [self createWith:UIImagePickerControllerSourceTypeCamera];
        imagePC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        [self presentViewController:imagePC animated:YES completion:nil];
    }else {
        [self showAlertViewWith:@"当前的摄像头不可用"];
    }
}

#pragma mark - 自定义相机
- (IBAction)flashLight:(id)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        [self showAlertViewWith:@"闪光灯不可用"];
        return;
    }
    if (device.torchMode == AVCaptureTorchModeOff) {
        // 创建AV session 会话
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        // 创建设备输入并加入当前会话 （通过返回值判断设备是否可用）
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [session addInput:input];
        // 创建视频输出并添加到当前会话
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [session addOutput:output];
        // 开始会话配置
        [session beginConfiguration];
        [device lockForConfiguration:nil];
        // 开启闪光灯
        [device setTorchMode:AVCaptureTorchModeOn];
        
        [device unlockForConfiguration];
        [session commitConfiguration];
        // 启动会话
        [session startRunning];
    }
}

#pragma mark - 打开相册
- (IBAction)fetchPicture:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePC = [self createWith:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePC animated:YES completion:nil];
    }else {
        [self showAlertViewWith:@"系统相册不可用"];
    }
}

#pragma mark - 生成一个ImagePickerController
- (UIImagePickerController *)createWith:(UIImagePickerControllerSourceType)sourceType{
    
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    imagePC.delegate = self;
    // 打开类型
    imagePC.sourceType = sourceType;
    imagePC.allowsEditing = YES;
    // 设置摄像头获取数据的类型
    NSArray *typeArray = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    imagePC.mediaTypes = typeArray;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 设置调用后置摄像头
        [imagePC setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        // 设置闪光灯模式为自动
        imagePC.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }

    return imagePC;
}

#pragma mark - 设置一个alertView并展示
- (void)showAlertViewWith:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - 选中相册照片之后执行
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 获得拍摄的原始照片
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    // 如果是刚拍摄的照片，就保存到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 保存照片到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    // 获得编辑之后的照片
    UIImage *editImage = [info valueForKey:UIImagePickerControllerEditedImage];
    UIImage *saveImage = editImage ? editImage : image;
    self.displayPicture.image = saveImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击cancel后执行（会自动执行返回，如没有其他可以，可以不用重写此方法，一旦重写，就得加上dismissViewController这个方法，否则不会返回）
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
