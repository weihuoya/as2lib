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
import org.as2lib.tool.changelog.ChangelogView;
import org.as2lib.tool.changelog.node.EntryNode;

/**
 * Simple @see ChangelogView implementation for Debug reasons.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.TraceView extends BasicClass implements ChangelogView {
	
	/**
	 * Update implementation of @see ChangelogView#update.
	 *
	 * @param list List that contains all entries to be displayed.
	 */
	public function update(list:Array):Void {
		for(var i=0; i<list.length; i++) {
			traceEntry(list[i]);
		}
	}
	
	private function traceEntry(entry:EntryNode):Void {
		var package:String = entry.getPackage();
		var clazz:String = entry.getClass();
		var method:String = entry.getMethod();
		var variable:String = entry.getVariable();
		var throws:String = entry.getThrows();
		var somethingWrittenBeforeDate = false;
		var content:String = "["+entry.getSign()+"] ";
		if(package) {
			content += package;
			somethingWrittenBeforeDate = true;
		}
		if(clazz) {
			if(package) {
				content += ".";
			}
			content += entry.getClass();
			somethingWrittenBeforeDate = true;
		}
		if(method) {
			if(clazz || package) {
				content += ".";
			}
			content += method;
			somethingWrittenBeforeDate = true;
		} else if (variable) {
			if(clazz || package) {
				content += ".";
			}
			content += variable;
			somethingWrittenBeforeDate = true;
		}
		if(throws) {
			content += " throws "+throws;
		}
		var date:Date = entry.getDate();
		if(somethingWrittenBeforeDate) {
			content += " ";
		}
		content += "("+date.getDate()+"/"+date.getMonth()+"/"+date.getFullYear()+")";
		if(entry.getContent().length > 0) {
			content += "\n"+entry.contentToString();
		}
		content += "\n";
		trace(content);
	}
}