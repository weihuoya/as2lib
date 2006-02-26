
import org.aswing.BorderLayout;
import org.aswing.Container;
import org.aswing.FlowLayout;
import org.aswing.JButton;
import org.aswing.JFrame;
import org.aswing.JPanel;
import org.aswing.JScrollPane;
import org.aswing.JTextArea;
import org.aswing.JTextComponent;
import org.aswing.JTextField;
import org.aswing.JToggleButton;
import org.aswing.MCPanel;
/**
 *
 * @author Tomato
 */
class test.TextTest extends JFrame {
	
	private var button:JToggleButton;
	private var jtextfield:JTextField;
	private var jtextarea:JTextArea;
	private var jscrollpane:JScrollPane;
	
	public function TextTest() {
		super("Text Test");
		
		this.button = new JToggleButton("Change Text Content");
		this.jtextfield = new JTextField(null, 10);
		//this.jtextfield.setBorder(new LineBorder(null,null,1));
		this.jtextfield.setText("I'm a TextField");
		
		this.jtextarea = new JTextArea();
		//this.jtextarea.setWordWrap(true);
		//this.jtextarea.setEditable(false);
		//this.jtextarea.setHtml(true);
		this.jtextarea.setText("<h1>A H1 Title</h1><font color='#FF0000'>A Red Color------------------------</font>");
		var panel:JPanel=new JPanel();
		panel.setLayout(new FlowLayout(FlowLayout.CENTER));
		panel.append(jtextfield);
//		this.jtextarea.setPreferredSize(1000,1000);
		//this.jtextarea.setBorder(new LineBorder(null,null,5));		
		
		var pane:Container = getContentPane();
		pane.append(this.button, BorderLayout.SOUTH);
		pane.append(panel , BorderLayout.NORTH);
		//pane.append(this.jtextarea, BorderLayout.CENTER);
		pane.append(this.jtextfield , BorderLayout.NORTH);
		pane.append(this.getScrollPane() , BorderLayout.CENTER);
		this.getScrollPane().setView(this.jtextarea);
		//pane.append(this.jtextarea, BorderLayout.CENTER);
		
		this.button.addActionListener(__buttonAction, this);
		this.jtextfield.addEventListener(JTextComponent.ON_TEXT_CHANGED , __textChanged , this);
	}
	
	private function __textChanged():Void{
		this.jtextarea.setText(this.jtextfield.getText());
	}
	
	private function __buttonAction():Void{
		jtextarea.setText("");
	}
	
	public function getScrollPane():JScrollPane{
		if(this.jscrollpane == null){
			this.jscrollpane = new JScrollPane();
		}
		return this.jscrollpane;
	}
	
	private static var holdBtton:JButton;
	private static var instance:TextTest;
	public static function main():Void{
		try{
			trace("try LabelTest");
			var p:TextTest = new TextTest();
			instance = p;
			p.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
			p.setLocation(50, 50);
			p.setSize(400, 400);
			p.show();
			
			holdBtton = new JButton("open");
			var mcP:MCPanel = new MCPanel(_root, 300, 300);
			mcP.setLayout(new FlowLayout());
			mcP.append(holdBtton);
			holdBtton.addActionListener(function(){
				p.show();
			});
			
			trace("done LabelTest");
		}catch(e){
			trace("error : " + e);
		}
	}
}