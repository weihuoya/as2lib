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
import org.as2lib.io.file.File;
import org.as2lib.data.type.Byte;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * {@code SimpleFile} represents the simplest way for accessing the file informations.
 * 
 * <p>Supports all necessary features for {@code File} without any other advantages.
 * 
 * @author Martin Heidegger
 * @version 2.0
 */
class org.as2lib.io.file.SimpleFile extends BasicClass implements File {
	
	/** Content of the file. */
	private var source:String;
	
	/** Location of the file. */
	private var uri:String;
	
	/** Size of the file in bytes. */
	private var size:Byte;
	
	/**
	 * Constructs a new {@code SimpleFile}.
	 * 
	 * @param source content of the {@code File} to create
	 * @param size size in {@link Byte} of the loaded resource
	 * @param uri location of the loaded resource
	 */
	public function SimpleFile(source:String, size:Byte, uri:String) {
		this.source = source;
		this.uri = uri;
		this.size = size;
	}
		
	/**
	 * Implementation of File.getLocation.
	 * 
	 * @return Recent loaded location.
	 * @see File#getLocation
	 */
	public function getLocation(Void):String {
		return uri;
	}
	
	/**
	 * Returns the content of the file
	 * 
	 * @return content of the file
	 * @see File#getContent
	 */
	public function getContent(Void):String {
		return source;
	}
	
	/**
	 * Returns the size of the file in bytes.
	 * 
	 * @return size of the file in bytes
	 */
	public function getSize(Void):Byte {
		return size;
	}
	
	/**
	 * Extended Stringifier
	 * 
	 * Example:
	 *  [type org.as2lib.io.file.SimpleFile | Location: MyFile.txt; Size: 12KB; ]
	 * 
	 * @return the file as string
	 */
	public function toString():String {
		var result:String;
		result = "[type " + ReflectUtil.getTypeNameForInstance(this)
				 + " | Location: " + getLocation()
				 + "; Size: " + getSize().toString(false, 2)
				 + "; ]";
		return result;
	}
}