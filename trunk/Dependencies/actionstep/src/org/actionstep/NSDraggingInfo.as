/* See LICENSE for copyright and terms of use */

import org.actionstep.NSApplication;
import org.actionstep.NSArray;
import org.actionstep.NSDraggingSource;
import org.actionstep.NSImage;
import org.actionstep.NSObject;
import org.actionstep.NSPasteboard;
import org.actionstep.NSPoint;
import org.actionstep.NSSize;
import org.actionstep.NSView;
import org.actionstep.NSWindow;

/**
 * <p>Provides information about a dragging session.</p>
 * 
 * <p>In Cocoa, this is an interface, but one that you never have to implement. 
 * The strangeness of this leads me to believe that we can just use a class
 * instead, so no one has to worry about it.</p>
 * 
 * @see org.actionstep.NSDraggingSource
 * @see org.actionstep.NSDraggingDestination
 * @see org.actionstep.NSView#dragImageAtOffsetEventPasteboardSourceSlideBack
 * @author Scott Hyndman
 */
class org.actionstep.NSDraggingInfo extends NSObject 
{
	private static var g_sequenceCnt:Number = 0;
	private var m_src:NSDraggingSource;
	private var m_destWindow:NSWindow;
	private var m_pasteBrd:NSPasteboard;
	private var m_sequenceNo:Number;
	private var m_image:NSImage;
	private var m_imageLocation:NSPoint;
	private var m_slideBack:Boolean;
	
	//******************************************************															 
	//*                  Constructor
	//******************************************************
	
	/**
	 * Should never be directly invoked.
	 */
	private function NSDraggingInfo()
	{	
	}
	
	//******************************************************															 
	//*           Dragging-session information
	//******************************************************
	
	/**
	 * Returns the source of the dragged data.
	 */
	public function draggingSource():NSDraggingSource
	{
		return m_src;
	}
	
	/**
	 * Returns the dragging source operation mask created by bitwise or-ing
	 * constants as defined in {@link org.actionstep.constants.NSDragOperation}.
	 */
	public function draggingSourceOperationMask():Number
	{
		return m_src.draggingSourceOperationMask();
	}
	
	/**
	 * Returns the destination window for the drag operation. The destination
	 * can be the window itself, or a view contained within the window.
	 */	
	public function draggingDestinationWindow():NSWindow
	{
		return m_destWindow;
	}
	
	/**
	 * Returns the paste board that contains the data being dragged.
	 */
	public function draggingPasteboard():NSPasteboard
	{
		return m_pasteBrd;
	}
	
	/**
	 * Returns a number that uniquely identifies this dragging session.
	 */
	public function draggingSequenceNumber():Number
	{
		return m_sequenceNo;
	}
	
	/**
	 * Returns the current location of the mouse in the base coordinates of
	 * the destination object's window.
	 */
	public function draggingLocation():NSPoint
	{
		return m_destWindow.convertBaseToScreen(
			new NSPoint(_root._xmouse, _root._ymouse));
	}
	
	//******************************************************															 
	//*                Image information        
	//******************************************************
	
	/**
	 * Returns the image being dragged.
	 */
	public function draggedImage():NSImage
	{
		return m_image;
	}
	
	/**
	 * Returns the origin of the image being dragged in the destination 
	 * window's base coordinate system.
	 */
	public function draggedImageLocation():NSPoint
	{
		return m_imageLocation;
	}
	
	//******************************************************															 
	//*                Sliding the image          
	//******************************************************
	
	/**
	 * Returns true if the image should slide back to the source.
	 */
	public function slideBack():Boolean
	{
		return m_slideBack;
	}
	
	/**
	 * Slides the image to <code>aPoint</code> (screen coordinates).
	 */
	public function slideDraggedImageTo(aPoint:NSPoint):Void
	{
		//! TODO Implement this properly
		NSApplication.sharedApplication().draggingClip().clear();
	}
	
	//******************************************************															 
	//*                Helper Methods
	//*           (For internal use only)
	//******************************************************
	
	/**
	 * Returns <code>true</code> if <code>aView</code> is registered to handle
	 * the data contained in this dragging info's pasteboard.
	 */
	public function doesViewHandleTypes(aView:NSView):Boolean
	{
		var viewTypes:NSArray = aView.registeredDraggedTypes();
		var pbTypes:Array = m_pasteBrd.types().internalList();
		
		var len:Number = pbTypes.length;
		for (var i:Number = 0; i < len; i++)
		{
			if (!viewTypes.containsObject(pbTypes[i])) {
				return false;
			}
		}
				
		return true;
	}
	
	//******************************************************															 
	//*              Static Constructors
	//******************************************************
	
	public static function draggingInfoWithImageAtOffsetPasteboardSourceSlideBack(
		image:NSImage, imageLoc:NSPoint, offset:NSSize, pasteboard:NSPasteboard,
		source:NSDraggingSource, slideBack:Boolean):NSDraggingInfo
	{
		var info:NSDraggingInfo = new NSDraggingInfo();
		info.m_image = image;
		info.m_imageLocation = imageLoc;
		info.m_pasteBrd = pasteboard;
		info.m_src = source;
		info.m_slideBack = slideBack;
		info.m_sequenceNo = g_sequenceCnt++;
		 
		return info;
	}
}