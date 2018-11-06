//
//  PropertyKeys.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#ifndef PropertyKeys_h
#define PropertyKeys_h

#define USERUID      [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]
#define USERPHONE      [[NSUserDefaults standardUserDefaults] valueForKey:@"phone"]
#define USERCOURSE      [[NSUserDefaults standardUserDefaults] valueForKey:@"courseid"]

#define USERDEFAULTS  [NSUserDefaults standardUserDefaults]

#define IS_IPHONE4S [UIScreen mainScreen].bounds.size.height <= 500
#define IS_IPHONE5  [UIScreen mainScreen].bounds.size.height <= 600

#define ScreenWidth    [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height

#define StatusHeight   [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavHeight      self.navigationController.navigationBar.frame.size.height
#define TabHeight      self.tabBarController.tabBar.frame.size.height

#define Width_Scale         ScreenWidth / 375.0
#define Heigt_Scale         ScreenHeight / 667.0
#define RateSacel(a)        a * ScreenWidth / 375.0

#define weakSelf(self) @autoreleasepool{} __weak typeof(self) weak##Self = self;//定义弱引用

//#define SEVER               @"http://192.168.1.155:8081"
//#define SEVER               @"http://192.168.2.177:8081"
///quan-psy-api/
//#ifdef DEBUG
//#define SEVER               @"http://192.168.1.147:8082"
//#define SEVER               @"http://192.168.1.189"
//#define SEVER               @"http://139.196.108.211:8081"//测试
//#define SEVER               @"http://106.14.45.211:8081"
#define SEVER               @"https://fx.quanquankaoshi.com"
#define SEVER_QUAN_API      [SEVER stringByAppendingString:@"/quan-psy-api/"]
//#define SEVER_QUAN_API      [SEVER stringByAppendingString:@""]


//#else
////#define SEVER               @"https://fx.quanquankaoshi.com"
//#define SEVER               @"http://106.14.45.211:8081"
//
//#define SEVER_QUAN_API      [SEVER stringByAppendingString:@"/quan-psy-api/"]
//
//#endif

//UserDefaultsKey
#define UDREMOTENOTIFICATION @"remotenotification"
#define UDPORTRAIT @"portrait"
#define UDBACKGROUNDCOLOR @"backgroundcolor"
#define UDPHONE @"phone"
#define UDUID @"uid"
#define UDCOURSEID @"courseid"
#define UDLOGINDATE @"loginDate"
#define UDPVDATE @"PVDate"
#define UDAPPVERSION @"AppVersion"
#define UDSHAREDATE @"shareDate"
#define UDSHOWANALYSIS @"showAnalysis"
#define UDQAFAVOURITE @"QAFavourite"
#define UDAPPSTORECOMMENT @"AppStoreComment"
#define UDTOTALALREADYCARDCOUNT @"totalAlreadyCardCount"
#define UDCPTOTALALREADYCARDCOUNT @"alreadyPackageCardsCount"
#define UDNOQUESREMINDER @"noQuesReminder"
#define UDNEWSREADTIME @"NewsReadTime"
#define UDSINGLESIGNONUUID @"SingleSignOnUUID"


/** 引导页 */
#define UDCARDGUIDE1 @"cardguide1"
#define UDCARDGUIDE2 @"cardguide2"
#define UDCARDSTARGUIDE @"cardstar"
#define UDCARDEXERCISEBTNGUIDE @"cardexercisebtn"
#define UDCARDEXERCISEGUIDE @"cardexercise"
#define UDCARDSHOWANALYSISGUIDE @"cardshowanalysis"
#define UDCARDEXERCISEANALYSISGUIDE @"cardexerciseanalysis111"

#define STATUS @"status"
#define MSG @"msg"
#define LIST @"list"
#define SUCCESS @"000"
#define NODATA @"019"
#define QUESTIONNOTENOUGH @"023"

#define PK @"0"
#define STUDY @"2"
#define CHALLENGE @"3"
#define EXAM @"4"
#define SMARTSTUDY @"5"
#define ERROR @"6"

#define ANSWERRIGHT @"1"
#define ANSWERWRONG @"0"

#define PICPATH @"pic_path"
#define CREATEDATE @"create_date"

//用户信息
#define UID @"uid"
#define AVATAR @"head_path"
#define UPHONE @"uphone"
#define INTRODUCE @"introduce"
#define EMAIL @"email"
#define UNAME @"uname"
#define USERINFO @"userinfo"

#define REGIONID @"region_id"
#define REGIONNAME @"region_name"
#define REGIONENGNAME @"region_name_en"

//首页排名 历史成绩
#define PREDICTSCORE @"achievement"
#define PASSINGRATE @"passingRate"
#define ASSIGNMENTTOTALCARD @"total"
#define ASSIGNMENTFINISHCARD @"already"
#define STUDYPROGRESS @"progress"
#define STUDYRANK @"rank"
#define HISTORYHIGHESTSCORE @"historyTopScore"
#define TOTALLEARNINGDAYS @"lenDays"
#define TOTALQUESTIONNO @"totalCount"
#define RIGHTRATE @"rate"

//学习
#define EXAMNAME @"exam_name"
#define EXAMGRADE @"exam_grade"
#define GRADE   @"grade"
#define SUBJECTNAME @"subject_name"
#define SUBJECTID @"subject_id"
#define MODULENAME @"module_name"
#define MODULEID @"module_id"
#define MODULEPIC @"module_pic"
#define UNITNAME @"unit_name"
#define UNITID @"unit_id"
#define TOTALCARDNUM @"totalCardNum"
#define ALREADYCARDNUM @"alreadyCardNum"

//卡包
#define PUNCHCARDEVENT @"signFlag"
#define EVENTURL @"url"
#define EVENTID @"activity_id"
#define EVENTTIME @"getTime"
#define EVENTJOINMETHOD @"introduction"
#define CARDPACKAGEID @"cp_id"
#define CARDPACKAGETITLE @"cp_name"

//知识卡
#define CARDID @"card_id"
#define CARDNAME @"card_name"
#define CARDSTAR @"star"
#define CARDANALYSIS @"analysis"
#define CARDPROGRESS @"progress"
#define CARDISCOMPLETE @"is_complete"
#define CARDISCASE @"is_case"

//题目
#define QUESTIONID @"question_id"
#define QUESTIONNAME @"question_name"
#define RIGHTANSWER @"right_answer"
#define OPTIONONE @"answer1"
#define OPTIONTWO @"answer2"
#define OPTIONTHREE @"answer3"
#define OPTIONFOUR @"answer4"
#define OPTIONFIVE @"answer5"
#define QUESTIONANALYSIS @"analysis"
#define QUESTIONTYPE @"type"
#define QUESTIONIMAGE @"is_pic"
#define QUESTIONHASIMAGE @"2"
#define CASEQUESTIONS @"questions"
#define CASEMATERIAL @"material"
#define QUESTIONHASIMAGE @"2"

//错题
#define ERRORQUESTIONID @"myQuestion_id"

//无限挑战
#define CHALLENGELEVEL @"num"

//考试
#define PAPERSCORE @"score"
#define PAPERNAME @"paper_name"
#define PAPERTIME @"test_time"
#define PAPERID @"paper_id"
#define PAPERAVERAGESCORE @"avg_score"
#define PAPERSCORERANK @"score_rank"
#define PAPERISCASE @"is_case"
#define PAPERQUESIMAGE @"card_pic_path"

//PK
#define PKROOMNO @"roomNo"
#define PKROOMNUM @"room_no"
#define PKPERSONINTOTAL @"number"
#define PKUSERLIST @"userList"
#define ISPKREADY @"isPKReady"
#define PKRANGELIST @"pkList"
#define PKUNITSID @"units_id"
#define PKSCORE @"score"
#define ROOMPKRESULT @"pkResults"
#define ROOMPKQUESTIONS @"pkQuestionsList"

//答疑
#define QAPREVIOUSPAGE @"previousPage"
#define QANEXTPAGE @"nextPage"
#define QAASKID @"ask_id"
#define QADESCRIPTION @"description"
#define QACONTENT @"content"
#define QAFAVOURITENO @"favTotalNum"
#define QACOMMENTNO @"commTotalNum"
#define QAHASIMAGE @"isPic"
#define QAPICPATHONE @"pic_path_1"
#define QAPICPATHTWO @"pic_path_2"
#define QAPICPATHTHREE @"pic_path_3"
#define QACOMMENTID @"comment_id"
#define QATHUMBTOTALNO @"total"

#define FONT(a) [UIFont systemFontOfSize:a]//字体


#endif /* PropertyKeys_h */
