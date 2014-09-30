package Data 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	[Embed(source = '../../content/loading.swf', symbol = 'LoadingScreen')]
	
	/**
	 * ...
	 * @author ...
	 */
	public class LoadingScreenWorld extends MovieClip 
	{
		private var txt:TextField = new TextField();
		public var loadingBarWorld:LoadingBarWorld = new LoadingBarWorld();
		private var textField:TextField = new TextField();
		
		public function LoadingScreenWorld() 
		{
			//this.x = 70;
			//this.y = 15;
			this.x = 0;
			this.y = 0;
			this.addChild(loadingBarWorld);
			
			this.addChild(txt);
			txt.text = "0%";
			txt.x = 575;
			txt.y = 520;
			var txtFormat:TextFormat = new TextFormat("Arial", 24, 0, true);
			txtFormat.align = "center";
			txt.setTextFormat(txtFormat);
			txt.defaultTextFormat = txtFormat;
			
			//Tip hu?ng d?n
			textField.text = "";
			textField.autoSize = TextFieldAutoSize.CENTER;
			txtFormat = new TextFormat("arial", 18, 0x604220, true);
			txtFormat.align = "center";
			textField.wordWrap = true;
			textField.width = 500;
			textField.setTextFormat(txtFormat);
			textField.defaultTextFormat = txtFormat;
			textField.x = 160;
			textField.y = 550;
			this.addChild(textField);
		}
		
		public function randomTip():void
		{
			var numTip:int = int(Tips.getInstance().getTip("NumTips"));
			textField.text =  Tips.getInstance().getTip("Tip" + (1 + Math.floor(Math.random() * numTip)));
		}
		
		public function SetPercent(percent:int):void
		{
			loadingBarWorld.SetPercent(percent);
			 //update text
			txt.text = percent + "%";
		}
		
	}

}