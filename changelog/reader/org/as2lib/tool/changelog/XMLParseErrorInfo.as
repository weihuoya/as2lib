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
import org.as2lib.env.event.EventInfo;

/**
 * EventInfo to be dispatched if an XMLParseError occurs within @see org.as2lib.tool.changelog.Parser.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.XMLParseErrorInfo extends BasicClass implements EventInfo  {
	
	/** Internal Holder of the level */
	private var level:Number;
	
	/**
	 * Constructs a new XMLParseError info.
	 * 
	 * @param level Level of the Error.
	 */
	public function XMLParseErrorInfo (level:Number) {
		this.level = level;
	}
	
	/**
	 * Implementation of @see EventInfo#getName
	 * 
	 * @return Name of the event that has been fired.
	 */
	public function getName(Void):String {
		return "onXMLParseError";
	}
	
	/**
	 * Getter for the XML error level.
	 * 
	 * @return Original error level.
	 */
	public function getLevel(Void):Number {
		return level;
	}
	
	/**
	 * Getter for a enhanced version of the error level as string.
	 *
	 * @return Error level as string.
	 */
	public function getErrorMessage (Void):String {
		switch(level) {
			case -2:
				return "A CDATA area was not proper closed.";
			case -3:
				return "A XML declaration was not proper closed.";
			case -4:
				return "A DOCTYPE declaration was not proper closed.";
			case -5:
				return "A comment was not proper closed.";
			case -6:
				return "Illegal XML Node found.";
			case -7:
				return "Out of memory."
			case -8:
				return "A attribute was not proper closed.";
		    case -9:
				return "Missing Endtag."
			case -10:
				return "Endtag without matching Starttag.";
			default:
				return "<unknown>"
		}
	}
}