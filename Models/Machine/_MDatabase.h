// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MDatabase.h instead.

#import <CoreData/CoreData.h>



extern const struct MDatabaseAttributes {
	__unsafe_unretained NSString *hostname;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *plan;
	__unsafe_unretained NSString *port;
} MDatabaseAttributes;



extern const struct MDatabaseRelationships {
	__unsafe_unretained NSString *collections;
} MDatabaseRelationships;






@class MCollection;










@interface MDatabaseID : NSManagedObjectID {}
@end

@interface _MDatabase : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MDatabaseID*)objectID;





@property (nonatomic, strong) NSString* hostname;



//- (BOOL)validateHostname:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* plan;



//- (BOOL)validatePlan:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* port;




@property (atomic) int16_t portValue;
- (int16_t)portValue;
- (void)setPortValue:(int16_t)value_;


//- (BOOL)validatePort:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *collections;

- (NSMutableSet*)collectionsSet;





@end


@interface _MDatabase (CollectionsCoreDataGeneratedAccessors)
- (void)addCollections:(NSSet*)value_;
- (void)removeCollections:(NSSet*)value_;
- (void)addCollectionsObject:(MCollection*)value_;
- (void)removeCollectionsObject:(MCollection*)value_;
@end


@interface _MDatabase (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveHostname;
- (void)setPrimitiveHostname:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePlan;
- (void)setPrimitivePlan:(NSString*)value;




- (NSNumber*)primitivePort;
- (void)setPrimitivePort:(NSNumber*)value;

- (int16_t)primitivePortValue;
- (void)setPrimitivePortValue:(int16_t)value_;





- (NSMutableSet*)primitiveCollections;
- (void)setPrimitiveCollections:(NSMutableSet*)value;


@end
