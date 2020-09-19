//
//  JHCodeTemplatePropertyModel.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCodeTemplatePropertyModel : NSObject

@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *propertyClass;

+ (instancetype)propertyModelWithPropertyName:(NSString *)propertyName propertyClass:(NSString *)propertyClass;

@end
