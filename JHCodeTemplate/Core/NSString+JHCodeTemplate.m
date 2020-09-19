//
//  NSString+JHCodeTemplate.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "NSString+JHCodeTemplate.h"

@implementation NSString (JHCodeTemplate)

- (NSString *)composedStringWithElementArray:(NSArray *)elementArray
{
    NSString *resultString = self;
    
    for (JHCodeTemplateElementModel *model in elementArray) {
        resultString = [resultString stringByReplacingOccurrencesOfString:[model.identifier markString] withString:model.content];
    }
    
    return resultString;
}

#pragma mark -
- (NSString *)markString
{
    return [NSString stringWithFormat:@"<$%@$>", self];
}


@end
