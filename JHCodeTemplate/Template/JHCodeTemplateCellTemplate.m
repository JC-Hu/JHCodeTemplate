//
//  JHCodeTemplateCellTemplate.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "JHCodeTemplateCellTemplate.h"

#import "JHCodeTemplatePropertyModel+Template.h"
#import "NSMutableString+JHCodeTemplate.h"
#import "JHCodeTemplateElementModel.h"
#import "NSString+JHCodeTemplate.h"
#import "MJExtension.h"

static NSString *kAddViewsMethodName = @"setupViews";
static NSString *kSetConstraintsMethodName = @"setupViewConstraints";


@implementation JHCodeTemplateCellTemplate

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dynamicHeight = YES;
    }
    return self;
}

+ (instancetype)cellTemplateWithClassName:(NSString *)className
                                superName:(NSString *)superName
                            propertyArray:(NSArray<JHCodeTemplatePropertyModel *> *)propertyArray
                              configModel:(JHCodeTemplateConfigModel *)configModel
{
    JHCodeTemplateCellTemplate *cellTemplate = [JHCodeTemplateCellTemplate new];
    cellTemplate.cellClassName = className;
    cellTemplate.cellSuperName = superName;
    cellTemplate.propertyArray = propertyArray;
    cellTemplate.configModel = configModel;
    
    return cellTemplate;
}

#pragma mark - 

- (NSString *)hFileCodeString
{
    NSMutableString *result = [NSMutableString string];
    
    // info
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy/M/d";
    NSString *dateString = [format stringFromDate:[NSDate date]];
    format.dateFormat = @"yyyy";
    NSString *yearString = [format stringFromDate:[NSDate date]];
    
    [result appendFormat:@"//\n//  <$className$>.h\n//  %@\n//\n//  Created by %@ on %@.\n//  Copyright © %@ %@. All rights reserved.\n//\n\n", self.configModel.projectName, self.configModel.userName, dateString, yearString, self.configModel.organizationName];
    
    // import
    if ([self.cellSuperName isEqualToString:@"UITableViewCell"]) {
        [result codeAppendImportSpecific:@"<UIKit/UIKit.h>"];
    } else {
        [result codeAppendImportCommon:self.cellSuperName];
    }
    [result codeAppendReturn];
    
    // @protocol --
    if (self.needDelegate) {
        
        [result appendFormat:@"@class <$className$>;\n"];
        
        [result appendFormat:@"@protocol <$className$>Delegate <NSObject>\n"];
        [result codeAppendReturn];
        [result codeAppendAtEnd];
    }
    // @end --
    
    [result codeAppendReturn];
    
    // @interface cell model --
    [result codeAppendClassDeclareWithClassName:[NSString stringWithFormat:@"<$className$>Model"] superName:@"NSObject"];
    [result codeAppendReturn];
    
    // delegate
    if (self.needDelegate) {
        [result appendFormat:@"@property (nonatomic, weak) id<<$className$>Delegate> delegate;\n"];
        [result codeAppendReturn];
    }
    
    // actionsBlock
    for (JHCodeTemplatePropertyModel *model in self.propertyArray) {
        NSString *temp = [model codeStringForActionsBlockDeclare];
        if (temp.length) {
            [result appendString:temp];
            [result codeAppendReturn];
        }
    }
    
    [result codeAppendAtEnd];
    // @end --
    
    [result codeAppendReturn];
    
    // @interface cell
    [result codeAppendClassDeclareWithClassName:self.cellClassName superName:self.cellSuperName];
    [result codeAppendReturn];
    
    if (self.propertyInHeaderFile) {
        // property
        for (JHCodeTemplatePropertyModel *model in self.propertyArray) {
            
            [result appendString:[model codeStringForPropertyDeclare]];
            [result codeAppendReturn];
        }
        
        [result codeAppendReturn];
    }
    
    [result appendFormat:@"@property (nonatomic, strong) <$className$>Model *model;\n"];
    
    [result codeAppendReturn];
    [result codeAppendAtEnd];
    // @end --
    
    [result codeAppendReturn];
    
    result = [[result composedStringWithElementArray:self.elementArray] mutableCopy];
    
    return result;
}

- (NSString *)mFileCodeString

{
    NSMutableString *result = [NSMutableString string];
    
    // info
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy/M/d";
    NSString *dateString = [format stringFromDate:[NSDate date]];
    format.dateFormat = @"yyyy";
    NSString *yearString = [format stringFromDate:[NSDate date]];
    
    [result appendFormat:@"//\n//  <$className$>.m\n//  %@\n//\n//  Created by %@ on %@.\n//  Copyright © %@ %@. All rights reserved.\n//\n\n", self.configModel.projectName, self.configModel.userName, dateString, yearString, self.configModel.organizationName];
    
    // import
    [result codeAppendImportCommon:self.cellClassName];
    [result codeAppendReturn];
    
//    [result appendString:@"// Tools\n"];
    
    if (self.dynamicHeight) {
//        [result codeAppendImportCommon:@"NICellFactory+TWCellDynamicHeight"];
    }
//    [result codeAppendReturn];
//
//    [result appendString:@"// Views\n"];
    
    [result codeAppendReturn];
    [result codeAppendReturn];
    
    
    // @interface --
    [result codeAppendClassExtensionWithClassName:self.cellClassName];
    [result codeAppendReturn];
    
    if (!self.propertyInHeaderFile) {
        // property
        for (JHCodeTemplatePropertyModel *model in self.propertyArray) {
            
            [result appendString:[model codeStringForPropertyDeclare]];
            [result codeAppendReturn];
        }
        
        [result codeAppendReturn];
    }
    
    [result codeAppendAtEnd];
    // @end --
    
    [result codeAppendReturn];
    
    
    // @implementation --
    [result codeAppendClassImplementationWithClassName:self.cellClassName];
    [result codeAppendReturn];
    
    [result codeAppendPragmaMark:@"Life Cycle"];
    // init
    [result appendString:[self codeStringForInitWithStyle]];
    [result codeAppendReturn];
    
    
    [result codeAppendPragmaMark:@"View"];
    // addViews
    [result codeAppendMethodBeganWithName:kAddViewsMethodName];
    for (JHCodeTemplatePropertyModel *model in self.propertyArray) {
        
        [result appendString:[model codeStringForAddSubviewToCell]];
        [result codeAppendReturn];
    }
    [result codeAppendMethodEnd];
    
    
    // constraints
    [result codeAppendMethodBeganWithName:kSetConstraintsMethodName];
    for (JHCodeTemplatePropertyModel *model in self.propertyArray) {
        
        [result appendString:[model codeStringForSetupConstraints]];
        [result codeAppendReturn];
    }
    [result codeAppendMethodEnd];
    
    [result codeAppendPragmaMark:@"JHCellConfig"];
    // shouldUpdate
    [result appendString:@"- (void)updateContentWithCellConfig:(JHCellConfig *)cellConfig\n{\n"];
    [result appendString:@"self.model = cellConfig.dataModel;"];
    [result codeAppendReturn];
    [result codeAppendReturn];
    [result codeAppendMethodEnd];
    
    
    // prepareForReuse
    //    [result appendString:@"- (void)prepareForReuse\n{\n[super prepareForReuse];\n}\n\n"];
    
    
    // heightForObject
    
    [result appendFormat:@"+ (CGFloat)cellHeightWithCellConfig:(JHCellConfig *)cellConfig\n{\nreturn %@;\n}\n\n", self.dynamicHeight ?@"[cellConfig dynamicHeightCalResult]":@"44"];

    
    [result codeAppendPragmaMark:@"Public"];
    [result codeAppendPragmaMark:@"Private"];
    
    [result codeAppendPragmaMark:@"Actions"];
    for (JHCodeTemplatePropertyModel *model in self.propertyArray) {
        NSString *temp = [model codeStringForActions];
        if (temp.length) {
            [result appendString:temp];
            [result codeAppendReturn];
        }
    }
    
    [result codeAppendPragmaMark:@"Getter"];
    // get
    for (JHCodeTemplatePropertyModel *model in self.propertyArray) {
        
        [result appendString:[model codeStringForLazyInit]];
        [result codeAppendReturn];
    }
    
    [result codeAppendReturn];
    
    
    [result codeAppendPragmaMark:@"Setter"];
    [result codeAppendReturn];
    
    [result codeAppendAtEnd];
    // @end --
    
    [result codeAppendReturn];
    
    // model -
    [result codeAppendClassImplementationWithClassName:[NSString stringWithFormat:@"<$className$>Model"]];
    [result codeAppendReturn];
    [result codeAppendAtEnd];
    
    result = [[result composedStringWithElementArray:self.elementArray] mutableCopy];

    return result;
}

#pragma mark -
- (NSString *)codeStringForInitWithStyle
{
    return [NSString stringWithFormat:@"- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier\n{\n\nif (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {\n[self %@];\n[self %@];\n}\nreturn self;\n}\n", kAddViewsMethodName, kSetConstraintsMethodName];
}

#pragma mark -
- (NSArray *)elementArray
{
    NSArray *array = @[
                       [JHCodeTemplateElementModel elementModelWithContent:self.cellClassName identifier:@"className"],
                       [JHCodeTemplateElementModel elementModelWithContent:self.cellSuperName identifier:@"superName"],
                       ];
    
    return array;
}

#pragma mark - MJExtension
+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"configModel"];
}


@end
