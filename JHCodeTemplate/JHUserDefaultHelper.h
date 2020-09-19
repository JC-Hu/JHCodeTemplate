//
//  JHUserDefaultHelper.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/7/5.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JHCodeTemplateCellTemplate.h"

@interface JHUserDefaultHelper : NSObject

+ (void)saveTemplate:(JHCodeTemplateCellTemplate *)temp;
+ (JHCodeTemplateCellTemplate *)loadTemplate;

+ (void)saveConfig:(JHCodeTemplateConfigModel *)config;
+ (JHCodeTemplateConfigModel *)loadConfig;

@end
