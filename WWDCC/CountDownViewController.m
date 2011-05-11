//
//  CountDownViewController.m
//  WWDCC
//
//  Created by iDevZilla on 5/10/11.
//


#import "CountDownViewController.h"

#define WWDC_YEAR 2011
#define WWDC_MONTH 6
#define WWDC_DAY 6
#define WWDC_HOUR 10
#define WWDC_MINUTE 00
#define WWDC_SECOND 00

#define WWDC_ANNOUNCEMENT_DAY 28
#define WWDC_ANNOUNCEMENT_MONTH 4

#define SECTION_0_TITLE @"WWDC 2011 Countdown"
#define SECTION_1_TITLE @"Progress"

#define SECTION_0_FOOTER @"Assuming opening time: 06/06/2011 10:00AM PST"
#define SECTION_1_FOOTER @"Difference between WWDC 2011 announcement and opening day"

#define COUNTDOWN_SECTION_ROWS_NUMBER 4

#define PST @"US/Pacific"

@interface CountDownViewController()

- (void)updateLabels;

@end

@implementation CountDownViewController

#pragma mark - Initialization Methods

- (id)init {
    self = [super init];
    if (self) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:WWDC_YEAR];
        [comps setMonth:WWDC_MONTH];
        [comps setDay:WWDC_DAY];
        [comps setHour:WWDC_HOUR];
        [comps setMinute:WWDC_MINUTE];
        [comps setSecond:WWDC_SECOND];
        
        [comps setTimeZone:[NSTimeZone timeZoneWithName:PST]];
        
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        wwdcDate = [[cal dateFromComponents:comps] retain];
        
        [comps setDay:WWDC_ANNOUNCEMENT_DAY];
        [comps setMonth:WWDC_ANNOUNCEMENT_MONTH];
        
        announcementDate = [[cal dateFromComponents:comps] retain];
        
        [cal release];
        [comps release];
    }
    
    return self;
}


#pragma mark - Memory Management

- (void)dealloc {
    [progressBar release];
    [table release];
    [wwdcDate release];
    [announcementDate release];
    
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)loadView {
    UIView *mainView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height - ( self.navigationController.navigationBar.frame.size.height + 20)) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;

    [mainView addSubview:table];
    
    self.view = mainView;
    [mainView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
}

- (void)viewDidUnload {
    [progressBar release];
    progressBar = nil;
    
    [table release];
    table = nil;
    
    [super viewDidUnload];
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Internal Methods

- (void)updateLabels {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *wwdcDateComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                                                            NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | 
                                                            NSTimeZoneCalendarUnit) fromDate:wwdcDate];
    [wwdcDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
        
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                                                    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | 
                                                    NSTimeZoneCalendarUnit) fromDate:wwdcDate toDate:[NSDate date] options:0];
    

    
    NSTimeInterval minValue = [wwdcDate timeIntervalSinceDate:announcementDate];
    NSTimeInterval currentInterval = [wwdcDate timeIntervalSinceDate:[NSDate date]];

    CGFloat result =  (currentInterval - minValue) / (1 - minValue);
    progressBar.progress = result;
    
    
    for (int indexCell = 0; indexCell < COUNTDOWN_SECTION_ROWS_NUMBER; indexCell++) {
        UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexCell inSection:0]];

        switch (indexCell) {
            case 0:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components day])];
                break;
            case 1:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components hour])];
                break;
            case 2:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components minute])];
                break;
            case 3:cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",abs([components second])];
                break;
        }
        [table reloadData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        numberOfRows = COUNTDOWN_SECTION_ROWS_NUMBER;
    } else {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    if (indexPath.section == 0) {
        NSString *cellText = @"";
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:20];
        switch (indexPath.row) {
            case 0:
                cellText = @"Days";
                break;
            case 1:                
                cellText = @"Hours";
                break;
            case 2:
                cellText = @"Minutes";
                break;
            case 3:
                cellText = @"Seconds";
                break;
        }
        cell.textLabel.text = cellText;
    }
    else if (indexPath.section == 1) {
        [progressBar release];
        progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressBar.frame = CGRectMake(0, 0, 280, 10);
        progressBar.center = cell.center;
        [cell addSubview:progressBar];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    
    if (section == 0) {
        title = SECTION_0_TITLE;
    } else {
        title = SECTION_1_TITLE;
        
    }
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *footer = nil;
    if (section == 0) {
        footer = SECTION_0_FOOTER;
    } else {
        footer = SECTION_1_FOOTER;

    }
    return footer;
}

@end
