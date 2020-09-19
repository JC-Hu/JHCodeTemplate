//
//  ConfigViewContoller.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/7/5.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JHCodeTemplateConfigModel.h"

typedef void(^ConfigSaveBlock)();

@interface ConfigViewContoller : NSViewController

@property (nonatomic, copy) ConfigSaveBlock saveBlock;

- (void)setSaveBlock:(ConfigSaveBlock)saveBlock;

@end
