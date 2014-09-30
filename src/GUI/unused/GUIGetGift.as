package GUI.unused 
{
	import Data.INI;
	import flash.text.TextField;
	import Logic.GameLogic;
	import flash.events.IMEEvent;
	import flash.events.MouseEvent;
	import NetworkPacket.PacketSend.SendRemoveMessage;
	import NetworkPacket.PacketSend.SendAcceptGift;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import Data.Localization;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/** 
	 * ...
	 * @author Hien
	 * Nhan mon qua ma ban gui cho minh
	 */
	public class GUIGetGift extends BaseGUI
	{
		private const GUI_GIFT_BUTTON_CLOSE:String = "BtnThoat";
		private const GUI_GIFT_BUTTON_RECEIVE: String = "btnnhan";
		public var GiftRemoveId: String;
		public var type: String;
		public var Numb: int;
		
		public function GUIGetGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGetGift";
		}
		public override function InitGUI(): void
		{
			//load background
			LoadRes("ImgFrameFriend");
			var img: Image = AddImage("", "GUI_Bgr", 220,180);			
			img.SetSize(340, 300);
			
			var txt1: TextField = AddLabel("", 245, 90);			
			var formatter1:TextFormat = new TextFormat( );					
			formatter1.size = 16;				
			formatter1.font = "Arial";
			formatter1.color = 0x0047AB;
			txt1.defaultTextFormat = formatter1;		
			txt1.text = Localization.getInstance().getString("GUILabel27");
			//AddImage("", "MoQuaText", 300, 100);
			var imgHopQua: Image = AddImage("", "HopQua", 260, 127);
			imgHopQua.SetScaleX(0.7);
			imgHopQua.SetScaleY(0.7);            
		
			
			SetPos(150, 80);				
			
			//Hien thi mon qua duoc gui cho minh, id dai
			GiftRemoveId = GuiMgr.getInstance().GuiReceiveGift.GiftOpen;
			
			var i: int = 0;	
			var GiftId: String;
			var imgName: String;
			var obj: Object;
			//var type: String;
			for (i = 0; i < GameLogic.getInstance().user.GiftArr.length; i++)
			{				
				if (GameLogic.getInstance().user.GiftArr[i].Id == GiftRemoveId)
				{
					GiftId = GameLogic.getInstance().user.GiftArr[i].GiftId;	
					imgName = getImage(GiftId);
					obj = INI.getInstance().getGiftInfo(GiftId);
					var obj1: Object = INI.getInstance().getItemInfo(obj["typeid"], obj["type"]);
					var type: String = obj["type"];
					
					var imgGift: Image = AddImage("", imgName, 250, 250, true, ALIGN_LEFT_TOP);					
					imgGift.SetScaleX(1.2);
					imgGift.SetScaleY(1.2);
					if (type == "Food")
					{
						Numb = obj1["Numb"];
						//AddImage("", "BGSoLuong", 267, 260, true, ALIGN_LEFT_TOP);
						var txtFormat: TextFormat = new TextFormat("Arial", 11, 0xffffff);
						txtFormat.align = TextFormatAlign.CENTER;
						var tg:int = Numb / 5;
						var lbl: TextField = AddLabel(tg.toString(),232, 260, 0xffffff, 1, 0x26709C);
						lbl.setTextFormat(txtFormat);
					}
					break;
				}
			}	
			
			//add text thong bao
			var txt: TextField = AddLabel("", 210, 160,1);
			var formatter:TextFormat = new TextFormat( );					
			formatter.size = 16;				
			formatter.font = "Arial";				
			txt.defaultTextFormat = formatter;					
			txt.text = Localization.getInstance().getString("GUILabel9");
			
			
			//add button
			var btn: Button = AddButton(GUI_GIFT_BUTTON_CLOSE, "BtnThoat", 390, 85, this);	
			//btn.img.scaleX = 0.65;
			//btn.img.scaleY = 0.65;
			//AddButton(GUI_GIFT_BUTTON_RECEIVE, "ButtonNhan", 265, 360, this);	
			var btnSend: Button = AddButton(GUI_GIFT_BUTTON_RECEIVE, "BtnGreen", 213, 358, this);
			btnSend.img.width = 100;
			btnSend.img.height = 38;
			var tf:TextField = AddLabel("Nhận", 240, 325, 0x000000, 0);
			tf.scaleX = tf.scaleY = 1.3;
			
			OpenRoomOut();
		}
		
		//lay anh cua ItemInfo dua vao id trong .xml
		public function getImage(Id: String): String
		{
			var imgName: String;
			var obj: Object = INI.getInstance().getGiftInfo(Id);		
			var obj1: Object = INI.getInstance().getItemInfo(obj["typeid"], obj["type"]);
			type = obj["type"];
			switch (type)
			{
				case "Other":
					var type1: String = obj["type"];
					var typeid1: String = obj["typeid"];
					imgName = type1 + typeid1;		
				break;		
				case "MixLake":
					imgName = obj["type"] + obj["typeid"];
				break;
				
				case "OceanTree":
					imgName = obj["type"] + obj["typeid"];					
					break;
					
				case "OceanAnimal":
					imgName = obj["type"] + obj["typeid"];			
					break;
				
				case "Fish":					
					imgName = "Fish" + obj["typeid"] + "_Old_Idle";									
					break;
					
				case "Food":				
					imgName = "ImgFoodBox";	
					break;
			}
			return imgName;
			
		}
		
		public function AcceptGift(): void
		{
			var sendLetter: SendAcceptGift = new SendAcceptGift(GiftRemoveId.toString());
			Exchange.GetInstance().Send(sendLetter);	
			var i: int;
			var obj:Object = null;
			for (i = 0; i < GameLogic.getInstance().user.GiftArr.length; i++)
			{
				if (GameLogic.getInstance().user.GiftArr[i].Id == GiftRemoveId)
				{							
					obj = INI.getInstance().getGiftInfo(GameLogic.getInstance().user.GiftArr[i].GiftId);	
					GameLogic.getInstance().user.GiftArr.splice(i,1);
					break;
				}
			}
			//kiem tra neu la food
			if (type == "Food")
			{
				GameLogic.getInstance().user.UpdateFoodCount(Numb);
			}                                     
			else
			{
				if (obj != null)
				{
					GuiMgr.getInstance().GuiStore.UpdateStore(obj["type"], obj["typeid"], 1);
				}
			}     
			GuiMgr.getInstance().GuiReceiveGift.RefreshComponent();
			Hide();
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch(buttonID)
			{
				case GUI_GIFT_BUTTON_CLOSE:
					
				
				//break;
				case GUI_GIFT_BUTTON_RECEIVE:					
					AcceptGift();
				break;
			}
		}		
	}

}