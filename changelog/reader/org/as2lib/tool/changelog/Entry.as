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

/**
 * Model that stores entry data obtained from an XML data source.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.Entry {

	/** Type Flag for the status 'add' */
	public static var TYPE_ADD:Number = 1;
	
	/** Type Flag for the status 'change' */
	public static var TYPE_CHANGE:Number = 2;
	
	/** Type Flag for the status 'remove' */
	public static var TYPE_REMOVE:Number = 3;
	
	/** Type Flag for the status 'bugfix' */
	public static var TYPE_BUGFIX:Number = 4;
	
	/** Type Flag for the status 'documentation' */
	public static var TYPE_DOCUMENTATION:Number = 5;
	
	/** Type Flag for the status 'enhancement' */
	public static var TYPE_ENHANCEMENT:Number = 6;
	
	/** Type Flag for the status 'unknown' */
	public static var TYPE_UNKNOWN:Number = 7;
	
	/** Internal holder for the package */
	private var package:String;
	
	/** Internal holder for the package */
	private var clazz:String;
	
	/** Internal holder for the method */
	private var method:String;
	
	/** Internal holder for the type, containing one status flag */
	private var type:Number;
	
	/** Internal holder for the date */
	private var date:Date;
	
	/** Internal holder for the keywords */
	private var keywords:Array;
	
	/** Internal holder for the content */
	private var content:String;
	
	/**
	 * Constructs a new entry.
	 * 
	 * @param node XMLNode that is used basis for this entry.
	 */
	public function Entry(node:XMLNode) {
		var nodeName:String = String(node.attributes.type).toLowerCase()
		switch(nodeName) {
			case "add":
				type = TYPE_ADD;
				break;
			case "remove":
				type = TYPE_REMOVE;
				break;
			case "change":
				type = TYPE_CHANGE;
				break;
			case "bugfix":
				type = TYPE_BUGFIX;
				break;
			case "documentation":
				type = TYPE_DOCUMENTATION;
				break;
			case "enhancement":
				type = TYPE_ENHANCEMENT;
				break;
			default:
				type = TYPE_UNKNOWN;
		}
		keywords = node.attributes.keywords.split(';');
		package = node.attributes.package;
		clazz = node.attributes["class"];
		method = node.attributes.method;
		content = node.childNodes.toString();
		date = new Date(Number(node.parentNode.parentNode.parentNode.attributes.value), Number(node.parentNode.parentNode.attributes.value-1), Number(node.parentNode.attributes.value), 0, 0, 0, 0);
	}
	
	/** 
	 * Getter for the date of the entry.
	 *
	 * @return Date of the entry.
	 */
	public function getDate(Void):Date {
		return date;
	}
	
	/**
	 * Getter for the content of the entry.
	 *
	 * @param Content of the entry.
	 */
	public function getContent(Void):String {
		return content;
	}
	
	/**
	 * Getter for the type of the entry.
	 * Note: Type may be:
	 *       @see #TYPE_ADD
	 *       @see #TYPE_REMOVE
	 *       @see #TYPE_CHANGE
	 *       @see #TYPE_ENHANCEMENT
	 *       @see #TYPE_BUGFIX
	 *       @see #TYPE_DOCUMENTATION
	 *       @see #TYPE_UNKNOWN
	 *
	 * @return type of the entry.
	 */
	public function getType(Void):Number {
		return type;
	}
	
	/**
	 * Getter for the package of the entry.
	 * 
	 * @return Package attribute of the entry.
	 */
	public function getPackage(Void):String {
		return package;
	}
	
	/**
	 * Getter for the class of the entry.
	 * 
	 * @return Class attribute of the entry.
	 */
	public function getClass(Void):String {
		return clazz;
	}
	
	/**
	 * Getter for the method of the entry.
	 * 
	 * @return Method attribute of the entry.
	 */
	public function getMethod(Void):String {
		return method;
	}
	
	/**
	 * Returns a reference to the keywords. (not a clone!)
	 * The keywords of the xml node get split by ';'.
	 * 
	 * @return Keywords attribute of the entry split with ';'
	 */
	public function getKeywords(Void):Array {
		return keywords;
	}
	
	/**
	 * Extended .toString method.
	 *
	 * @return Entry as string.
	 */
	public function toString(Void):String {
		return this.date+"["+this.package+"] "+this.content;
	}
}