//
//  JHCodeTemplateElementModel.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCodeTemplateElementModel : NSObject

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *identifier;


+ (JHCodeTemplateElementModel *)elementModelWithContent:(NSString *)content identifier:(NSString *)identifier;

@end
