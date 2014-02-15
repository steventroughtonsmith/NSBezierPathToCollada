//
//  main.m
//  NSBezierPathToCollada
//
//  Created by Steven Troughton-Smith on 15/02/2014.
//  Copyright (c) 2014 High Caffeine Content. All rights reserved.
//

@import Foundation;
@import SceneKit;
@import CoreGraphics;


/* Private API */

@protocol SCNCOLLADAExportOperation
- (void)main;
- (id)initWithScene:(id)arg1 attributes:(id)arg2 outputURL:(id)arg3;
@end

NSBezierPath *bezierPathToExport()
{
	/* 
	 
		Unit size is 1.0, so 1pt * 1pt - tiny 
		Sample shape made with Paintcode
	 
	 */

	NSBezierPath* starPath = [NSBezierPath bezierPath];
	[starPath moveToPoint: NSMakePoint(0.5, 1)];
	[starPath lineToPoint: NSMakePoint(0.68, 0.74)];
	[starPath lineToPoint: NSMakePoint(0.98, 0.65)];
	[starPath lineToPoint: NSMakePoint(0.79, 0.41)];
	[starPath lineToPoint: NSMakePoint(0.79, 0.1)];
	[starPath lineToPoint: NSMakePoint(0.5, 0.2)];
	[starPath lineToPoint: NSMakePoint(0.21, 0.1)];
	[starPath lineToPoint: NSMakePoint(0.21, 0.41)];
	[starPath lineToPoint: NSMakePoint(0.02, 0.65)];
	[starPath lineToPoint: NSMakePoint(0.32, 0.74)];
	[starPath closePath];
	
	return starPath;
}

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		NSString *fpath = @"/tmp/SCNExport.dae";
		CGFloat depth = 1.0;
		
		NSBezierPath *path = bezierPathToExport();
		
		
		SCNShape *shape = [SCNShape shapeWithPath:path extrusionDepth:depth];
		SCNNode *node = [SCNNode nodeWithGeometry:shape];
		
		SCNScene *scene = [SCNScene scene];
		[scene.rootNode addChildNode:node];
		
		id<SCNCOLLADAExportOperation> exporter = [[NSClassFromString(@"SCNCOLLADAExportOperation") alloc] initWithScene:scene attributes:nil outputURL:[NSURL fileURLWithPath:fpath]];
		
		NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
		[myQueue addOperation:(NSOperation *)exporter];

		[myQueue waitUntilAllOperationsAreFinished];
	}
    return 0;
}

