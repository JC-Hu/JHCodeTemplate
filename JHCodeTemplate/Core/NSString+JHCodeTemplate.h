//
//  NSString+JHCodeTemplate.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JHCodeTemplateElementModel.h"

@interface NSString (JHCodeTemplate)

- (NSString *)composedStringWithElementArray:(NSArray *)elementArray;

- (NSString *)markString;

@end
