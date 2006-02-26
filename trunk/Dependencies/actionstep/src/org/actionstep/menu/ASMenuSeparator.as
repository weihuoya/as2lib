﻿/* See LICENSE for copyright and terms of use */

import org.actionstep.NSMenuItem;

/**
 * An <code>NSMenuItem</code> subclass representing a separator.
 * 
 * Used by <code>org.actionstep.NSMenu</code> and its related classes.
 * 
 * @author Tay Ray Chuan.
 */
class org.actionstep.menu.ASMenuSeparator extends NSMenuItem {
	public function init():NSMenuItem {
	  super.initWithTitleActionKeyEquivalent("-----------", null, "");
	  m_enabled = false;
	  m_changesState = false;
	  return this;
	}
	
	public function isSeparatorItem():Boolean {
	  return true;
	}
}