//
//  ViewController.m
//  LocalizationTest
//
//  Created by 柯梵Aaron on 15/6/16.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSInteger, KFALocalizationLanguage){
    KFALocalizationLanguageSimplifyChinese = 1,
    KFALocalizationLanguageEnglish,
    KFALocalizationLanguageFrench,
    KFALocalizationLanguageGermeny,
    KFALocalizationLanguageJanpanese
} ;

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIPickerView *pickLanguage;

@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _pickLanguage.delegate = self;
    _pickLanguage.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    
    _titleName.text = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[[NSUserDefaults standardUserDefaults] valueForKey:@"ChangeLanguage"] ofType:@"lproj"]] localizedStringForKey:@"titleName" value:@"" table:@"Localizable"];
    
}

/*
- (void)addLabel{
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, self.view.bounds.size.width - 200, 50)];
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:testLabel];
    testLabel.text = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[[NSUserDefaults standardUserDefaults] valueForKey:@"ChangeLanguage"] ofType:@"lproj"]] localizedStringForKey:@"titleName" value:@"" table:@"Localizable"];
}
 */

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.array.count;
}

- (NSArray *)array{
    if (!_array) {
        _array = @[@"中文", @"English", @"Français", @"Deutsch", @"日本語"];
    }
    return _array;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.array[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (row) {
        case 0:
            [self changeLanguageWith:KFALocalizationLanguageSimplifyChinese];
            break;
        case 1:
            [self changeLanguageWith:KFALocalizationLanguageEnglish];
            break;
        case 2:
            [self changeLanguageWith:KFALocalizationLanguageFrench];
            break;
        case 3:
            [self changeLanguageWith:KFALocalizationLanguageGermeny];
            break;
        case 4:
            [self changeLanguageWith:KFALocalizationLanguageJanpanese];
            break;
        default:
            break;
    }
}

- (void)changeLanguageWith:(KFALocalizationLanguage)option{
    NSString *document = nil;
    switch (option) {
        case KFALocalizationLanguageSimplifyChinese:
            document = @"zh-Hans";
            break;
        case KFALocalizationLanguageEnglish:
            document = @"en";
            break;
        case KFALocalizationLanguageFrench:
            document = @"fr";
            break;
        case KFALocalizationLanguageGermeny:
            document = @"de";
            break;
        case KFALocalizationLanguageJanpanese:
            document = @"ja";
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] setValue:document forKey:@"ChangeLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
    
}

- (void)changeLanguage{
    _titleName.text = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[[NSUserDefaults standardUserDefaults] valueForKey:@"ChangeLanguage"] ofType:@"lproj"]] localizedStringForKey:@"titleName" value:@"" table:@"Localizable"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
