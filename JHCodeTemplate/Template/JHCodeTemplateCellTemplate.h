//
//  JHCodeTemplateCellTemplate.h
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JHCodeTemplatePropertyModel.h"
#import "JHCodeTemplateConfigModel.h"

@interface JHCodeTemplateCellTemplate : NSObject

@property (nonatomic, strong) NSString *cellClassName;
@property (nonatomic, strong) NSString *cellSuperName;
@property (nonatomic, strong) NSArray<JHCodeTemplatePropertyModel *> *propertyArray;

@property (nonatomic, strong) JHCodeTemplateConfigModel *configModel;

+ (instancetype)cellTemplateWithClassName:(NSString *)className
                                superName:(NSString *)superName
                            propertyArray:(NSArray<JHCodeTemplatePropertyModel *> *)propertyArray
                              configModel:(JHCodeTemplateConfigModel *)configModel;


- (NSString *)hFileCodeString;

- (NSString *)mFileCodeString;


// preference
@property (nonatomic, assign) BOOL dynamicHeight; // default YES. 是否使用动态高度自动计算
@property (nonatomic, assign) BOOL propertyInHeaderFile; // default NO. 是否将控件属性声明在.h
@property (nonatomic, assign) BOOL needDelegate; // default NO. 是否需要代理



@end
