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

/**
 * Contentwrapper for a change-rename tag.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.node.ChangeRenameNode extends BasicClass {
	
	/** Source content */
	private var from:String;
	
	/** Target content */
	private var to:String;
	
	/** Annotation (comment) to the change */
	private var annotation:String;
	
	/**
	 * Creates a new ChangeRenameNode.
	 *
	 * @param node XMLNode that represents the xmlnode.
	 */
	public function ChangeRenameNode(node:XMLNode) {
		from = node.attributes.from;
		to = node.attributes.to;
		annotation = node.nodeValue;
	}
	
	/**
	 * Extended .toString method.
	 *
	 * @return Entry as string.
	 */
	public function toString(Void):String {
		var result:String;
		result = "Renamed ";
		if(from) {
			result += from+" ";
		}
		result += " to "+to;
		if(annotation.length > 0) {
			result += "("+annotation+")";
		}
		result += ".";
		return result;
	}
}