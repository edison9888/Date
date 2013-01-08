//
//  ReminderSettingViewController.m
//  Date
//
//  Created by maoyu on 12-11-19.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "ReminderSettingViewController.h"
#import "SoundManager.h"
#import "Reminder.h"
#import "ReminderManager.h"
#import "ReminderMapViewController.h"
#import "ReminderSendingViewController.h"
#import "SinaWeiboManager.h"
#import "AppDelegate.h"
#import "ReminderTimeSettingViewController.h"
#import "LMLibrary.h"

@interface ReminderSettingViewController () {
    UIDatePicker * _datePicker;
    UILabel * _labelPrompt;
    UIButton * _btnSave;
}

@end

@implementation ReminderSettingViewController
@synthesize tableView = _tableView;
@synthesize pickerView = _pickerView;
@synthesize reminder = _reminder;
@synthesize receiver = _receiver;
@synthesize desc = _desc;
@synthesize triggerTime = _triggerTime;
@synthesize isLogin = _isLogin;
@synthesize isAuthValid = _isAuthValid;
@synthesize receiverId = _receiverId;
@synthesize userManager = _userManager;
@synthesize isInbox = _isInbox;

#pragma 私有函数
- (void)removeHUD {
    [[MBProgressManager defaultManager] removeHUD];
}

- (void)initDatePicker {
    if (nil == _datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        [_datePicker setMinuteInterval:5];
    }
}

#pragma 类成员函数
- (void)updateReceiverCell {
}

- (void)updateTriggerTimeCell {
}

- (void)updateDescCell {
}

- (void)clickTrigeerTimeRow:(NSIndexPath *)indexPath {
    ReminderTimeSettingViewController * timeSettingController;
    timeSettingController = [[ReminderTimeSettingViewController alloc] initWithNibName:@"ReminderTimeSettingViewController" bundle:nil];
    timeSettingController.title = @"设置时间";
    timeSettingController.parentContoller = self;
    timeSettingController.datePick = _datePicker;
    [self.navigationController pushViewController:timeSettingController animated:YES];
}

- (void)clickSendRow {
    ReminderSendingViewController * controller = [[ReminderSendingViewController alloc] initWithNibName:@"ReminderSendingViewController" bundle:nil];
    _reminder.triggerTime =  _triggerTime;
    controller.reminder = _reminder;
    controller.parentController = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSString *)stringTriggerTime {
    NSString * result;
    if (nil != _triggerTime) {
        result =  [self custumDateTimeString:_triggerTime];
    }else {
        result = @"未设置";
    }

    return result;
}

- (void)initTableFooterView {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 300, 100)];
    
    _labelPrompt = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    _labelPrompt.backgroundColor = [UIColor clearColor];
    _labelPrompt.textAlignment = NSTextAlignmentCenter;
    _labelPrompt.textColor = RGBColor(153,153,153);
    [view addSubview:_labelPrompt];
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSave.layer.frame = CGRectMake(10, 30, 300, 44);
    _btnSave.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [_btnSave setBackgroundImage:[UIImage imageNamed:@"buttonBg"] forState:UIControlStateNormal];
    [_btnSave setTitle:LocalString(@"SettingPromptOfDraftBoxWithButton") forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSave addTarget:self action:@selector(saveReminder) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_btnSave];
    
    self.tableView.tableFooterView = view;
}

- (void)updateTableFooterViewInCreateState{
    if (nil != _triggerTime) {
        if (YES == [[UserManager defaultManager] isOneself:[_receiverId stringValue]] ) {
            _labelPrompt.text = LocalString(@"SettingPromptOfAlarm");
            [_btnSave setTitle:LocalString(@"SettingPromptOfAlarmWithButton") forState:UIControlStateNormal];
        }else {
            _labelPrompt.text = LocalString(@"SettingPromptOfSend");
            [_btnSave setTitle:LocalString(@"SettingPromptOfSendWithButton") forState:UIControlStateNormal];
        }
    }else {
        _labelPrompt.text = LocalString(@"SettingPromptOfDraftBox");
        [_btnSave setTitle:LocalString(@"SettingPromptOfDraftBoxWithButton") forState:UIControlStateNormal];
    }
}

- (void)updateTableFooterViewInModifyInboxState {
    if (nil != _triggerTime) {
        if (YES == [[UserManager defaultManager] isOneself:[_receiverId stringValue]] ) {
            _labelPrompt.text = LocalString(@"SettingPromptOfAlarm");;
            [_btnSave setTitle:LocalString(@"SettingPromptOfAlarmWithButton") forState:UIControlStateNormal];
        }else {
            _labelPrompt.text = LocalString(@"SettingPromptOfSend");
            [_btnSave setTitle:LocalString(@"SettingPromptOfSendWithButton") forState:UIControlStateNormal];
        }
    }else {
        _labelPrompt.text = @"";
        [_btnSave setTitle:@"保存" forState:UIControlStateNormal];
    }
}

- (void)updateTableFooterViewInModifyAlarmState {
    if (nil != _triggerTime) {
        if (YES == [[UserManager defaultManager] isOneself:[_receiverId stringValue]] ) {
            _labelPrompt.text = @"";
            [_btnSave setTitle:@"保存" forState:UIControlStateNormal];
        }else {
            _labelPrompt.text = LocalString(@"SettingPromptOfSend");
            [_btnSave setTitle:LocalString(@"SettingPromptOfSendWithButton") forState:UIControlStateNormal];
        }
    }else {
        _labelPrompt.text = LocalString(@"SettingPromptOfDraftBox");
        [_btnSave setTitle:LocalString(@"SettingPromptOfDraftBoxWithButton") forState:UIControlStateNormal];
    }
}

- (void)hiddenTableFooterView {
    [self.tableView.tableFooterView setHidden:YES];
}

- (void)showTabeleFooterView {
    [self.tableView.tableFooterView setHidden:NO];
}

- (void)createReminder {
    _reminder.userID = _receiverId;
    _reminder.triggerTime = _triggerTime;
    _reminder.desc = _desc;
    if (NO == [_userManager isOneself:[_reminder.userID stringValue]] &&
        nil != _reminder.triggerTime) {
        [[MBProgressManager defaultManager] showHUD:@"发送中"];
    }
    [[ReminderManager defaultManager] sendReminder:_reminder];
}

- (void)modifyReminder {
    _reminder.userID = _receiverId;
    if (YES == [_userManager isOneself:[_receiverId stringValue]] ||
        nil == _triggerTime) {
        [[ReminderManager defaultManager] modifyReminder:_reminder withTriggerTime:_triggerTime withDesc:_desc];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        _reminder.triggerTime = _triggerTime;
        _reminder.desc = _desc;
        [[MBProgressManager defaultManager] showHUD:@"发送中"];
        [[ReminderManager defaultManager] sendReminder:_reminder];
    }
}

#pragma 事件函数
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableFooterView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _userManager = [UserManager defaultManager];
    _isLogin = [[SinaWeiboManager defaultManager].sinaWeibo isLoggedIn];
    _isAuthValid = [[SinaWeiboManager defaultManager].sinaWeibo isAuthValid];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initDatePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - ReminderManager delegate
- (void)newReminderSuccess:(NSString *)reminderId {
    self.reminderManager.delegate = nil;
    [[MBProgressManager defaultManager] removeHUD];
    if (NO == [_userManager isOneself:[_reminder.userID stringValue]] && nil != _reminder.triggerTime) {
        _reminder.id = reminderId;
        [self.reminderManager modifyReminder:_reminder withType:ReminderTypeSend];
    }
}

- (void)newReminderFailed {
    NSLog(@"newReminderFailed");
    [[MBProgressManager defaultManager] showHUD:@"发送失败"];
    [self performSelector:@selector(removeHUD) withObject:self afterDelay:0.5];
}
@end
