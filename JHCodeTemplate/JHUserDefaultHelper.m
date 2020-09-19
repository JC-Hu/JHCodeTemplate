//
//  JHUserDefaultHelper.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/7/5.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "JHUserDefaultHelper.h"

#import "MJExtension.h"

#define kConfigKey @"userTemplateConfig"
#define kTemplateKey @"userTemplate"

@implementation JHUserDefaultHelper

+ (void)saveTemplate:(JHCodeTemplateCellTemplate *)temp
{
    [[NSUserDefaults standardUserDefaults] setObject:[temp mj_JSONObject] forKey:kTemplateKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (JHCodeTemplateCellTemplate *)loadTemplate
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kTemplateKey];
    if (dict) {
        return [JHCodeTemplateCellTemplate mj_objectWithKeyValues:dict];
    } else {
        return nil;
    }
}



+ (void)saveConfig:(JHCodeTemplateConfigModel *)config
{
    [[NSUserDefaults standardUserDefaults] setObject:[config mj_JSONObject] forKey:kConfigKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (JHCodeTemplateConfigModel *)loadConfig
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kConfigKey];
    if (dict) {
        return [JHCodeTemplateConfigModel mj_objectWithKeyValues:dict];
    } else {
        return nil;
    }
}


@end
