//
//  NewDataModel.h
//  Magic
//
//  Created by mxl on 16/1/3.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <JSONModel/JSONModel.h>



@interface NewChannelModel : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *user_id;
@end

@interface NewUserModel : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *pay_class;
@property (nonatomic, copy) NSString *pay_status;
@property (nonatomic, copy) NSString *famous_status;
@property (nonatomic, copy) NSString *followed_count;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *famous_type;
@property (nonatomic, copy) NSString *avatar_100;
@property (nonatomic, copy) NSString *avatar_50;
@end

@protocol  newDatasModel <NSObject>
@end
@interface newDatasModel : JSONModel
/**
 *  频道，用户
 */
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;//
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, copy) NSString *tag_id2;
@property (nonatomic, copy) NSString *sound_count;
@property (nonatomic, copy) NSString *follow_count;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *share_count;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *update_user_id;
@property (nonatomic, copy) NSString *list_order;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *encrypt_level;
@property (nonatomic, copy) NSString *desp;
@property (nonatomic, copy) NSString *commend_time;
@property (nonatomic, copy) NSString *check_visition;
@property (nonatomic, copy) NSString *backup_id;
@property (nonatomic ,copy) NSString *pic_100;
@property (nonatomic, copy) NSString *pic_200;
@property (nonatomic ,copy) NSString *pic_500;
@property (nonatomic, copy) NSString *pic_640;
@property (nonatomic ,copy) NSString *pic_750;
@property (nonatomic, copy) NSString *pic_1080;//

/**
 *  用户
 */
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *is_hot;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, strong) NewUserModel *user;
@property (nonatomic, copy) NSString *source;//
/**
 *  用户声音所在频道
 */
@property (nonatomic, strong) NewChannelModel *channel;
/**
 *  频道详情
 */
/**
 *  评论
 */
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *original_content;
@property (nonatomic, copy) NSString *like;

@end


@interface NewResultModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *total_count;
@property (nonatomic, strong) NSMutableArray<newDatasModel> *detailData;

@end

@interface NewDataModel : JSONModel
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NewResultModel *result;
@end
