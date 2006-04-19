/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.Box;
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.JAccordion;
import org.aswing.JAttachPane;
import org.aswing.JButton;
import org.aswing.JCheckBox;
import org.aswing.JComboBox;
import org.aswing.JFrame;
import org.aswing.JLabel;
import org.aswing.JList;
import org.aswing.JLoadPane;
import org.aswing.JPanel;
import org.aswing.JProgressBar;
import org.aswing.JRadioButton;
import org.aswing.JScrollBar;
import org.aswing.JScrollPane;
import org.aswing.JSeparator;
import org.aswing.JTabbedPane;
import org.aswing.JTextArea;
import org.aswing.JTextField;
import org.aswing.JToggleButton;
import org.aswing.JToolBar;
import org.aswing.JViewport;
import org.aswing.JWindow;
import org.aswing.SoftBox;
import org.aswing.util.HashMap;

/**
 * Privides public API allowed to access components created using AWML.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.AwmlManager {
	
	/** Storage for components created using AWML. */
	private static var awmlComponents:HashMap;
	
	
	/**
	 * Initializes AWML component's storage. 
	 */
	private static function init():Void {
		if (awmlComponents == null) awmlComponents = new HashMap();	
	}
	
	/**
	 * Register AWML component in the AWML component's storage. AWML parser automatically
	 * registers all AWML components in so you'd never use this method manually.
	 * 
	 * @param component the AWML component to register
	 */
	public static function addComponent(component:Component):Void {
		init();
		awmlComponents.put(component.getAwmlID(), component);
	} 

	/**
	 * Returns AWML {@link org.aswing.Component} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.Component} to get
	 * @return the AWML {@link org.aswing.Component}
	 */
	public static function getComponent(awmlID:String):Component {
		init();
		return Component(awmlComponents.get(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.Container} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.Container} to get
	 * @return the AWML {@link org.aswing.Container}
	 */
	public static function getContainer(awmlID:String):Container {
		return Container(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JFrame} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JFrame} to get
	 * @return the AWML {@link org.aswing.JFrame}
	 */
	public static function getFrame(awmlID:String):JFrame {
		return JFrame(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JWindow} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JWindow} to get
	 * @return the AWML {@link org.aswing.JWindow}
	 */
	public static function getWindow(awmlID:String):JWindow {
		return JWindow(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JTextField} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JTextField} to get
	 * @return the AWML {@link org.aswing.JTextField}
	 */
	public static function getTextField(awmlID:String):JTextField {
		return JTextField(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JTextArea} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JTextArea} to get
	 * @return the AWML {@link org.aswing.JTextArea}
	 */
	public static function getTextArea(awmlID:String):JTextArea {
		return JTextArea(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JSeparator} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JSeparator} to get
	 * @return the AWML {@link org.aswing.JSeparator}
	 */
	public static function getSeparator(awmlID:String):JSeparator {
		return JSeparator(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JProgressBar} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JProgressBar} to get
	 * @return the AWML {@link org.aswing.JProgressBar}
	 */
	public static function getProgressBar(awmlID:String):JProgressBar {
		return JProgressBar(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JLabel} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JLabel} to get
	 * @return the AWML {@link org.aswing.JLabel}
	 */
	public static function getLabel(awmlID:String):JLabel {
		return JLabel(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JButton} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JButton} to get
	 * @return the AWML {@link org.aswing.JButton}
	 */
	public static function getButton(awmlID:String):JButton {
		return JButton(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JToggleButton} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JToggleButton} to get
	 * @return the AWML {@link org.aswing.JToggleButton}
	 */
	public static function getToggletButton(awmlID:String):JToggleButton {
		return JToggleButton(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JCheckBox} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JCheckBox} to get
	 * @return the AWML {@link org.aswing.JCheckBox}
	 */
	public static function getCheckBox(awmlID:String):JCheckBox {
		return JCheckBox(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JRadioButton} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JRadioButton} to get
	 * @return the AWML {@link org.aswing.JRadioButton}
	 */
	public static function getRadioButton(awmlID:String):JRadioButton {
		return JRadioButton(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JPanel} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JPanel} to get
	 * @return the AWML {@link org.aswing.JPanel}
	 */
	public static function getPanel(awmlID:String):JPanel {
		return JPanel(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.Box} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.Box} to get
	 * @return the AWML {@link org.aswing.Box}
	 */
	public static function getBox(awmlID:String):Box {
		return Box(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.SoftBox} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.SoftBox} to get
	 * @return the AWML {@link org.aswing.SoftBox}
	 */
	public static function getSoftBox(awmlID:String):SoftBox {
		return SoftBox(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JToolBar} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JToolBar} to get
	 * @return the AWML {@link org.aswing.JToolBar}
	 */
	public static function getToolBar(awmlID:String):JToolBar {
		return JToolBar(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JScrollBar} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JScrollBar} to get
	 * @return the AWML {@link org.aswing.JScrollBar}
	 */
	public static function getScrollBar(awmlID:String):JScrollBar {
		return JScrollBar(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JList} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JList} to get
	 * @return the AWML {@link org.aswing.JList}
	 */
	public static function getList(awmlID:String):JList {
		return JList(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JComboBox} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JComboBox} to get
	 * @return the AWML {@link org.aswing.JComboBox}
	 */
	public static function getComboBox(awmlID:String):JComboBox {
		return JComboBox(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JAccordion} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JAccordion} to get
	 * @return the AWML {@link org.aswing.JAccordion}
	 */
	public static function getAccordion(awmlID:String):JAccordion {
		return JAccordion(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JTabbedPane} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JTabbedPane} to get
	 * @return the AWML {@link org.aswing.JTabbedPane}
	 */
	public static function getTabbedPane(awmlID:String):JTabbedPane {
		return JTabbedPane(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JLoadPane} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JLoadPane} to get
	 * @return the AWML {@link org.aswing.JLoadPane}
	 */
	public static function getLoadPane(awmlID:String):JLoadPane {
		return JLoadPane(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JAttachPane} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JAttachPane} to get
	 * @return the AWML {@link org.aswing.JAttachPane}
	 */
	public static function getAttachPane(awmlID:String):JAttachPane {
		return JAttachPane(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JScrollPane} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JScrollPane} to get
	 * @return the AWML {@link org.aswing.JScrollPane}
	 */
	public static function getScrollPane(awmlID:String):JScrollPane {
		return JScrollPane(getComponent(awmlID));
	}

	/**
	 * Returns AWML {@link org.aswing.JViewport} instance by <code>awmlID</code>.
	 * 
	 * @param awmlID the AWML ID of the {@link org.aswing.JViewport} to get
	 * @return the AWML {@link org.aswing.JViewport}
	 */
	public static function getViewport(awmlID:String):JViewport {
		return JViewport(getComponent(awmlID));
	}

	private function AwmlManager() {
		//	
	}
}