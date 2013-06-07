// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MCollection.m instead.

#import "_MCollection.h"


const struct MCollectionAttributes MCollectionAttributes = {
	.collectionID = @"collectionID",
	.count = @"count",
	.databaseID = @"databaseID",
	.indexCount = @"indexCount",
	.name = @"name",
	.storageSize = @"storageSize",
};



const struct MCollectionRelationships MCollectionRelationships = {
	.database = @"database",
};






@implementation MCollectionID
@end

@implementation _MCollection

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Collection" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Collection";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Collection" inManagedObjectContext:moc_];
}

- (MCollectionID*)objectID {
	return (MCollectionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"indexCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"indexCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"storageSizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"storageSize"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic collectionID;






@dynamic count;



- (int32_t)countValue {
	NSNumber *result = [self count];
	return [result intValue];
}


- (void)setCountValue:(int32_t)value_ {
	[self setCount:@(value_)];
}


- (int32_t)primitiveCountValue {
	NSNumber *result = [self primitiveCount];
	return [result intValue];
}

- (void)setPrimitiveCountValue:(int32_t)value_ {
	[self setPrimitiveCount:@(value_)];
}





@dynamic databaseID;






@dynamic indexCount;



- (int32_t)indexCountValue {
	NSNumber *result = [self indexCount];
	return [result intValue];
}


- (void)setIndexCountValue:(int32_t)value_ {
	[self setIndexCount:@(value_)];
}


- (int32_t)primitiveIndexCountValue {
	NSNumber *result = [self primitiveIndexCount];
	return [result intValue];
}

- (void)setPrimitiveIndexCountValue:(int32_t)value_ {
	[self setPrimitiveIndexCount:@(value_)];
}





@dynamic name;






@dynamic storageSize;



- (int32_t)storageSizeValue {
	NSNumber *result = [self storageSize];
	return [result intValue];
}


- (void)setStorageSizeValue:(int32_t)value_ {
	[self setStorageSize:@(value_)];
}


- (int32_t)primitiveStorageSizeValue {
	NSNumber *result = [self primitiveStorageSize];
	return [result intValue];
}

- (void)setPrimitiveStorageSizeValue:(int32_t)value_ {
	[self setPrimitiveStorageSize:@(value_)];
}





@dynamic database;

	






@end




