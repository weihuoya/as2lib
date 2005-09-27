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
 
import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.type.Byte;
import org.as2lib.data.type.MultilineString;

/**
 * {@code File} is a holder for text content with multiple lines of a external resource.
 * 
 * <p>Every {@code File} implementation has to provide the content of the real file.
 * 
 * @author Martin Heidegger
 * @version 2.0
 */
interface org.as2lib.io.file.File extends BasicInterface {
	
	/**
	 * Returns the complete content of the file.
	 * 
	 * @return content of the file, null if the content is not human-readable
	 */
	public function getContent(Void):String;
	
	/**
	 * Returns the location (URI) of the resource related to the content.
	 * 
	 * @return location of the resource related to the content
	 */
	public function getLocation(Void):String;
	
	/**
	 * Returns the size of the related resource in bytes.
	 * 
	 * @return size of the related resource in bytes
	 */
	public function getSize(Void):Byte;
}