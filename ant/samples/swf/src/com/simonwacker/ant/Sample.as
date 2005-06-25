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
 * {@code Sample} serves as a sample application to show the usage of the Swf Ant Task.
 * 
 * @author Simon Wacker
 */
class com.simonwacker.ant.Sample {
	
	private var container:MovieClip;
	private var picture:MovieClip;
	
	public function Sample(container:MovieClip) {
		this.container = container;
	}
	
	public function showPicture(Void):Void {
		this.picture = container.attachMovie("simonwacker", "simonwacker", 1);
		this.picture._x = (Stage.width - this.picture._width)/2;
		this.picture._y = 10;
	}
	
	public function showUnderline(Void):Void {
		var y:Number = this.picture._y + this.picture._height + 4;
		this.container.createTextField("underline", 2, 0, y, Stage.width, 24);
		var underline:TextField = this.container.underline;
		underline.embedFont = true;
		underline.text = "Picture of Simon Wacker (simonwacker.com)";
		underline.setTextFormat(getTextFormat());
	}
	
	private function getTextFormat(Void):TextFormat {
		var result:TextFormat = new TextFormat();
		result.font = "pixel";
		result.align = "center";
		return result;
	}
	
	public static function main(container:MovieClip):Void {
		var sample:Sample = new Sample(container);
		sample.showPicture();
		sample.showUnderline();
	}
	
}