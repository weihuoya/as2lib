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
 
import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.env.event.EventListener;
import org.as2lib.tool.changelog.XMLParseErrorInfo;

/**
 * Listener Interface for @see org.as2lib.tool.changelog.Parser.
 * You can add a implementation of this interface to a @see org.as2lib.tool.changelog.Parser instance
 * as listener.
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.tool.changelog.ParserListener extends EventListener {
	
	/**
	 * Event to be dispatched if the parser finished loading the xml file.
	 */
	public function onLoad(Void):Void;
	
	/** 
	 * Event to be dispatched if the parser threw an error by parsing the xml file.
	 *
	 * @param info Info to the error that occured by parsing the xml file.
	 */
	public function onXMLParseError(info:XMLParseErrorInfo):Void;
	
	/** 
	 * Event to be dispatched if the requested file wasn't found.
	 */
	public function onFileNotFound(Void):Void;
}