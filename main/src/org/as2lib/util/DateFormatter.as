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
import org.as2lib.env.except.IllegalArgumentException;

/**
 * 
 *
 * @author Simon Wacker
 */
class org.as2lib.util.DateFormatter extends BasicClass {
	
	/** Placeholder for year in date format. */
	public static var YEAR:String = "y";
	
	/** Placeholder for month as number in date format. */
	public static var MONTH_AS_NUMBER:String = "m";
	
	/** Placeholder for month as text in date format. */
	public static var MONTH_AS_TEXT:String = "M";
	
	/** Placeholder for day of month as number in date format. */
	public static var DAY_AS_NUMBER:String = "d";
	
	/** Placeholder for day of week as text in date format. */
	public static var DAY_AS_TEXT:String = "D";
	
	/** Fully written out string for january. */
	public static var JANUARY:String = "January";
	
	/** Fully written out string for february. */
	public static var FEBRUARY:String = "February";
	
	/** Fully written out string for march. */
	public static var MARCH:String = "March";
	
	/** Fully written out string for april. */
	public static var APRIL:String = "April";
	
	/** Fully written out string for may. */
	public static var MAY:String = "May";
	
	/** Fully written out string for june. */
	public static var JUNE:String = "June";
	
	/** Fully written out string for july. */
	public static var JULY:String = "July";
	
	/** Fully written out string for august. */
	public static var AUGUST:String = "August";
	
	/** Fully written out string for september. */
	public static var SEPTEMBER:String = "September";
	
	/** Fully written out string for october. */
	public static var OCTOBER:String = "October";
	
	/** Fully written out string for november. */
	public static var NOVEMBER:String = "November";
	
	/** Fully written out string for december. */
	public static var DECEMBER:String = "December";
	
	/** Fully written out string for monday. */
	public static var MONDAY:String = "Monday";
	
	/** Fully written out string for tuesday. */
	public static var TUESDAY:String = "Tuesday";
	
	/** Fully written out string for wednesday. */
	public static var WEDNESDAY:String = "Wednesday";
	
	/** Fully written out string for thursday. */
	public static var THURSDAY:String = "Thursday";
	
	/** Fully written out string for friday. */
	public static var FRIDAY:String = "Friday";
	
	/** Fully written out string for saturday. */
	public static var SATURDAY:String = "Saturday";
	
	/** Fully written out string for sunday. */
	public static var SUNDAY:String = "Sunday";
	
	/** The pattern to format the date with. */
	private var dateFormat:String;
	
	/**
	 * Constructs a new {@code DateFormatter} instance.
	 *
	 * <p>If you do not pass-in a {@code dateFormat} or if the passed-in
	 * one is null or undefined the default data format is used.
	 *
	 * @param dateFormat (optional) the pattern describing the data and time
	 * format
	 * @todo what is the default data format?
	 */
	public function DateFormatter(dateFormat:String) {
		this.dateFormat = dateFormat;
	}
	
	/**
	 * Formats the passed-in {@code date} with the specified date format
	 * pattern into a date-time string and returns the resulting string.
	 *
	 * <p>If the passed-in {@code date} is null or undefined, the current
	 * date-time will be used instead.
	 *
	 * @param date the date-time value to format into a date-time string
	 * @return the formatted date-time string
	 */
	public function format(date:Date):String {
		var result:String = "";
		for (var i:Number = 0; i < dateFormat.length; i++) {
			if (dateFormat.substr(i, 1) == YEAR) {
				var tokenCount:Number = getTokenCount(dateFormat.substr(i));
				result += formatYear(date.getFullYear(), tokenCount);
				i += tokenCount - 1;
				continue;
			}
			if (dateFormat.substr(i, 1) == MONTH_AS_NUMBER) {
				var tokenCount:Number = getTokenCount(dateFormat.substr(i));
				result += formatMonthAsNumber(date.getMonth(), tokenCount);
				i += tokenCount - 1;
				continue;
			}
			if (dateFormat.substr(i, 1) == MONTH_AS_TEXT) {
				var tokenCount:Number = getTokenCount(dateFormat.substr(i));
				result += formatMonthAsText(date.getMonth(), tokenCount);
				i += tokenCount - 1;
				continue;
			}
			if (dateFormat.substr(i, 1) == DAY_AS_NUMBER) {
				var tokenCount:Number = getTokenCount(dateFormat.substr(i));
				result += formatDayAsNumber(date.getDate(), tokenCount);
				i += tokenCount - 1;
				continue;
			}
			if (dateFormat.substr(i, 1) == DAY_AS_TEXT) {
				var tokenCount:Number = getTokenCount(dateFormat.substr(i));
				result += formatDayAsText(date.getDay(), tokenCount);
				i += tokenCount - 1;
				continue;
			}
			result += dateFormat.substr(i, 1);
		}
		return result;
	}
	
	/**
	 * Returns the number of tokens that occur in a succession from the
	 * beginning of the passed-in {@code string}.
	 *
	 * <p>If the passed-in {@code string} is null, undefined or empty, zero
	 * is returned.
	 *
	 * @param string the string to search through
	 * @return the number of tokens that occur in a succession
	 */
	private function getTokenCount(string:String):Number {
		if (!string) return 0;
		var result = 0;
		var token:String = string.substr(0, 1);
		while (string.substr(result, 1) == token) {
			result++;
		}
		return result;
	}
	
	/**
	 * Formats the passed-in {@code year} into a year string with the specified
	 * {@code digitCount}.
	 *
	 * <p>A {@code digitCount} less or equal than three results in a year
	 * string with two digits. A {@code digitCount} greater or equal than
	 * four results in a year string with four digits plus preceding zeros
	 * if the {@code digitCount} is greater than four.
	 *
	 * @param year the year to format to a string
	 * @param digitCount the number of expected digits
	 * @return the string representation of the year
	 */
	private function formatYear(year:Number, digitCount:Number):String {
		if (digitCount < 4) {
			return year.toString().substr(2);
		}
		var zeros:String = "";
		while (digitCount > 4) {
			zeros += "0";
			digitCount--;
		}
		return (zeros + year.toString());
	}
	
	/**
	 * Formats the passed-in {@code month} into a month as number string
	 * with the specified {@code digitCount}.
	 * 
	 * <p>A {@code digitCount} less or equal than one results in a month
	 * with one digit, if the month is less or equal than nine. Otherwise
	 * the month is represented by a two digit number. A {@code digitCount}
	 * greater or equal than two results in a month with preceding zeros.
	 *
	 * <p>{@code month} must be a number from 0 to 11.
	 *
	 * @param month the month to format to a number string
	 * @param digitCount the number of expected digits
	 * @return the number representation of the month
	 * @throws IllegalArgumentException if the passed-in {@code month} is
	 * less than 0 or greater than 11
	 */
	private function formatMonthAsNumber(month:Number, digitCount:Number):String {
		if (month < 0 || month > 11) {
			throw new IllegalArgumentException("Argument 'month' [" + month + "] must not be less than 0 nor greater than 11.", this, arguments);
		}
		var result:String = (month + 1).toString();
		if (digitCount > result.length) {
			var i:Number = digitCount - result.length;
			while (i) {
				result = "0" + result;
				i--;
			}
		}
		return result;
	}
	
	/**
	 * Formats the passed-in {@code month} into a string with the specified
	 * {@code tokenCount}.
	 *
	 * <p>A {@code tokenCount} less or equal than three results in a month
	 * with three tokens. A {@code tokenCount} greater or equal than four
	 * results in a fully written out month.
	 *
	 * <p>{@code month} must be a number from 0 to 11.
	 *
	 * @param month the month to format to a string
	 * @param tokenCount the number of expected tokens
	 * @return the string representation of the month
	 * @throws IllegalArgumentException if the passed-in {@code month} is
	 * less than 0 or greater than 11
	 */
	private function formatMonthAsText(month:Number, tokenCount:Number):String {
		if (month < 0 || month > 11) {
			throw new IllegalArgumentException("Argument 'month' [" + month + "] must not be less than 0 nor greater than 11.", this, arguments);
		}
		var result:String;
		switch (month) {
			case 0:
				result = JANUARY;
				break;
			case 1:
				result = FEBRUARY;
				break;
			case 2:
				result = MARCH;
				break;
			case 3:
				result = APRIL;
				break;
			case 4:
				result = MAY;
				break;
			case 5:
				result = JUNE;
				break;
			case 6:
				result = JULY;
				break;
			case 7:
				result = AUGUST;
				break;
			case 8:
				result = SEPTEMBER;
				break;
			case 9:
				result = OCTOBER;
				break;
			case 10:
				result = NOVEMBER;
				break;
			case 11:
				result = DECEMBER;
				break;
		}
		if (tokenCount < 4) {
			return result.substr(0, 3);
		}
		return result;
	}
	
	/**
	 * Formats the passed-in {@code month} into a month as number string
	 * with the specified {@code digitCount}.
	 * 
	 * <p>A {@code digitCount} less or equal than one results in a month
	 * with one digit, if the month is less or equal than nine. Otherwise
	 * the month is represented by a two digit number. A {@code digitCount}
	 * greater or equal than two results in a month with preceding zeros.
	 *
	 * <p>{@code month} must be a number from 0 to 11.
	 *
	 * @param month the month to format to a number string
	 * @param digitCount the number of expected digits
	 * @return the number representation of the month
	 * @throws IllegalArgumentException if the passed-in {@code month} is
	 * less than 0 or greater than 11
	 */
	
	/**
	 * Formats the passed-in {@code day} into a day as number string with
	 * the specified {@code digitCount}.
	 *
	 * <p>A {@code digitCount} less or equal than one results in a day with
	 * one digit, if the day is less or equal than nine. Otherwise the day
	 * is represented by a two digit number. A {@code digitCount} greater or
	 * equal than two results in a day with preceding zeros.
	 *
	 * <p>{@code day} must be a number from 1 to 31.
	 *
	 * @param day the day of month to format to a number string
	 * @param digitCount the number of digits
	 * @return the number representation of the day
	 * @throws IllegalArgumentException if the passed-in {@code day} is less
	 * than 1 or greater than 31.
	 */
	private function formatDayAsNumber(day:Number, digitCount:Number):String {
		if (day < 1 || day > 31) {
			throw new IllegalArgumentException("Argument 'day' [" + day + "] must not be less than 1 nor greater than 31.", this, arguments);
		}
		var result:String = day.toString();
		if (digitCount > result.length) {
			var i:Number = digitCount - result.length;
			while (i) {
				result = "0" + result;
				i--;
			}
		}
		return result;
	}
	
	/**
	 * Formats the passed-in {@code day} into a string with the specified
	 * {@code tokenCount}.
	 *
	 * <p>A {@code tokenCount} less or equal than three results in a day
	 * with two tokens. A {@code tokenCount} greater or equal than four
	 * results in a fully written out day.
	 *
	 * <p>{@code day} must be a number from 0 to 6.
	 *
	 * @param day the day to format to a string
	 * @param tokenCount the number of expected tokens
	 * @return the string representation of the day
	 * @throws IllegalArgumentException if the passed-in {@code day} is less
	 * than 0 or greater than 6.
	 */
	private function formatDayAsText(day:Number, tokenCount:Number):String {
		if (day < 0 || day > 6) {
			throw new IllegalArgumentException("Argument 'day' [" + day + "] must not be less than 0 nor greater than 6.", this, arguments);
		}
		var result:String;
		switch (day) {
			case 0:
				result = SUNDAY;
				break;
			case 1:
				result = MONDAY;
				break;
			case 2:
				result = TUESDAY;
				break;
			case 3:
				result = WEDNESDAY;
				break;
			case 4:
				result = THURSDAY;
				break;
			case 5:
				result = FRIDAY;
				break;
			case 6:
				result = SATURDAY;
				break;
		}
		if (tokenCount < 4) {
			return result.substr(0, 2);
		}
		return result;
	}
	
}