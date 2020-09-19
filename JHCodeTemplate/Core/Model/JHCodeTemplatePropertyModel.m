//
//  JHCodeTemplatePropertyModel.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "JHCodeTemplatePropertyModel.h"

@implementation JHCodeTemplatePropertyModel

+ (instancetype)propertyModelWithPropertyName:(NSString *)propertyName propertyClass:(NSString *)propertyClass
{
    JHCodeTemplatePropertyModel *model = [JHCodeTemplatePropertyModel new];
    
    model.propertyName = propertyName;
    model.propertyClass = propertyClass;
    
    return model;
}

@end
