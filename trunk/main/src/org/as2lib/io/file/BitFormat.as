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
 * Formater for bit.
 * This class gets used for formatting bits in Kilo/Mega/Giga/Tera bits.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.io.file.BitFormat extends BasicClass {
	
	/** Default floating points used */
	private static var DEFAULT_FLOATING_POINTS:Number = 2;
	
	/** Size of a kilo */
	private static var KILO:Number = 1024;
	
	/** Size of a kilobit */
	private static var KILO_BIT:Number = KILO;
	
	/** Size of a megabit */
	private static var MEGA_BIT:Number = KILO_BIT*KILO;
	
	/** Size of a gigabit */
	private static var GIGA_BIT:Number = MEGA_BIT*KILO;
	
	/** Size of a terabit */
	private static var TERA_BIT:Number = GIGA_BIT*KILO;
	
	/** Size of a byte */
	private static var BYTE:Number = 8;
	
	/** Size of a kilobyte */
	private static var KILO_BYTE:Number = KILO*BYTE;
	
	/** Size of a megabyte */
	private static var MEGA_BYTE:Number = KILO_BYTE*KILO;
	
	/** Size of a gigabyte */
	private static var GIGA_BYTE:Number = MEGA_BYTE*KILO;
	
	/** Size of a terabyte */
	private static var TERA_BYTE:Number = GIGA_BYTE*KILO;
	
	/** Shortname of bit */
	private static var SHORT_BIT:String = "b";
	
	/** Shortname of kilobit */
	private static var SHORT_KILO_BIT:String = "Kb";
	
	/** Shortname of megabit */
	private static var SHORT_MEGA_BIT:String = "Mb";
	
	/** Shortname of gigabit */
	private static var SHORT_GIGA_BIT:String = "Gb";
	
	/** Shortname of terabit */
	private static var SHORT_TERA_BIT:String = "Tb";
	
	/** Holder for the amount of bits */
	private var bit:Number;
	
	/** Holder for the comma seperation */
	private var comma:Number;
	
	/**
	 * Constructs a new BitFormat
	 * 
	 * @param bit Bit to be formatted.
	 */
	public function BitFormat(bit:Number) {
		this.bit = bit;
		comma = DEFAULT_FLOATING_POINTS;
	}
	
	/**
	 * Sets the used amount of values after the comma.
	 * 
	 * @param fp Amount of characters after the floating point.
	 * @return The current instance for faster access.
	 * @throws IllegalArgumentException if you pass  
	 */
	public function setFloatingPoints(fp:Number):BitFormat {
		if(fp >= 0 && fp != null) {
			this.comma = fp;
			return this
		} else {
			throw new IllegalArgumentException("No valid amount of floating points ("+fp+") used.", this, arguments);
		}
	}
	
	/**
	 * Rounds a number by a count of floating points.
	 * 
	 * @param num Number to be rounded.
	 * @param fp Amount of characters after the floating point.
	 */
	private function round(num:Number, fp:Number):Number {
		var result:Number = 1;
		for(var i:Number = 0; i<fp; i++) {
			result *= 10;
		}
		return (Math.round(num*result)/result);
	}
	
	/**
	 * Getter for the value in bit.
	 * 
	 * @return Value in bit.
	 * @see #BitFormat
	 */
	public function getBit(Void):Number {
		return bit;
	}
	
	/**
	 * Getter for the value in bytes.
	 * 
	 * @return Value in bytes.
	 * @see #BitFormat
	 */
	public function getBytes(Void):Number {
		return round(bit/BYTE, comma);
	}
	
	/**
	 * Getter for the value in kilobit.
	 * 
	 * @return Value in kilobit.
	 * @see #BitFormat
	 */
	public function getKiloBit(Void):Number {
		return round(bit/KILO_BIT, comma);
	}
	
	/**
	 * Getter for the value in kilobytes.
	 * 
	 * @return Value in kilobytes.
	 * @see #BitFormat
	 */
	public function getKiloBytes(Void):Number {
		return round(bit/KILO_BYTE, comma);
	}
	
	/**
	 * Getter for the value in megabit.
	 * 
	 * @return Value in megabit.
	 * @see #BitFormat
	 */
	public function getMegaBit(Void):Number {
		return round(bit/MEGA_BIT, comma);
	}
	
	/**
	 * Getter for the value in megabytes.
	 * 
	 * @return Value in megabytes.
	 * @see #BitFormat
	 */
	public function getMegaBytes(Void):Number {
		return round(bit/MEGA_BYTE, comma);
	}
	
	/**
	 * Getter for the value in gigabit.
	 * 
	 * @return Value in gigabit.
	 * @see #BitFormat
	 */
	public function getGigaBit(Void):Number {
		return round(bit/GIGA_BIT, comma);
	}
	
	/**
	 * Getter for the value in gigabytes.
	 * 
	 * @return Value in gigabytes.
	 * @see #BitFormat
	 */
	public function getGigaBytes(Void):Number {
		return round(bit/GIGA_BYTE, comma);
	}
	
	/**
	 * Getter for the value in terabit.
	 * 
	 * @return Value in terabit.
	 * @see #BitFormat
	 */
	public function getTeraBit(Void):Number {
		return round(bit/TERA_BIT, comma);
	}
	
	/**
	 * Getter for the value in terabytes.
	 * 
	 * @return Value in terabytes.
	 * @see #BitFormat
	 */
	public function getTeraBytes(Void):Number {
		return round(bit/TERA_BYTE, comma);
	}
	
	/**
	 * Extended toString method for a well formatted bitvalue.
	 * This method uses the next matching size and adds the matching Shortname for it.
	 * 
	 * Examples:
	 *   new BitFormat(1).toString(); // 1b
	 *   new BitFormat(1234).toString(); // 1.21Kb
	 *   new BitFormat(15002344).toString(); // 14.31Mb
	 * 
	 * @return bits as string with correct ending.
	 * @see #DEFAULT_FLOATING_POINTS
	 */
	public function toString():String {
		if(bit < KILO_BIT) {
			return getBit()+SHORT_BIT;
		} else if(bit < MEGA_BIT) {
			return getKiloBit()+SHORT_KILO_BIT;
		} else if(bit < GIGA_BIT) {
			return getMegaBit()+SHORT_MEGA_BIT;
		} else if(bit < TERA_BIT) {
			return getGigaBit()+SHORT_GIGA_BIT;
		} else {
			return getTeraBit()+SHORT_TERA_BIT;
		}
	}
}