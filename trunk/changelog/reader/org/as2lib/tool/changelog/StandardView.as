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
import org.as2lib.tool.changelog.node.EntryNode;
import org.as2lib.tool.changelog.EntryMarker;
import org.as2lib.tool.changelog.ChangelogView;

/**
 * Standard View to display the Changelog.
 * This is a standard view for the a Changelog.
 * This can be added to the Config.
 *
 * @see org.as2lib.tool.changelog.Config
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.StandardView extends BasicClass implements ChangelogView {
	
	/** Holder for the content MovieClip of the output. */
	private var mc:MovieClip;
	
	/** Root mc for the whole view. */
	private var rootMc:MovieClip;
	
	/** ScrollPane MovieClip holder. */
	private var scrollPane:MovieClip;
	
	/** Flag if the view has been inited. */
	private var inited:Boolean;
	
 	/** Count of the Entries added to the view. */
	private var count:Number;
	
	/** Title Bar holder. */
	private var title:MovieClip;
	
	/** List of the text fields added to mc. */
	private var tFList:Array;
	
	/** List of the markers added to mc. */
	private var markerList:Array;
	
	/** Textformat for all Instances */
	private var textFormat:TextFormat;
	
	/**
	 * Constructs a new standard view for a Changelog reader.
	 *
	 * @param rootMc MovieClip that should be used as root Movieclip for the view.
	 */
	public function StandardView(rootMc:MovieClip) {
		this.rootMc = rootMc;
		count = 0;
		inited = false;
		tFList = new Array();
		markerList = new Array();
		
		textFormat = new TextFormat();
		textFormat.color = 0x666666;
		textFormat.font = "Verdana";
		textFormat.size = 10;
	}
	
	/**
	 * Update implementation of @see org.as2lib.tool.changelog.ChangelogView.
	 *
	 * @param list List with all Entries to display.
	 */
	public function update(list:Array):Void {
		init();
		for(var i=0; i<list.length; i++){
			addListElement(list[i]);
		}
		onResize();
	}
	
	/**
	 * Inits the instance (if it hasn't been already inited).
	 *
	 * @see #inited
	 */
	private function init(Void):Void {
		if(!inited) {
			inited = true;
			
			// Titlebar added to the view (from Library!)
			var title:MovieClip = rootMc.attachMovie('titleBar', 'titleBar', 1);
			
			// ScrollPane added to the view (from Library!)
			scrollPane = rootMc.attachMovie('ScrollPane', 'scroll', 2, {visible: true, enabled:true, vScrollPolicy:'auto', contentPath:'content'});
			scrollPane._y = title._height;
			
			// Take the scrollPane content as mc.
			mc = scrollPane.content;
			
			// Adds the View to as Stage listener.
			Stage.addListener(this);
			
			// Modify the Stage
			Stage.align = "TL";
			Stage.scaleMode = "noscale";
		}
	}
	
	/**
	 * Handler to resize all entries if the Stage is resized.
	 * @see #init adds this listener to the Stage.
	 */
	public function onResize(Void):Void {
		
		// Resizing the scrollPane.
		scrollPane.setSize(Stage.width, Stage.height-rootMc.titleBar._height, false);
		
		// Holder for the lastHeight
		var lastHeight:Number = 0;
		
		// Iteration over all registered entries.
		for(var i:Number=0; i<tFList.length; i++) {
			
			var tF:TextField = tFList[i];
			tF._y = lastHeight;
			tF._width = Stage.width-40;
			
			var marker:EntryMarker = markerList[i];
			marker._y = tF._y;
			marker.setHeight(tF._height);
			
			lastHeight = tF._y+tF._height+1;
		}
	}
	
	/** 
	 * Adds a entry to the view list.
	 *
	 * @param entry Entry to add to the markerList.
	 */
	private function addListElement(entry:EntryNode):Void {
		markerList.push(mc.attachMovie('Marker', 'marker'+count, count, {entry:entry}));
		
		mc.createTextField('text'+count, (count+1), 13, 0, 10, 10);
		
		// Adds a new Textfield to the view (correctly configured)
		var tF:TextField = mc['text'+count];
		tF.autoSize = "left";
		tF.wordWrap = true;
		tF.html = true;
		tF.multiline = true;
		tF.selectable = false;
		tF.embedFonts = false;
		
		// <start> Content Generation for one entry
		var content:String = "<b>";
	    var package:String = entry.getPackage();
	    var clazz:String = entry.getClass();
	    var method:String = entry.getMethod();
		var variable:String = entry.getVariable();
		if(package) {
			content += package;
		}
		if(clazz) {
			if(package) {
				content += ".";
			}
			content += entry.getClass();
		}
		if(method) {
			if(clazz || package) {
				content += ".";
			}
			content += method();
		} else if (variable) {
			if(clazz || package) {
				content += ".";
			}
			content += variable();
		}
		var date:Date = entry.getDate();
		content += "</b> ("+date.getDate()+"/"+date.getMonth()+"/"+date.getFullYear()+")<br />"+entry.toHTML();
		// <end> Content generation.
		
		tF.htmlText = content;
		tF.setTextFormat(textFormat);
		tFList.push(tF);
		
		count += 2;
	}
}