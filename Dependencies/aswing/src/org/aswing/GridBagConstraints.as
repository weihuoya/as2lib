import org.aswing.Insets;
/**
 * The <code>GridBagConstraints</code> class specifies constraints 
 * for components that are laid out using the 
 * <code>GridBagLayout</code> class.
 * 
 * @author Tomato
 */
class org.aswing.GridBagConstraints {
	
	/**
     * Specifies that this component is the next-to-last component in its 
     * column or row (<code>gridwidth</code>, <code>gridheight</code>), 
     * or that this component be placed next to the previously added 
     * component (<code>gridx</code>, <code>gridy</code>). 
     * @see      org.aswing.GridBagConstraints#gridwidth
     * @see      org.aswing.GridBagConstraints#gridheight
     * @see      org.aswing.GridBagConstraints#gridx
     * @see      org.aswing.GridBagConstraints#gridy
     */

	public static var RELATIVE : Number = -2;	//-1;

   /**
     * Specifies that this component is the 
     * last component in its column or row. 
     */

	public static var REMAINDER : Number = -1;	//0;
  
   /**
     * Do not resize the component. 
     */

	public static var NONE : Number = 0;

   /**
     * Resize the component both horizontally and vertically. 
     */

	public static var BOTH : Number = 1;

   /**
     * Resize the component horizontally but not vertically. 
     */

	public static var HORIZONTAL : Number = 2;

   /**
     * Resize the component vertically but not horizontally. 
     */

	public static var VERTICAL : Number = 3;

   /**
    * Put the component in the center of its display area.
    */

	public static var CENTER : Number = 10;

   /**
     * Put the component at the top of its display area,
     * centered horizontally. 
     */

	public static var NORTH : Number = 11;

    /**
     * Put the component at the top-right corner of its display area. 
     */

	public static var NORTHEAST : Number = 12;

    /**
     * Put the component on the right side of its display area, 
     * centered vertically.
     */

	public static var EAST : Number = 13;

    /**
     * Put the component at the bottom-right corner of its display area. 
     */

	public static var SOUTHEAST : Number = 14;

    /**
     * Put the component at the bottom of its display area, centered 
     * horizontally. 
     */

	public static var SOUTH : Number = 15;

   /**
     * Put the component at the bottom-left corner of its display area. 
     */

	public static var SOUTHWEST : Number = 16;

    /**
     * Put the component on the left side of its display area, 
     * centered vertically.
     */

	public static var WEST : Number = 17;

   /**
     * Put the component at the top-left corner of its display area. 
     */

	public static var NORTHWEST : Number = 18;
  
//  ------------------------------------------------------------------------------------
  

	/**
     * Specifies the cell containing the leading edge of the component's 
     * display area, where the first cell in a row has <code>gridx=0</code>. 
     * The leading edge of a component's display area is its left edge for
     * a horizontal, left-to-right container and its right edge for a
     * horizontal, right-to-left container.
     * The value 
     * <code>RELATIVE</code> specifies that the component be placed 
     * immediately following the component that was added to the container 
     * just before this component was added. 
     * <p>
     * The default value is <code>RELATIVE</code>. 
     * <code>gridx</code> should be a non-negative value.
     * 
     * @see org.aswing.GridBagConstraints#gridy
     * 
     */

	public var gridx : Number;

   /**
     * Specifies the cell at the top of the component's display area, 
     * where the topmost cell has <code>gridy=0</code>. The value 
     * <code>RELATIVE</code> specifies that the component be placed just 
     * below the component that was added to the container just before 
     * this component was added. 
     * <p>
     * The default value is <code>RELATIVE</code>.
     * <code>gridy</code> should be a non-negative value.
     * 
     * @see org.aswing.GridBagConstraints#gridx
     * 
     */

	public var gridy : Number;

   /**
     * Specifies the number of cells in a row for the component's 
     * display area. 
     * <p>
     * Use <code>REMAINDER</code> to specify that the component be the 
     * last one in its row. Use <code>RELATIVE</code> to specify that the 
     * component be the next-to-last one in its row. 
     * <p>
     * <code>gridwidth</code> should be non-negative and the default
     * value is 1.
     * 
     * @see org.aswing.GridBagConstraints#gridheight
     * 
     */

	public var gridwidth : Number;

   /**
     * Specifies the number of cells in a column for the component's 
     * display area. 
     * <p>
     * Use <code>REMAINDER</code> to specify that the component be the 
     * last one in its column. Use <code>RELATIVE</code> to specify that 
     * the component be the next-to-last one in its column. 
     * <p>
     * <code>gridheight</code> should be a non-negative value and the
     * default value is 1.
     * 
     * @see org.aswing.GridBagConstraints#gridwidth
     * 
     */

	public var gridheight : Number;

   /**
     * Specifies how to distribute extra horizontal space. 
     * <p>
     * The grid bag layout manager calculates the weight of a column to 
     * be the maximum <code>weightx</code> of all the components in a 
     * column. If the resulting layout is smaller horizontally than the area 
     * it needs to fill, the extra space is distributed to each column in 
     * proportion to its weight. A column that has a weight of zero receives 
     * no extra space. 
     * <p>
     * If all the weights are zero, all the extra space appears between 
     * the grids of the cell and the left and right edges. 
     * <p>
     * The default value of this field is <code>0</code>.
     * <code>weightx</code> should be a non-negative value.
	 *
     * @see org.aswing.GridBagConstraints#weighty
     * 
     */

	public var weightx : Number;

   /**
     * Specifies how to distribute extra vertical space. 
     * <p>
     * The grid bag layout manager calculates the weight of a row to be 
     * the maximum <code>weighty</code> of all the components in a row. 
     * If the resulting layout is smaller vertically than the area it 
     * needs to fill, the extra space is distributed to each row in 
     * proportion to its weight. A row that has a weight of zero receives no 
     * extra space. 
     * <p>
     * If all the weights are zero, all the extra space appears between 
     * the grids of the cell and the top and bottom edges. 
     * <p>
     * The default value of this field is <code>0</code>. 
     * <code>weighty</code> should be a non-negative value.
     * 
     * @see org.aswing.GridBagConstraints#weightx
     * 
     */

	public var weighty : Number;

   /** 
    * This field is used when the component is smaller than its display
     * area. It determines where, within the display area, to place the
     * component. 
     * The default value is <code>CENTER</code>. 
     * 
     * @see org.aswing.ComponentOrientation
     * 
     */

	public var anchor : Number;

   /**
     * This field is used when the component's display area is larger 
     * than the component's requested size. It determines whether to 
     * resize the component, and if so, how. 
     * <p>
     * The following values are valid for <code>fill</code>: 
     * <p>
     * <ul>
     * <li>
     * <code>NONE</code>: Do not resize the component. 
     * <li>
     * <code>HORIZONTAL</code>: Make the component wide enough to fill 
     *         its display area horizontally, but do not change its height. 
     * <li>
     * <code>VERTICAL</code>: Make the component tall enough to fill its 
     *         display area vertically, but do not change its width. 
     * <li>
     * <code>BOTH</code>: Make the component fill its display area 
     *         entirely. 
     * </ul>
     * <p>
     * The default value is <code>NONE</code>. 
     */

	public var fill : Number;
  
  /**
     * This field specifies the external padding of the component, the 
     * minimum amount of space between the component and the edges of its 
     * display area. 
     * <p>
     * The default value is <code>new Insets(0, 0, 0, 0)</code>. 
     */

	public var insets : Insets;

   /**
     * This field specifies the internal padding of the component, how much 
     * space to add to the minimum width of the component. The width of 
     * the component is at least its minimum width plus 
     * <code>(ipadx&nbsp;*&nbsp;2)</code> pixels. 
     * <p>
     * The default value is <code>0</code>. 
     * 
     * @see org.aswing.GridBagConstraints#ipady
     * 
     */

	public var ipadx : Number;

   /**
     * This field specifies the internal padding, that is, how much 
     * space to add to the minimum height of the component. The height of 
     * the component is at least its minimum height plus 
     * <code>(ipady&nbsp;*&nbsp;2)</code> pixels. 
     * <p>
     * The default value is 0. 
     * 
     * @see org.aswing.GridBagConstraints#ipadx
     * 
     */

	public var ipady : Number;
  
  
//  -------------------------------------------------------------------------------------------
  

   /**
     * Temporary place holder for the x coordinate.
     */
//  var tempX:Number;
   /**
     * Temporary place holder for the y coordinate.
     */
//  var tempY:Number;
   /**
     * Temporary place holder for the Width of the component.
     */
//  var tempWidth:Number;
   /**
     * Temporary place holder for the Height of the component.
     */
//  var tempHeight:Number;
   /**
     * The minimum width of the component.  It is used to calculate
     * <code>ipady</code>, where the default will be 0.
     * 
     * @see #ipady
     * 
     */
//  var minWidth:Number;
   /**
     * The minimum height of the component. It is used to calculate
     * <code>ipadx</code>, where the default will be 0.
     * 
     * @see #ipadx
     * 
     */
//  var minHeight:Number;

//  -------------------------------------------------------------------------------------------------

 	/**
     * Creates a <code>GridBagConstraint</code> object with 
     * all of its fields set to their default value. 
     */

	public function GridBagConstraints() {
		gridx = RELATIVE;
		gridy = RELATIVE;
		gridwidth = 1;
		gridheight = 1;

		weightx = 0;
		weighty = 0;
		anchor = CENTER;
		fill = NONE;

		insets = new Insets(0, 0, 0, 0);
		ipadx = 0;
		ipady = 0;
	}
	
	public function clone():GridBagConstraints{
		var gbc:GridBagConstraints = new GridBagConstraints();
		
		gbc.gridx 		= gridx;
		gbc.gridy 		= gridy;
		gbc.gridwidth 	= gridwidth;
		gbc.gridheight	= gridheight;
		gbc.weightx		= weightx;
		gbc.weighty		= weighty;
		gbc.anchor		= anchor;
		gbc.fill		= fill;
		gbc.ipadx		= ipadx;
		gbc.ipady		= ipady;
		
		gbc.insets 		= new Insets(insets.top, insets.left, insets.bottom, insets.right);
		
		return gbc;
	}
	
}