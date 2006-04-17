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
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.AbstractView extends BasicClass {
	
	private var movieClip:MovieClip;
	private var x:Number;
	private var y:Number;
	private var width:Number;
	private var height:Number;
	
	private function AbstractView(Void) {
		setPosition(0, 0);
		setSize(0, 0);
	}
	
	public function draw(movieClip:MovieClip):Void {
		this.movieClip = movieClip;
		movieClip._x = getX();
		movieClip._y = getY();
	}
	
	public function getMovieClip(Void):MovieClip {
		return movieClip;
	}
	
	public function setPosition(x:Number, y:Number):Void {
		setX(x);
		setY(y);
	}
	
	public function getX(Void):Number {
		return x;
	}
	
	public function setX(x:Number):Void {
		if (y != null) {
			this.x = x;
		}
	}
	
	public function getY(Void):Number {
		return y;
	}
	
	public function setY(y:Number):Void {
		if (y != null) {
			this.y = y;
		}
	}
	
	public function setSize(width:Number, height:Number):Void {
		setWidth(width);
		setHeight(height);
	}
	
	public function getWidth(Void):Number {
		return width;
	}
	
	public function setWidth(width:Number):Void {
		if (width != null) {
			this.width = width;
		}
	}
	
	public function getHeight(Void):Number {
		return height;
	}
	
	public function setHeight(height:Number):Void {
		if (height != null) {
			this.height = height;
		}
	}
	
}