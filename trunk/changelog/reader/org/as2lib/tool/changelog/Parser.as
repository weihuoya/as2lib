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
 
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.Map;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SimpleEventInfo;
import org.as2lib.env.event.SpeedEventBroadcaster;
import org.as2lib.tool.changelog.Config;
import org.as2lib.tool.changelog.node.EntryNode;
import org.as2lib.tool.changelog.ParserListener;
import org.as2lib.tool.changelog.XMLParseErrorInfo;

/**
 * Parses the Changelog and works as Service for all Datas.
 * 
 * @author Martin Heidegger
 * @event onLoad
 * @event onXMLParseError
 * @event onFileNotFound
 */
class org.as2lib.tool.changelog.Parser extends XML{
	
	/** Url that the Parser should take */
	private var url:String;
	
	/** Map that contains all found Entries */
	private var entryMap:Map;
	
	/** Holder for the EventBroadcaster */
	private var eb:EventBroadcaster;
	
	/** Flag if the XML is already parsed */
	private var parsed:Boolean = false;
	
	/**
	 * Constructs a new Parser for a Changelog file.
	 *
	 * @param url File that should be loaded.
	 */
	public function Parser() {
		this.ignoreWhite = true;
		this.eb = new SpeedEventBroadcaster();
		entryMap = new HashMap();
	}
	
	/**
	 * Loads a changelog xml file to parse.
	 * You can handle the onLoad Action to check if it finished.
	 * 
	 * @param url URL that should be loaded.
	 */
	public function load(url:String):Void {
		this.url = url;
		this.parsed = false;
		super.load(url);
	}
	
	/**
	 * Adds a listener to this instance for all events.
	 *
	 * @param l Listener that should be added.
	 */
	public function addListener(l:ParserListener):Void {
		getEventBroadcaster().addListener(l);
	}
	
	
	/**
	 * Removes a listener to this instance for all events.
	 *
	 * @param l Listener that should be removed.
	 */
	public function removeListener(l:ParserListener):Void {
		getEventBroadcaster().removeListener(l);
	}
	
	/**
	 * Method to fetch the onload action of the XML class.
	 * Template Implementation to XML.onLoad.
	 * 
	 * @param success true if the File was successfully loaded.
	 */
	private function onLoad(success:Boolean):Void {
		if(success) {
			if(status == 0) {
				getEventBroadcaster().dispatch(new SimpleEventInfo("onLoad"));
			} else {
				getEventBroadcaster().dispatch(new XMLParseErrorInfo(status));
			}
		} else {
			getEventBroadcaster().dispatch(new SimpleEventInfo("onFileNotFound"));
		}
	}
	
	/**
	 * Internal getter for the EventBroadcaster (use this instead of the private var if
     * you extend this class.
	 * 
	 * @return EventBroadcaster Related to this class.
	 */
	private function getEventBroadcaster(Void):EventBroadcaster {
		return this.eb;
	}
	
	/**
	 * Getter for the entries contained in the XML file.
	 *
	 * @return Array that contains @see EntryNode instances.
	 */
	public function getEntries():Array {
		getEntriesInNode(this.firstChild.firstChild);
		return entryMap.getValues();
	}
	
	/** 
	 * Internal recursive search method for entries.
	 *
	 * @param node XMLNode that should be checked if it contains a entry child.
	 */
	private function getEntriesInNode(node:XMLNode):Void {
		for(var i:Number=0; i<node.childNodes.length; i++) {
			if(node.childNodes[i].nodeName == "entry") {
				entryMap.put(node.childNodes[i], new EntryNode(node.childNodes[i]));
			} else {
				getEntriesInNode(node.childNodes[i]);
			}
		}
	}
	
	/**
	 * Getter for the url that has be parsed.
	 *
	 * @return Url that has been parsed.
	 */
	public function getURL(Void):String {
		return url;
	}
}
