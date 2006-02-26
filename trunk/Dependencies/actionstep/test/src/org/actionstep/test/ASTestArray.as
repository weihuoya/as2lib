/* See LICENSE for copyright and terms of use */

import org.actionstep.constants.NSComparisonResult;
import org.actionstep.NSArray;
import org.actionstep.NSSortDescriptor;
import org.actionstep.test.arrays.ASTestArrayElement;

/**
 * Tests the <code>NSArray</code> class.
 *
 * @author Scott Hyndman
 */
class org.actionstep.test.ASTestArray 
{	
	public static function test():Void
	{
		var start:Number;
		var arrDates:Array = [
			new Date(1983, 3, 10), 
			new Date(2007, 4, 21), 
			new Date(1989, 6, 1, 23, 30),
			new Date(1989, 6, 1, 23, 10),
			new Date(1989, 6, 1, 22, 10),
			new Date(1992, 6, 0),
			new Date(1998, 4, 1),
			new Date(1990, 8, 27)
			];
			
		var arr:NSArray = NSArray.arrayWithArray(arrDates);
		
		//
		// Test 1 - sortUsingFunctionContext
		//
		trace("Beginning sortUsingFunctionContext test");
		trace("***** BEFORE");
		trace(arr);
		start = getTimer();
		arr.sortUsingFunctionContext(compareDates, null);
		trace("***** AFTER - time taken: " + (getTimer() - start) + "ms");
		trace(arr);
		
		//
		// Test 2 - sortUsingSelector
		//		
		var arrObjs:Array = [
			new ASTestArrayElement(5),
			new ASTestArrayElement(25),
			new ASTestArrayElement(3),
			new ASTestArrayElement(15),
			new ASTestArrayElement(99),
			new ASTestArrayElement(10)
			];
			
		arr = NSArray.arrayWithArray(arrObjs);
		trace("Beginning sortUsingSelector test");
		trace("***** BEFORE");
		trace(arr);
		start = getTimer();
		arr.sortUsingSelector("compareAge");
		trace("***** AFTER - time taken: " + (getTimer() - start) + "ms");
		trace(arr);
		
		//
		// Test 3 - sortUsingDescriptors - single descriptor, no key, descending
		//
		var arrObjs2:Array = [
			new ASTestArrayElement(5),
			new ASTestArrayElement(25),
			new ASTestArrayElement(3),
			new ASTestArrayElement(15),
			new ASTestArrayElement(99),
			new ASTestArrayElement(10)
			];
			
		arr = NSArray.arrayWithArray(arrObjs2);
		
		var sd:NSSortDescriptor = new NSSortDescriptor();
		sd = sd.initWithKeyAscendingSelector(null, false, "compareAge");
		var arrSD:NSArray = NSArray.arrayWithObject(sd);
		
		trace("Beginning sortUsingDescriptors test - single descriptor, no key, descending");
		trace("***** BEFORE");
		trace(arr);
		start = getTimer();
		arr.sortUsingDescriptors(arrSD);
		trace("***** AFTER - time taken: " + (getTimer() - start) + "ms");
		trace(arr);
		
		//
		// Test 4 - sortUsingDescriptors - single descriptor, key
		//
		var arrObjs3:Array = [
			new ASTestArrayElement(5),
			new ASTestArrayElement(25),
			new ASTestArrayElement(3),
			new ASTestArrayElement(15),
			new ASTestArrayElement(99),
			new ASTestArrayElement(10)
			];
			
		arr = NSArray.arrayWithArray(arrObjs3);
		
		sd = new NSSortDescriptor();
		sd = sd.initWithKeyAscendingSelector("age", true, "compareProperty");
		arrSD = NSArray.arrayWithObject(sd);
		
		trace("Beginning sortUsingDescriptors test - single descriptor, key");
		trace("***** BEFORE");
		trace(arr);
		start = getTimer();
		arr.sortUsingDescriptors(arrSD);
		trace("***** AFTER - time taken: " + (getTimer() - start) + "ms");
		trace(arr);
		
		//
		// Test 5 - sortUsingDescriptors - multiple descriptor
		//
		var arrObjs4:Array = [
			new ASTestArrayElement(5, 120),
			new ASTestArrayElement(5, 140),
			new ASTestArrayElement(5, 80),
			new ASTestArrayElement(25, 116),
			new ASTestArrayElement(3, 132),
			new ASTestArrayElement(15, 160),
			new ASTestArrayElement(99, 10),
			new ASTestArrayElement(10, 200)
			];
			
		arr = NSArray.arrayWithArray(arrObjs4);
		
		arrSD.removeAllObjects();
		
		sd = new NSSortDescriptor();
		sd = sd.initWithKeyAscendingSelector("age", true, "compareProperty");
		arrSD.addObject(sd);
		
		sd = new NSSortDescriptor();
		sd = sd.initWithKeyAscendingSelector("iq", false, "compareProperty");
		arrSD.addObject(sd);
		
		trace("Beginning sortUsingDescriptors test - multiple descriptor, age ASC, iq DESC");
		trace("***** BEFORE");
		trace(arr);
		start = getTimer();
		arr.sortUsingDescriptors(arrSD);
		trace("***** AFTER - time taken: " + (getTimer() - start) + "ms");
		trace(arr);
	}
	
	private static function compareNums(a:Number, b:Number, context:Object):Number
	{
		if (a < b)
			//return NSComparisonResult.NSOrderedAscending;
			return -1;
		else if (a > b)
			return 1;
			//return NSComparisonResult.NSOrderedDescending;
			
		return 0;
		//return NSComparisonResult.NSOrderedSame;
	}
	
	private static function compareDates(a:Date, b:Date, context:Object):NSComparisonResult
	{
		if (a.getTime() < b.getTime())
			return NSComparisonResult.NSOrderedAscending;
		else if (a.getTime() > b.getTime())
			return NSComparisonResult.NSOrderedDescending;
			
		return NSComparisonResult.NSOrderedSame;
	}
}