package GUI.FishMeridian 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIMeridianInfo extends BaseGUI 
	{
		private var imgBackground:Image;
		
		public function GUIMeridianInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("");
			imgBackground = AddImage("", "GuiMeridianInfo", 0, 0, true, ALIGN_LEFT_TOP);
		}
		
		public function showGUI(x:Number, y:Number, element:int, rank:int, meridianPosition:int):void
		{
			Show();
			
			var txtFormat:TextFormat = new TextFormat("arial", 17, 0xffffff, true);
			txtFormat.align = "center";
			AddLabel("Huyệt số: " + meridianPosition + "\n-----------", 60, 5, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			txtFormat.size = 12;
			AddLabel("Đả thông mạch này sẽ nhận được:", 60, 42, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			
			//imgBackground.img.height = 90;
			
			var config:Object = ConfigJSON.getInstance().GetItemList("ActiveMeridian");
			config = config[element][rank][meridianPosition];
			var x0:int = 15;
			var y0:int = 65;
			var dx:int = 98;
			var dy:int = 25;
			var index:int = 0;
			imgBackground.img.height = 90;
			for (var s:String in config)
			{
					var txtLabel:TextField = AddLabel(Localization.getInstance().getString(s) + ":", x0, y0 + dy * index, 0xFFF100, 0, 0x000000);
					var tF:TextFormat = new TextFormat("arial", 11, 0xffffff, true);
					txtLabel.setTextFormat(tF);
					
					var txtValue:TextField = AddLabel("+" + Ultility.StandardNumber(config[s]), x0 + 50, 4 +y0 + dy * index, 0xFFF100, 0, 0x000000);
					tF = new TextFormat("arial", 14, 0xffff00, true);
					txtValue.setTextFormat(tF);
					
					txtLabel.x = x0 + Math.floor(index/2)*dx;
					txtLabel.y = y0 + 4 + dy * (index%2);
					txtValue.x = x0 + 60 + Math.floor(index/2)*dx;
					txtValue.y = y0 + dy * (index%2);
					
					index++;
			}
			
			if (index >= 2)
			{
				imgBackground.img.height += dy;
			}
			
			txtFormat.size = 12;
			txtFormat.color = 0xff0000;
			config = ConfigJSON.getInstance().GetItemList("MeridianPointRequire");
			config = config[rank][meridianPosition];
			var label:TextField = AddLabel("Cần:  " + Ultility.StandardNumber(int(config)) + " điểm ngư mạch", 60, imgBackground.img.height, 0xff0000, 1, 0x000000);// .setTextFormat(txtFormat);
			label.htmlText = "<font color = '#ffffff'>Cần: </font><font color = '#00ff00'>" + Ultility.StandardNumber(int(config)) + "</font><font color= '#ffffff'> điểm ngư mạch</font>"; 
			imgBackground.img.height += 30;
			
			SetPos(x + 30, y - img.height/2);
		}
		
	}

}