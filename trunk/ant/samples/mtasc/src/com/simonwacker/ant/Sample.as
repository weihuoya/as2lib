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
 * {@code Sample} serves as a sample application to show the usage of the Mtasc Ant Task.
 * 
 * @author Simon Wacker
 */
class com.simonwacker.ant.Sample {
	
	private var textField:TextField;
	
	public function Sample(container:MovieClip) {
		container.createTextField("textField", 1, 0, 0, 300, 100);
		textField = container.textField;
	}
	
	public function showText(text:String):Void {
		textField.text = text;
	}
	
	public static function main(container:MovieClip):Void {
		var sample:Sample = new Sample(container);
		sample.showText("This SWF was created with the Mtasc Ant Task!");
	}
	
}