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

import org.as2lib.test.unit.TestCase;
import org.as2lib.util.DateFormatter;

/**
 * @author Simon Wacker
 */
class org.as2lib.util.TDateFormatter extends TestCase {
	
	public function testFormat(Void):Void {
		var f:DateFormatter = new DateFormatter("dd.mm.yyyy");
		assertSame("pattern 'dd.mm.yyyy' is interpreted wrongly", "08.03.2005", f.format(new Date(2005, 2, 8)));
	}
	
	public function testFormatYear(Void):Void {
		var f:DateFormatter;
		f = new DateFormatter("y");
		assertSame("pattern 'y' is interpreted wrongly", "05", f.format(new Date(2005, 0)));
		f = new DateFormatter("yy");
		assertSame("pattern 'yy' is interpreted wrongly", "02", f.format(new Date(2002, 0)));
		f = new DateFormatter("yyy");
		assertSame("pattern 'yyy' is interpreted wrongly", "48", f.format(new Date(1948, 0)));
		f = new DateFormatter("yyyy");
		assertSame("pattern 'yyyy' is interpreted wrongly", "2005", f.format(new Date(2005, 0)));
		f = new DateFormatter("yyyyy");
		assertSame("pattern 'yyyyy' is interpreted wrongly", "02005", f.format(new Date(2005, 0)));
		f = new DateFormatter("yyyyyy");
		assertSame("pattern 'yyyyyy' is interpreted wrongly", "001986", f.format(new Date(1986, 0)));
	}
	
	public function testFormatMonthAsNumber(Void):Void {
		var f:DateFormatter;
		f = new DateFormatter("m");
		assertSame("pattern 'm' is interpreted wrongly", "3", f.format(new Date(2005, 2)));
		f = new DateFormatter("m");
		assertSame("pattern 'm' is interpreted wrongly", "11", f.format(new Date(2005, 10)));
		f = new DateFormatter("mm");
		assertSame("pattern 'mm' is interpreted wrongly", "05", f.format(new Date(2005, 4)));
		f = new DateFormatter("mm");
		assertSame("pattern 'mm' is interpreted wrongly", "12", f.format(new Date(2005, 11)));
		f = new DateFormatter("mmm");
		assertSame("pattern 'mmm' is interpreted wrongly", "009", f.format(new Date(2005, 8)));
		f = new DateFormatter("mmmm");
		assertSame("pattern 'mmmm' is interpreted wrongly", "0010", f.format(new Date(2005, 9)));
	}
	
	public function testFormatMonthAsText(Void):Void {
		var f:DateFormatter;
		f = new DateFormatter("M");
		assertSame("pattern 'M' is interpreted wrongly", "Mar", f.format(new Date(2005, 2)));
		f = new DateFormatter("M");
		assertSame("pattern 'M' is interpreted wrongly", "Nov", f.format(new Date(2005, 10)));
		f = new DateFormatter("MM");
		assertSame("pattern 'MM' is interpreted wrongly", "May", f.format(new Date(2005, 4)));
		f = new DateFormatter("MM");
		assertSame("pattern 'MM' is interpreted wrongly", "Dec", f.format(new Date(2005, 11)));
		f = new DateFormatter("MMM");
		assertSame("pattern 'MMM' is interpreted wrongly", "Sep", f.format(new Date(2005, 8)));
		f = new DateFormatter("MMMM");
		assertSame("pattern 'MMMM' is interpreted wrongly", "October", f.format(new Date(2005, 9)));
		f = new DateFormatter("MMMMM");
		assertSame("pattern 'MMMMM' is interpreted wrongly", "December", f.format(new Date(2005, 11)));
		f = new DateFormatter("MMMMMMM");
		assertSame("pattern 'MMMMMMM' is interpreted wrongly", "November", f.format(new Date(2005, 10)));
	}
	
	public function testFormatDayAsNumber(Void):Void {
		var f:DateFormatter;
		f = new DateFormatter("d");
		assertSame("pattern 'd' is interpreted wrongly", "28", f.format(new Date(2005, 3, 28)));
		assertSame("pattern 'd' is interpreted wrongly", "5", f.format(new Date(2005, 3, 5)));
		f = new DateFormatter("dd");
		assertSame("pattern 'dd' is interpreted wrongly", "29", f.format(new Date(2005, 3, 29)));
		assertSame("pattern 'dd' is interpreted wrongly", "08", f.format(new Date(2005, 3, 8)));
		f = new DateFormatter("ddd");
		assertSame("pattern 'ddd' is interpreted wrongly", "030", f.format(new Date(2005, 3, 30)));
		assertSame("pattern 'ddd' is interpreted wrongly", "003", f.format(new Date(2005, 3, 3)));
		f = new DateFormatter("dddd");
		assertSame("pattern 'dddd' is interpreted wrongly", "0016", f.format(new Date(2005, 3, 16)));
		assertSame("pattern 'dddd' is interpreted wrongly", "0002", f.format(new Date(2005, 3, 2)));
		f = new DateFormatter("dddddd");
		assertSame("pattern 'dddddd' is interpreted wrongly", "000016", f.format(new Date(2005, 3, 16)));
		assertSame("pattern 'dddddd' is interpreted wrongly", "000002", f.format(new Date(2005, 3, 2)));
	}
	
	public function testFormatDayAsText(Void):Void {
		var f:DateFormatter;
		f = new DateFormatter("D");
		assertSame("pattern 'D' is interpreted wrongly", "Mo", f.format(new Date(2005, 2, 28)));
		assertSame("pattern 'D' is interpreted wrongly", "Sa", f.format(new Date(2005, 2, 5)));
		f = new DateFormatter("DD");
		assertSame("pattern 'DD' is interpreted wrongly", "Tu", f.format(new Date(2005, 2, 29)));
		assertSame("pattern 'DD' is interpreted wrongly", "Tu", f.format(new Date(2005, 2, 8)));
		f = new DateFormatter("DDD");
		assertSame("pattern 'DDD' is interpreted wrongly", "We", f.format(new Date(2005, 2, 30)));
		assertSame("pattern 'DDD' is interpreted wrongly", "Th", f.format(new Date(2005, 2, 3)));
		f = new DateFormatter("DDDD");
		assertSame("pattern 'DDDD' is interpreted wrongly", "Wednesday", f.format(new Date(2005, 2, 16)));
		assertSame("pattern 'DDDD' is interpreted wrongly", "Friday", f.format(new Date(2005, 2, 4)));
		f = new DateFormatter("DDDDDD");
		assertSame("pattern 'DDDDDD' is interpreted wrongly", "Sunday", f.format(new Date(2005, 2, 20)));
		assertSame("pattern 'DDDDDD' is interpreted wrongly", "Monday", f.format(new Date(2005, 2, 14)));
	}
	
}