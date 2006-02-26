/* See LICENSE for copyright and terms of use */

import org.actionstep.NSImageRep;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.NSView;

import flash.display.BitmapData;

/**
 * Represents an image defined by a rectangle of a {@link BitmapData} instance.
 *
 * @author Scott Hyndman
 */
class org.actionstep.ASBitmapImageRep extends NSImageRep
{
	private var m_image:BitmapData;

	/**
	 * Creates a new instance of <code>ASBitmapImageRep</code>.
	 */
	public function ASBitmapImageRep() {
	}

	/**
	 * Initializes the image rep with an image composed of the area of
	 * <code>source</code> as defined by <code>rect</code>.
	 */
	public function initWithSourceRect(source:BitmapData, rect:NSRect)
			:ASBitmapImageRep {
		setImageWithSourceRect(source, rect);
		return this;
	}

	/**
	 * Initializes the image rep with an image composed of the contents of
	 * <code>source</code>.
	 */
	public function initWithMovieClip(source:MovieClip):ASBitmapImageRep {
		m_image = new BitmapData(source._width, source._height, true, null);
		m_image.draw(source);
		m_size = new NSSize(source._width, source._height);

		return this;
	}

	/**
	 * Releases this <code>ASBitmapImageRep</code> from memory.
	 */
	public function release():Void {
		m_image.dispose();
		m_image = null;
	}

	//******************************************************
	//*                    Properties
	//******************************************************

	/**
	 * @see org.actionstep.NSObject#description
	 */
	public function description():String {
		return "ASBitmapImageRep(size=" + m_size + ")";
	}

	/**
	 * Extracts the image from the <code>source</code> bitmap data, as defined
	 * by the rectangle <code>rect</code>.
	 */
	public function setImageWithSourceRect(source:BitmapData, rect:NSRect):Void {
		if (null == source) {
			return;
		}

		if (null == rect) {
			rect = new NSRect(0, 0, source.width, source.height);
		}

		m_image = source.clone();
		m_size = rect.size;
	}

	//******************************************************
	//*                 Public Methods
	//******************************************************

	/**
	 * Draws the image.
	 */
	public function draw():Void {
		var clip:MovieClip;
		var depth:Number;
		var flipped:Boolean = false;

		//
		// Determine depth
		//
		depth = m_drawClip.getNextHighestDepth();
		if (m_drawClip.view != undefined) {
			var obj:Object = m_drawClip.__unusedDepths;
			if (obj != null && obj.length > 0) {
				var i:String;
				for (i in obj) {
					depth = parseInt(i);
					break;
				}

				delete obj[i];
				obj.length--;
			} else {
				depth = NSView(m_drawClip.view).getNextDepth();
			}
		}

		//
		// If we're flipped, calculate the proper draw rect.
		//
		if (m_size.height < 0) {
		  flipped = true;
		  m_drawPoint.y += m_size.height;
		  m_size.height *= -1;
		}

		//
		// Create the holder clip.
		//
		clip = m_drawClip.createEmptyMovieClip("__bdclip__" + depth, depth);
		clip.view = m_drawClip.view;

		//
		// Draw the image
		//
		clip.attachBitmap(m_image, 0, "auto", true);
		clip._x = m_drawPoint.x;
		clip._y = m_drawPoint.y;
		clip._width = m_size.width;
		clip._height = m_size.height;

		//
		// Flip the image if necessary.
		//
		if (flipped) {
		  clip._yscale *= -1;
		  clip._y += clip._height;
		}

		super.addImageRepToDrawClip(clip);
    }
}
