//
//  ConfigViewContoller.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/7/5.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "ConfigViewContoller.h"
#import "MJExtension.h"
#import "JHUserDefaultHelper.h"

@interface ConfigViewContoller ()

@property (nonatomic, strong) JHCodeTemplateConfigModel *tempConfig;

@end

@implementation ConfigViewContoller


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.tempConfig = [JHUserDefaultHelper loadConfig];
}

#pragma mark - InterActions
- (IBAction)saveButtonAction:(id)sender
{
    [[NSApplication sharedApplication].keyWindow endEditingFor:nil];
    
    
    [JHUserDefaultHelper saveConfig:self.tempConfig];
    
    if (self.saveBlock) {
        self.saveBlock();
    }
    [self dismissController:nil];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self dismissController:nil];
}


#pragma mark - Getters
- (JHCodeTemplateConfigModel *)tempConfig
{
    if (!_tempConfig) {
        _tempConfig = [JHCodeTemplateConfigModel new];
    }
    return _tempConfig;
}
@end
