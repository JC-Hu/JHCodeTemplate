//
//  ViewController.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "ViewController.h"

#import "JHCodeTemplateCellTemplate.h"
#import "JHCodeTemplateConfigModel.h"

#import "JHPropertyListCell.h"
#import "ConfigViewContoller.h"

#import "JHUserDefaultHelper.h"
#import "MJExtension.h"

NSPasteboardType const JHCodeTemplateCellDataType = @"JHCodeTemplateCellDataType";

@interface ViewController ()<NSTableViewDelegate, NSTableViewDataSource>

// UI
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *addPropertyButton;
@property (weak) IBOutlet NSButton *deletePropertyButton;
@property (weak) IBOutlet NSButton *generateButton;

@property (weak) IBOutlet NSButton *fileButton;
@property (weak) IBOutlet NSButton *clipboardButton;
@property (weak) IBOutlet NSButton *headerFileButton;

//
@property (nonatomic, strong) JHCodeTemplateCellTemplate *template;
@property (nonatomic, strong) JHCodeTemplateConfigModel *config;
@property (nonatomic, strong) NSMutableArray *propertyModelArray;

//
@property (nonatomic, assign) BOOL onlyCopy;
@property (nonatomic, assign) BOOL needHeaderFile;

@end

@implementation ViewController

//-(void)loadView
//{
//
//    NSRect frame = [[[NSApplication sharedApplication]mainWindow]frame];
//
//    self.view = [[NSView alloc]initWithFrame:frame];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // default
    
    self.template.cellSuperName = @"JHBaseCell";
    self.template.cellClassName = @"JHDemoCell";
    
    [self.propertyModelArray addObject:[JHCodeTemplatePropertyModel propertyModelWithPropertyName:@"iconImageView"
                                                                                    propertyClass:@"UIImageView"]];
    [self.propertyModelArray addObject:[JHCodeTemplatePropertyModel propertyModelWithPropertyName:@"titleLabel"
                                                                                    propertyClass:@"UILabel"]];
    [self.propertyModelArray addObject:[JHCodeTemplatePropertyModel propertyModelWithPropertyName:@"arrowImageView"
                                                                                    propertyClass:@"UIImageView"]];
    
    self.needHeaderFile = YES;
    
    
    // load
    if ([JHUserDefaultHelper loadTemplate]) {
        self.template = [JHUserDefaultHelper loadTemplate];
    }
    
    if ([JHUserDefaultHelper loadConfig]) {
        self.config = [JHUserDefaultHelper loadConfig];
    }
    
    // drag to sort
    
    [self.tableView registerForDraggedTypes:@[JHCodeTemplateCellDataType]];
    self.tableView.allowsMultipleSelection = YES;
}

#pragma mark - TableView
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.propertyModelArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    JHCodeTemplatePropertyModel *propertyModel = [self.propertyModelArray objectAtIndex:row];
    JHPropertyListCell *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    cellView.textField.editable = YES;
    
    if ([tableColumn.identifier isEqualToString:@"propertyClass"]) {
        
        cellView.forPropertyName = NO;
        cellView.propertyModel = propertyModel;
        cellView.text = propertyModel.propertyClass;
        
    } else if ([tableColumn.identifier isEqualToString:@"propertyName"]) {
        
        cellView.forPropertyName = YES;
        cellView.propertyModel = propertyModel;
        cellView.text = propertyModel.propertyName;
    }
    return cellView;
}

// drag to sort

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(nonnull NSIndexSet *)rowIndexes toPasteboard:(nonnull NSPasteboard *)pboard
{
    // Copy the row numbers to the pasteboard.
    
    NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    
    [pboard declareTypes:[NSArray arrayWithObject:JHCodeTemplateCellDataType] owner:self];
    
    [pboard setData:zNSIndexSetData forType:JHCodeTemplateCellDataType];
    
    return YES;
    
}


- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op

{
    // Add code here to validate the drop
    
    //NSLog(@"validate Drop");
    
    return NSDragOperationEvery;
}



-(BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation

{
    
    
    NSPasteboard* pboard = [info draggingPasteboard];
    
    NSData* rowData = [pboard dataForType:JHCodeTemplateCellDataType];
    
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
    
    NSInteger dragRow = [rowIndexes firstIndex];
    
    if (operation == NSTableViewDropOn) {
        [self.propertyModelArray exchangeObjectAtIndex:dragRow withObjectAtIndex:row];
    } else {
//        NSTableViewDropAbove
        JHCodeTemplatePropertyModel *dragModel = self.propertyModelArray[dragRow];
        
        JHCodeTemplatePropertyModel *copyModel = [JHCodeTemplatePropertyModel propertyModelWithPropertyName:dragModel.propertyName propertyClass:dragModel.propertyClass];
        
        [self.propertyModelArray insertObject:copyModel atIndex:row];
        [self.propertyModelArray removeObject:dragModel];
    }
    
    [aTableView reloadData];

    
    return YES;
    
}



#pragma mark - InterAction
- (IBAction)generateButtonAction:(id)sender
{
    [[NSApplication sharedApplication].keyWindow endEditingFor:nil];
    
    self.template.propertyArray = self.propertyModelArray;
    self.template.configModel = self.config;
    
    if (self.needHeaderFile) {
        
        //.h
        NSURL *hUrl = [self hFileWithTemplate:self.template];
        
        // .m
        NSURL *mUrl = [self mFileWithTemplate:self.template];
        
        // OpenFile
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[hUrl, mUrl]];
        
    } else {
        
        if (self.onlyCopy) {
            
            NSString *result = [self.template mFileCodeString];
            
            [[NSPasteboard generalPasteboard] clearContents];
            [[NSPasteboard generalPasteboard] setString:result forType:NSPasteboardTypeString];
            
            NSAlert *alert =[NSAlert alertWithMessageText:@"Code Copy Successfully" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
            [alert runModal];
            
        } else {
            // .m
            NSURL *mUrl = [self mFileWithTemplate:self.template];
            
            // OpenFile
            [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[mUrl]];
        }
        
    }
    
    // save
    [JHUserDefaultHelper saveTemplate:self.template];
}

- (IBAction)addPropertyButtonAction:(id)sender
{
    
    [self.propertyModelArray addObject:[self createNewProperty]];
    [self.tableView reloadData];
}

- (IBAction)deletePropertyButtonAction:(id)sender
{
    NSIndexSet *rowSet = [self.tableView selectedRowIndexes];
    
    [self.propertyModelArray removeObjectsAtIndexes:rowSet];
    [self.tableView removeRowsAtIndexes:rowSet withAnimation:NSTableViewAnimationEffectFade];
    
}

- (IBAction)settingButtonAction:(id)sender
{
    // 设置
    
    
}

- (IBAction)clipboardButtonAction:(NSButton *)sender
{
    if (self.onlyCopy) {
        return;
    }
    
    self.onlyCopy = YES;
    self.clipboardButton.state = 1;
    self.fileButton.state = 0;
    self.needHeaderFile = NO;
    self.headerFileButton.enabled = NO;
}

- (IBAction)fileButtonAction:(NSButton *)sender
{
    if (!self.onlyCopy) {
        return;
    }
    
    self.onlyCopy = NO;
    self.clipboardButton.state = 0;
    self.fileButton.state = 1;
    self.headerFileButton.enabled = YES;
}

#pragma mark -
- (NSURL *)hFileWithTemplate:(JHCodeTemplateCellTemplate *)template
{
    NSString *result = [template hFileCodeString];
    
    NSLog(@"%@",result);
    
    
    NSArray *urlarray = [[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask];
    
    NSURL *desktopUrl = [urlarray firstObject];
    NSURL *writeUrl = [desktopUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.h", template.cellClassName]];
    NSError *error = nil;
    [result writeToURL:writeUrl atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
    return writeUrl;
}


- (NSURL *)mFileWithTemplate:(JHCodeTemplateCellTemplate *)template
{
    NSString *result = [template mFileCodeString];
    
    NSLog(@"%@",result);
    
    
    NSArray *urlarray = [[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask];
    
    NSURL *desktopUrl = [urlarray firstObject];
    NSURL *writeUrl = [desktopUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", template.cellClassName]];
    NSError *error = nil;
    [result writeToURL:writeUrl atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
    return writeUrl;
}


- (JHCodeTemplatePropertyModel *)createNewProperty
{
    return [JHCodeTemplatePropertyModel propertyModelWithPropertyName:@"titleLabel"
                                                        propertyClass:@"UILabel"];
}


#pragma mark - Super
- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"configVC"]) {
        ConfigViewContoller *vc = segue.destinationController;
        [vc setSaveBlock:^{
            if ([JHUserDefaultHelper loadConfig]) {
                self.config = [JHUserDefaultHelper loadConfig];
            }
        }];
    }
}


#pragma mark - Getters
- (JHCodeTemplateCellTemplate *)template
{
    if (!_template) {
        _template = [[JHCodeTemplateCellTemplate alloc] init];
        _template.configModel = self.config;
    }
    return _template;
}

- (JHCodeTemplateConfigModel *)config
{
    if (!_config) {
        _config = [[JHCodeTemplateConfigModel alloc] init];
        
        _config.userName = @"Your Name";
        _config.projectName = @"TooWellMerchant";
        _config.organizationName = @"TooWell";
        
    }
    return _config;
}

- (NSArray *)propertyModelArray
{
    if (!_propertyModelArray) {
        _propertyModelArray = [NSMutableArray array];
        
    }
    return _propertyModelArray;
}


@end
