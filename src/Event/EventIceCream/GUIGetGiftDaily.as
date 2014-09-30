package Event.EventIceCream 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIGetGiftDaily extends BaseGUI 
	{
		public var arrGift:Array = [];
		public const BTN_GET_GIFT:String = "BtnGetGift";
		public const CTN_GIFT:String = "CtnGift";
		public function GUIGetGiftDaily(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGetGiftDaily";
		}
		
		override public function InitGUI():void 
		{
			//super.InitGUI();
			InitBaseData();
			this.setImgInfo = function ():void 
			{
				SetPos(210, 80);
				OpenRoomOut();
			}
			LoadRes("EventIceCream_ImgBgGuiGetGiftDaily");
		}
		
		override public function EndingRoomOut():void 
		{
			//super.EndingRoomOut();
			var i:int = 0;
			for (i = 0; i < arrGift.length; i++) 
			{
				var item:Object = arrGift[i];
				DrawGift(item, i);
			}
			AddButton(BTN_GET_GIFT, "EventIceCream_BtnGetGift", 140, 240);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_GET_GIFT:
					GuiMgr.getInstance().GuiMainEventIceCream.CreateHelp();
					if(!GuiMgr.getInstance().GuiMainEventIceCream.IsVisible)
					{
						GuiMgr.getInstance().GuiMainEventIceCream.Show(Constant.GUI_MIN_LAYER, 3);
					}
					Hide();
				break;
			}
		}
		
		public function DrawGift(obj:Object, index:int):void 
		{
			var startX:int = 68, startY:int = 136;
			var deltaX:int = 90, deltaY:int = 0;
			var dx:int, dy:int;
			dx = deltaX * index;
			dy = deltaY * index;
			var ctn:Container = AddContainer(CTN_GIFT, "GUIGetGiftDaily_ImgFrameFriend", startX + dx, startY + dy, true, this);
			var imgBg:Image = ctn.AddImage("", "EventIceCream_ImgBgSlotGift", 0, 0,true, ALIGN_LEFT_TOP);
			var imgContent:Image = ctn.AddImage("", obj.Type + obj.Id, 0, 0, true , ALIGN_LEFT_TOP);
			imgContent.FitRect(50, 50, new Point(imgBg.CurPos.x + 5, imgBg.CurPos.y + 4));
			(imgContent.img as MovieClip).gotoAndStop(0);
			var ttg:TooltipFormat = new TooltipFormat();
			ttg.text = GetStrTooltip(obj);
			ctn.setTooltip(ttg);
			var txtFormat:TextFormat = new TextFormat("Arial", 20, 0x601020);
			txtFormat.bold = true;
			txtFormat.color = 0xFFFF00;
			txtFormat.size = 20;
			AddLabel("x" + obj.Num, startX + dx - 20, startY + dy + 70, 0xFFFF00, 1, 0x26709C).setTextFormat(txtFormat);
		}
		
		private function GetStrTooltip(obj:Object):String 
		{
			var str:String = "";
			switch (obj.Id) 
			{
				case 1:
					str = Localization.getInstance().getString("Tooltip90");
				break;
				case 2:
					str = Localization.getInstance().getString("Tooltip91");
				break;
				case 4:
					str = Localization.getInstance().getString("Tooltip93");
				break;
			}
			return str;
		}
		
		public function InitBaseData():void 
		{
			arrGift.splice(0, arrGift.length);
			var objConfigParams:Object = ConfigJSON.getInstance().GetItemList("Param");
			//var objConfigGiftDayly
			var objNumItem:Object = GuiMgr.getInstance().GuiMainEventIceCream.arrNumItem;
			var obj:Object = new Object();
			obj.Type = "EventIceCream_Item";
			obj.Id = 4;
			obj.Num	= 10;
			arrGift.push(obj);
			//if (objNumItem[String(obj.Id)] != null)
			//{
				//objNumItem[String(obj.Id)] += obj.Num;
			//}
			//else	
			//{
				//objNumItem[String(obj.Id)] = obj.Num;
			//}
			
			obj = new Object();
			obj.Type = "EventIceCream_Item";
			obj.Id = 1;
			obj.Num	= 1;
			arrGift.push(obj);
			//if (objNumItem[String(obj.Id)] != null)
			//{
				//objNumItem[String(obj.Id)] += obj.Num;
			//}
			//else	
			//{
				//objNumItem[String(obj.Id)] = obj.Num;
			//}
			
			obj = new Object();
			obj.Type = "EventIceCream_Item";
			obj.Id = 2;
			obj.Num	= 1;
			arrGift.push(obj);
			//if (objNumItem[String(obj.Id)] != null)
			//{
				//objNumItem[String(obj.Id)] += obj.Num;
			//}
			//else	
			//{
				//objNumItem[String(obj.Id)] = obj.Num;
			//}
		}
	}

}