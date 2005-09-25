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
import org.as2lib.io.file.File;
import org.as2lib.data.type.Byte;
import org.as2lib.data.type.MultilineString;

/**
 * {@code FileFactory} is a integration layer for {@link org.as2lib.util.FileLoader}.
 * 
 * <p>{@code FileLoader} applies the loaded resource to {@code FileFactory} 
 * property. The implementations of {@code FileLoader} can variy the result of 
 * the loaded file.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.FileFactory extends BasicInterface {
	
	/**
	 * Creates a new {@code File} instance for the loaded resource.
	 * 
	 * @param source content of the {@code File} to create
	 * @param size size in {@link Byte} of the loaded resource
	 * @param uri location of the loaded resource
	 * @return {@code File} that represents the resource
	 */
	public function createFile(source:MultilineString, size:Byte, uri:String):File;
}