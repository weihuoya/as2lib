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

import org.as2lib.tool.changelog.Entry;

/**
 * Marker MovieClip for a Entry.
 * This Marker will be used to sign the line for the List.
 * It takes an entry:Entry as initParameter for the entry it should take.
 * It automatically detects the 
 *
 * Note: This class is part of the StandardView.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.EntryMarker extends MovieClip {
	
	// Holder for the Entry that applies to the MovieClip (passed by initParameter of attachMovie)
	private var entry:Entry;
	
	// MovieClip holder for the background.
	private var background:MovieClip;
	
	// MovieClip holder for the character sign.
	private var sign:TextField;
	
	/**
	 * Constructs a new EntryMarker.
	 */
	public function EntryMarker() {
		this.createEmptyMovieClip('background', 1);
		background.beginFill(getColor(), 100);
		background.moveTo(0, 0);
		background.lineTo(12, 0);
		background.lineTo(12, 5);
		background.lineTo(0, 5);
		background.endFill();
		
		this.createTextField('sign', 2, 0, 0, 0, 0);
		sign.autoSize = "left";
		sign.selectable = false;
		sign.text = getSign();
		
		var tF:TextFormat = new TextFormat();
		tF.color = 0xFFFFFF;
		tF.font = "Courier";
		sign.setTextFormat(tF);
	}
	
	/**
	 * Setter for the height of the marker.
	 *
	 * @param height Height of the Marker.
	 */
	public function setHeight(height:Number):Void {
		background._height = height;
	}
	
	/**
	 * Getter for the Sign Character of the Entry.
	 * Available Characters are:
	 *   + ... add
	 *   - ... remove
	 *   * ... enhancement
	 *   ! ... bugfix
	 *   ~ ... change
	 *   ? ... documentation
	 * 
	 * @see #entry
	 * @return Type of the passed entry as String.
	 */
	private function getSign(Void):String {
		var type:Number = entry.getType();
		var result:String;
		switch(type) {
			case Entry.TYPE_ADD:
				result = "+";
				break;
			case Entry.TYPE_REMOVE:
				result = "-";
				break;
			case Entry.TYPE_CHANGE:
				result = "~";
				break;
			case Entry.TYPE_BUGFIX:
				result = "!";
				break;
			case Entry.TYPE_DOCUMENTATION:
				result = "?";
				break;
			case Entry.TYPE_ENHANCEMENT:
				result = "*";
				break;
			default:
				result = "";
		}
		return result;
	}
	
	/**
	 * Getter for the color matching to the entry's type.
	 *
	 * @see #entry.
	 * @return Color of the Entry.
	 */
	private function getColor(Void):Number {
		var type:Number = entry.getType();
		var result:Number;
		switch(type) {
			case Entry.TYPE_ADD:
				result = 0x27CC01;
				break;
			case Entry.TYPE_REMOVE:
				result = 0xE78800;
				break;
			case Entry.TYPE_CHANGE:
				result = 0x0065CD;
				break;
			case Entry.TYPE_BUGFIX:
				result = 0xE72B00;
				break;
			case Entry.TYPE_DOCUMENTATION:
				result = 0x747474;
				break;
			case Entry.TYPE_ENHANCEMENT:
				result = 0x98D11E;
				break;
			default:
				result = 0x666666;
		}
		return result;
	}
}