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
import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.tool.changelog.Parser;
import org.as2lib.tool.changelog.EntryFilter;
import org.as2lib.tool.changelog.ChangelogView;
import org.as2lib.tool.changelog.ParserListener;
import org.as2lib.tool.changelog.XMLParseErrorInfo;
import org.as2lib.tool.changelog.Config;
import org.as2lib.env.event.EventBroadcaster;

/**
 * Main class for the Changelog reader.
 * Use this class to display a changlog. It reads and handles
 * all informations to a changelog.
 *
 * - You can start display a changelog by @see #display.
 * - You can add multiple filters to filter the changelog by @see #addFilter.
 * - You can add multiple views to display the changelog by @see #addView.
 *
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.Main extends BasicClass implements ParserListener {
	
	/** Internal holder for the parser */
	private var parser:Parser;
	
	/** Internal holder to the eventbroadcaster to broadcast events */
	private var eB:EventBroadcaster;
	
	/** List of all views added to the changelog. */
	private var views:Array = new Array();
	
	/** List of all filters for the listentries of the changelog */
	private var filters:Array = new Array();
	
	/**
	 * Constructs a new changelog reader main class.
	 */
	public function Main(Void) {}
	
	/**
	 * Takes a file URI and displayes it.
	 * Loads and parses a file 
	 */
	public function display(file:String):Void {
		parser = new Parser();
		parser.addListener(this);
		parser.load(file);
	}
	
	/**
	 * Updates all views with the current content.
	 */
	public function update(Void):Void {
		var list:Array = getFilteredEntries();
		for(var i:Number = views.length-1; i>=0; i--) {
			ChangelogView(views[i]).update(list.concat());
		}
	}
	
	/** 
	 * Implementation of ParserListener#onLoad
	 * 
	 * @info 
	 */
	public function onLoad(Void):Void {
		update();
	}
	
	/**
	 * Implementation of ParserListener#onFileNotFound
	 *
	 * @info Eventinfo to file not found.
	 */
	public function onFileNotFound(Void):Void {
		Config.getOut().warning("File Not found! "+parser.getURL());
	}
	
	
	/**
	 * Implementation of ParserListener#onXMLParseError
	 *
	 * @info Eventinfo to the XMLParseError.
	 */
	public function onXMLParseError(info:XMLParseErrorInfo):Void {
		Config.getOut().warning("XML Parse Error: "+info.getErrorMessage());
	}
	
	/**
	 * Adds a view to the List of views.
	 *
	 * @param view View that should be added.
	 */
	public function addView(view:ChangelogView):Void {
		views.push(view);
	}
	
	/**
	 * Adds a filter to the List of filters.
	 *
	 * @param filter Filter that should be added.
	 */
	public function addFilter(filter:EntryFilter):Void {
		filters.push(filter);
	}
	
	/** 
	 * Applies all added filter (@see #addFilter) to the changelog result.
	 *
	 * @return Filtered Array.
	 */
	private function getFilteredEntries(Void):Array {
		var result:Array = parser.getEntries();
		for(var i:Number=filters.length-1; i>=0; i--) {
			result = EntryFilter(filters[i]).filter(result);
		}
		return result;
	}
}