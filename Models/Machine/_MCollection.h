// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MCollection.h instead.

#import <CoreData/CoreData.h>



extern const struct MCollectionAttributes {
	__unsafe_unretained NSString *count;
	__unsafe_unretained NSString *indexCount;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *storageSize;
} MCollectionAttributes;



extern const struct MCollectionRelationships {
	__unsafe_unretained NSString *database;
} MCollectionRelationships;






@class MDatabase;










@interface MCollectionID : NSManagedObjectID {}
@end

@interface _MCollection : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MCollectionID*)objectID;





@property (nonatomic, strong) NSNumber* count;




@property (atomic) int32_t countValue;
- (int32_t)countValue;
- (void)setCountValue:(int32_t)value_;


//- (BOOL)validateCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* indexCount;




@property (atomic) int32_t indexCountValue;
- (int32_t)indexCountValue;
- (void)setIndexCountValue:(int32_t)value_;


//- (BOOL)validateIndexCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* storageSize;




@property (atomic) int32_t storageSizeValue;
- (int32_t)storageSizeValue;
- (void)setStorageSizeValue:(int32_t)value_;


//- (BOOL)validateStorageSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MDatabase *database;

//- (BOOL)validateDatabase:(id*)value_ error:(NSError**)error_;





@end



@interface _MCollection (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCount;
- (void)setPrimitiveCount:(NSNumber*)value;

- (int32_t)primitiveCountValue;
- (void)setPrimitiveCountValue:(int32_t)value_;




- (NSNumber*)primitiveIndexCount;
- (void)setPrimitiveIndexCount:(NSNumber*)value;

- (int32_t)primitiveIndexCountValue;
- (void)setPrimitiveIndexCountValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveStorageSize;
- (void)setPrimitiveStorageSize:(NSNumber*)value;

- (int32_t)primitiveStorageSizeValue;
- (void)setPrimitiveStorageSizeValue:(int32_t)value_;





- (MDatabase*)primitiveDatabase;
- (void)setPrimitiveDatabase:(MDatabase*)value;


@end
