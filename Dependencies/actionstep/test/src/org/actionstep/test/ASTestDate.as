﻿/* See LICENSE for copyright and terms of use */

import org.actionstep.NSCalendarDate;
import org.actionstep.NSDateFormatter;
import org.actionstep.NSTimeZone;
import org.actionstep.NSApplication;

/**
 * Tests the <code>org.actionstep.NSCalendarDate</code> and 
 * <code>org.actionstep.NSDate</code> classes. 
 *
 * @author Scott Hyndman
 */
class org.actionstep.test.ASTestDate 
{	
	public static function test():Void
	{
		NSApplication.sharedApplication().run();
		
		var dtFormatter:NSDateFormatter;
		var momsBDay:NSCalendarDate;
		var dob:NSCalendarDate;
		var tz:NSTimeZone = NSTimeZone.timeZoneForSecondsFromGMT(0);
		
		momsBDay = (new NSCalendarDate()).initWithYearMonthDayHourMinuteSecondTimeZone(
			1936, 1, 8, 7, 30, 0, tz);
			
		dob = (new NSCalendarDate()).initWithYearMonthDayHourMinuteSecondTimeZone(
			1965, 12, 7, 17, 25, 0, tz);
		
		var since:Object = dob.yearsMonthsDaysHoursMinutesSecondsSinceDate(momsBDay);
		traceSince(since);
		
		dtFormatter = (new NSDateFormatter()).initWithDateFormatAllowNaturalLanguage
			("%A, %B %d, %Y %G %H:%M:%S %Z", true);
		trace(dtFormatter.stringFromDate(dob));
	}
	
	private static function traceSince(since:Object):Void
	{
		trace("years " + since.years);
		trace("months " + since.months);
		trace("days " + since.days);
		trace("hours " + since.hours);
		trace("minutes " + since.minutes);
		trace("seconds " + since.seconds);
	}
}