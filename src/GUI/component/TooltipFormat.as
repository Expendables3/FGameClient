package GUI.component 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class TooltipFormat extends TextField 
	{		
		public function TooltipFormat() 
		{
			var txtFormat:TextFormat = new TextFormat("Arial");
			txtFormat.align = "center";
			defaultTextFormat = txtFormat;
			mouseEnabled = false;
			//wordWrap = true;
			width = 200;
			autoSize = TextFieldAutoSize.CENTER;
		}

		
	}

}