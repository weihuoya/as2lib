﻿/*
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

/**
 * Interface for a view for the Changelog parser.
 * Add a implementation of this view to @see org.as2lib.tool.changelog.Config#addView.
 * and it will be loaded by the @see org.as2lib.tool.changelog.Main.
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.tool.changelog.ChangelogView extends BasicInterface {
	
	/**
	 * Updates the view with content.
	 *
	 * @list List of entries that should be displayed.
	 */
	public function update(list:Array):Void;
}