//
//  JHCodeTemplateElementModel.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "JHCodeTemplateElementModel.h"

@implementation JHCodeTemplateElementModel

+ (JHCodeTemplateElementModel *)elementModelWithContent:(NSString *)content identifier:(NSString *)identifier
{
    JHCodeTemplateElementModel *model = [JHCodeTemplateElementModel new];
    
    model.identifier = identifier;
    model.content = content;
    
    return model;
}

@end
