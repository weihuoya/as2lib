/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;
import org.as2lib.util.MathUtil;

/**
 * {@code Time} is a holder for a timedistance.
 * 
 * <p>{@code Time} seperates a timedistance into days, hours, minutes, seconds and
 * milliseconds to offers methods to access the time distance in different ways.
 * 
 * <p>There are two ways to access the {@code Time} instance:
 * 
 * <p>The first way is by {@code as*()}({@code asHours()}, {@code asMinutes()},...).
 * Those methods are coversions to the different time units. You can recieve the
 * complete value in a different unit.
 * 
 * <p>The second way is by {@code get*()}({@code getHours()}, {@code getMinutes()},...).
 * Those methods contain only the part of each unit that is contained within the
 * value.
 * 
 * <p>Example:
 * <code>
 *   var t:Time = new Time(5400000);
 *   trace(t.getHours()); // 1.5
 *   trace(t.getHours(1)); // 1.5
 *   trace(t.getHours(0)); // 1
 *   trace(t.getMinutes()); // 30
 *   
 *   t = t.plus(new Time(1.5, "h"));
 *   trace(t.getHours()); // 3
 *   trace(t.getMinutes()); // 0
 *   
 *   t = t.minus(new Time(1800000));
 *   trace(t.getHours()); // 0.5
 *   trace(t.getHours(0)); // 0
 *   trace(t.getHours(1)); // 0.5
 *   trace(t.getMinutes()); // 30 
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.data.type.Time extends BasicClass {
	
	/** factor from ms to second */ 
	private static var SECOND:Number = 1000;
	
	/** factor from ms to minute */
	private static var MINUTE:Number = SECOND*60;
	
	/** factor from ms to hour */
	private static var HOUR:Number = MINUTE*60;
	
	/** factor from ms to day */
	private static var DAY:Number = HOUR*24;
	
	/** internal holder of the time in ms */
	private var ms:Number;
	
	/** hlder for the amount of days */
	private var days:Number;
	
	/** holder for the amount of hours */
	private var hours:Number;
	
	/** holder for the amount of minutes */
	private var minutes:Number;
	
	/** holder for the amount of seconds */
	private var seconds:Number;
	
	/** holder for the amount of milliseconds */
	private var milliSeconds:Number;
	
	/** Flag if the instance need to be evaluated by {@link #evaluate} */
	private var doEval:Boolean = true;
	
	/**
	 * Constructs a new instance of {@code Time}.
	 * 
	 * <p>Uses "ms" if no or "wrong" gets used and recalculates it to Uses {@code Number.MAX_VALUE} if
	 * {@code Infinity} gets passed-in.
	 * 
	 * 
     * @param time amount of time for the passed-in {@code format}
     * @param format (optional) "d"/"h"/"m"/"s"/"ms" for the unit of the amout,
     * 	      default case is "ms"
	 */
	public function Time(number:Number, format:String) {
		setValue(number, format);
	}
	
	/** 
	 * Sets the time of the instance.
	 * <p>Uses ms if a wrong format gets used. Uses Number.MAX_VALUE if Infinity
	 * is used.
	 * 
     * @param time Amount in time for the current
     * @param format (optional) "d"/"h"/"m"/"s"/"ms" for the unit of the amout.
     * 		  Default value is ms.
	 */
	public function setValue(number:Number, format:String):Time {
		if (number == Infinity) {
			number = Number.MAX_VALUE;
		}
		switch (format) {
			case null:
			case undefined:
				ms = number;
				break;
			case "d":
				ms = number*DAY;
				break;
			case "h":
				ms = number*HOUR;
				break;
			case "m":
				ms = number*MINUTE;
				break;
			case "s":
				ms = number*SECOND;
				break;
			default:
				ms = number;
		}
		
		// By clearing the instance value (false) it will use the proto value (true)
		delete doEval;
		return this;
	}
	
	/**
	 * Adds the passed-in {@code timedistance} to the current time.
	 *  
	 * @param timedistance timedistance to be added to the current time
	 * @return new instance with the resulting amount of time
	 */
	public function plus(timedistance:Time):Time {
		return new Time(ms+timedistance.valueOf());
	}
	
	/**
	 * Adds the passed-in {@code timedistance} from the current time.
	 *  
	 * @param timedistance timedistance to be removed from the current time
	 * @return new instance with the resulting amount of time
	 */
	public function minus(time:Time):Time {
		return new Time(ms-time.valueOf());
	}
	
	/**
	 * Getter for the amount of milliseconds are contained within the time.
	 * 
	 * <p>It will not round the result if you pass-in nothing.
	 * 
	 * @param round (optional) the number of decimal spaces
	 * @return timedistance in milliseconds
	 */
	public function getMilliSeconds(round:Number):Number {
		if (doEval) evaluate();
		if (round == null) {
			return milliSeconds;
		} else {
			return MathUtil.round(milliSeconds, round);
		}
	}
	
	/**
	 * Getter for the time distance in milliseconds.
	 * 
	 * @return timedistance in milliseconds
	 */
	public function asMilliSeconds(Void):Number {
		return ms;
	}
	
	/**
	 * Getter for the amount of seconds are contained within the time.
	 * 
	 * <p>It will not round the result if you pass-in nothing.
	 * 
	 * @param round (optional) the number of decimal spaces
	 * @return timedistance in seconds
	 */
	public function getSeconds(round:Number):Number {
		if (doEval) evaluate();
		if (round == null) {
			return seconds;
		} else {
			return MathUtil.round(seconds, round);
		}
	}
	
	/**
	 * Getter for the time distance in seconds.
	 * 
	 * @return timedistance in seconds
	 */
	public function asSeconds(Void):Number {
		return ms/SECOND;
	}
	
	/**
	 * Getter for the amount of minutes are contained within the time.
	 * 
	 * <p>It will not round the result if you pass-in nothing.
	 * 
	 * @param round (optional) the number of decimal spaces
	 * @return timedistance in minutes
	 */
	public function getMinutes(round:Number):Number {
		if (doEval) evaluate();
		if (round == null) {
			return minutes;
		} else {
			return MathUtil.round(minutes, round);
		}
	}
	
	/**
	 * Getter for the time distance in minutes.
	 * 
	 * @return timedistance in minutes
	 */
	public function asMinutes(Void):Number {
		return ms/MINUTE;
	}
	
	/**
	 * Getter for the amount of hours are contained within the time.
	 * 
	 * <p>It will not round the result if you pass-in nothing.
	 * 
	 * @param round (optional) the number of decimal spaces
	 * @return timedistance in hours
	 */
	public function getHours(round:Number):Number {
		if (doEval) evaluate();
		if (round == null) {
			return hours;
		} else {
			return MathUtil.round(hours, round);
		}
	}
	
	/**
	 * Getter for the time distance in hours.
	 * 
	 * @return timedistance in hours
	 */
	public function asHours(Void):Number {
		return ms/HOUR;
	}
	
	/**
	 * Getter for the amount of days are contained within the time.
	 * 
	 * <p>It will not round the result if you pass-in nothing.
	 * 
	 * @param round (optional) the number of decimal spaces
	 * @return timedistance in days
	 */
	public function getDays(round:Number):Number {
		if (doEval) evaluate();
		if (round == null) {
			return days;
		} else {
			return MathUtil.round(days, round);
		}
	}
	
	/**
	 * Getter for the time distance in days.
	 * 
	 * @return timedistance in days
	 */
	public function asDays(Void):Number {
		return ms/DAY;
	}
	
	/**
	 * Generates String representation of the time.
	 * 
	 * @return time as string
	 */
	public function toString():String {
		return getDays(0)+"d "+getHours(0)+":"+getMinutes(0)+":"+getSeconds(0)+"."+getMilliSeconds(0);
	}
	
	/**
	 * Evaluates all units
	 */
	private function evaluate(Void):Void {
		var negative = (ms >= 0) ? 1 : -1;
		var rest:Number = ms;
		
		days = rest/DAY;
		rest -= negative*Math.floor(days)*DAY;
		
		hours = rest/HOUR;
		rest -= negative*Math.floor(hours)*HOUR;
		
		minutes = rest/MINUTE;
		rest -= negative*Math.floor(minutes)*MINUTE;
		
		seconds = rest/SECOND;
		rest -= negative*Math.floor(seconds)*SECOND;
		
		milliSeconds = rest;
		
		doEval = false;
	}
	
	/**
	 * Returns the value of the time distance (in ms).
	 * 
	 * @return value in ms
	 */
	public function valueOf():Number {
		return ms;
	}
}