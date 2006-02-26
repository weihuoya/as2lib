/* See LICENSE for copyright and terms of use */

import org.actionstep.NSImageRep;
import org.actionstep.NSSize;
import org.actionstep.ASDraw;

/**
 * Draws the icon for an <code>org.actionstep.NSAlert</code>.
 */
class org.actionstep.images.ASAlertIconRep extends NSImageRep {
  
  /**
   * Creates a new instance of the <code>ASAlertIconRep</code> class.
   */
  public function ASAlertIconRep() {
  	//as specified by Aqua guidelines
    m_size = new NSSize(64,64);
  }

  /**
   * Returns a string representation of the image rep.
   */
  public function description():String {
    return "ASAlertIconRep(size=" + size() + ")";
  }
  
  /**
   * Draws the image rep.
   */
  public function draw() {
  	
  	//! FIXME Add a better image here.
  	
  	//
  	// Drawn at (0,0) to force use of mc:(_x, _y)
  	//
    ASDraw.drawRect(m_drawClip, 0, 0, 
      m_drawRect.size.width, m_drawRect.size.height, 0xC7CAD1, 100, .25);
  }
}