package GUI.FishWar 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.GUIMixFormulaInfo;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendExchangeStar;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIChooseSolider extends BaseGUI 
	{
		private var listGift:ListBox;
		private var elements:Number;
		private var fishTypeId:int;
		private var formulaType:String;
		private var _chose:Boolean;
		private var _giftId:int;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_GET_GIFT:String = "btnGetGift";
		static public const CTN_SOLIDER:String = "ctnSolider";
		
		static public const GIFT_1:int = 1;
		static public const GIFT_2:int = 2;
		static public const GIFT_3:int = 3;
		static public const GIFT_4:int = 4;
		
		private var cfg:Object;
		
		public function GUIChooseSolider(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				//AddButton(BTN_GET_GIFT, "GuiChooseSoldier_Btn_Get_Solider", 307- 92, 375+ 31);
				AddButton(BTN_GET_GIFT, "GuiChooseSoldier_Btn_Get_Solider", 307- 92, 375 - 101);
				AddButton(BTN_CLOSE, "BtnThoat", 655 - 130, 22 + 26, this);	
				SetPos(50 + 85, 60);
				
				// Lấy config sao
				cfg = ConfigJSON.getInstance().GetSoldierEventConfig("ChangeStar")[giftId];		
				
				// Add sao
				//AddStars(cfg.StarNum);
				
				listGift = AddListBox(ListBox.LIST_X, 1, 5);
				//listGift.setPos(400 - 320, 50 + 254);
				listGift.setPos(77, 160);
				
				var config:Object = ConfigJSON.getInstance().getItemInfo("MixFormula", -1);
				
				if (!cfg.bonus.FormulaType)
				{
					config = config[cfg.bonus.ItemType];
				}
				else
				{
					config = config[cfg.bonus.FormulaType];
				}
				
				for (var s:String in config)
				{
					if (s != "Id" && s != "Name" && s != "type")
					{
						var itemSolider:Container = new Container(listGift.img, "GuiChooseSoldier_Solider_Bg", 0, 0);
						var image:Image;
						var tooltip:TooltipFormat = new TooltipFormat();
						switch (giftId)
						{
							case GIFT_1:
							case GIFT_2:
							case GIFT_3:
								image = itemSolider.AddImage("", config.Id + "_" + s, 0, 0);
								tooltip.text = Localization.getInstance().getString(config.Id) + " hệ " + Localization.getInstance().getString("Element" + config[s].Elements);
								formulaType = config.Id;
								break;
							case GIFT_4:
								image = itemSolider.AddImage("", "Fish" +  config[s]["FishTypeId"] + "_Old_Idle", 0, 0);
								tooltip.text = GuiMgr.getInstance().GuiMixFormulaInfo.ArrRank[config[s]["Rank"]-1] + " hệ " + GUIMixFormulaInfo.getElementsName(config[s]["Elements"]);
								break;
						}
						
						image.FitRect(65, 65, new Point(0, 0));
						image.img.mouseChildren = false;
						image.img.mouseEnabled = false;
						itemSolider.img.buttonMode = true;
						itemSolider.setTooltip(tooltip);
						listGift.addItem(CTN_SOLIDER + "_" + config[s]["Elements"] + "_" + config[s]["FishTypeId"], itemSolider, this);
					}
				}
				chose = false;
			}
			LoadRes("GuiChooseSoldier_Theme");
		}
		
		private function feedEvent():void
		{
			// Feed
			GuiMgr.getInstance().GuiFeedWall.ShowFeed("EventFishWar@2");
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (buttonID.search(CTN_SOLIDER) >= 0)
			{
				var ctn:Container = listGift.getItemById(buttonID);
				ctn.img.scaleX = 1;
				ctn.img.scaleY = 1;
				//GlowingItem(ctn.img as MovieClip, false, false);
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if (buttonID.search(CTN_SOLIDER) >= 0)
			{
				var ctn:Container = listGift.getItemById(buttonID);
				ctn.img.scaleX = 1.05;
				ctn.img.scaleY = 1.05;
				//GlowingItem(ctn.img as MovieClip, false, true);
			}
		}
		
		private function GlowingItem(mv:MovieClip, picked:Boolean, highlight:Boolean = false):void
		{
			var glow:GlowFilter = new GlowFilter();
			glow.blurX = 15;
			glow.blurY = 15;
			if (picked)
			{
				glow.color = 0xFFCC00;
			}
			else
			{
				glow.color = 0x32FFCC;				
			}
			if (highlight)
			{
				glow.alpha = 1;
				glow.blurX = 25;
				glow.blurY = 25;
			}
			else
			{
				glow.alpha = 0.5;
				glow.blurX = 15;
				glow.blurY = 15;
			}
			mv.filters = [glow];
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_GET_GIFT:
					Hide();
					
					// Gửi gói tin
					var cmd:SendExchangeStar = new SendExchangeStar();
					cmd.Element = elements;
					cmd.GiftId = int(giftId);
					Exchange.GetInstance().Send(cmd);
					GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"]["LuckyStar"] -= cfg.StarNum;
					
					var imgName:String;
					switch (giftId)
					{
						case GIFT_1:
						case GIFT_2:
						case GIFT_3:
							var config:Object = ConfigJSON.getInstance().getItemInfo("MixFormula", -1);
							imgName = formulaType + "_" + elements;
							EffectMgr.setEffBounceDown("Nhận thành công", imgName, 335, 300);
							
							GuiMgr.getInstance().GuiStore.UpdateStore(formulaType, elements, 1);
							break;
						case GIFT_4:
							imgName = "Fish" + fishTypeId + "_Old_Idle";
							EffectMgr.setEffBounceDown("Nhận thành công", imgName, 335, 300, feedEvent);
							
							GameLogic.getInstance().user.GenerateNextID();
							if (GuiMgr.getInstance().GuiStore.IsVisible)
							{
								GuiMgr.getInstance().GuiStore.Hide();
							}
							break;
					}
					
					
					break;
				default:
					if (buttonID.search(CTN_SOLIDER) >= 0)
					{
						for each(var item:Container in listGift.itemList)
						{
							if (item.IdObject == buttonID)
							{
								item.SetHighLight(0xff0000);
								var arr:Array = item.IdObject.split("_");
								elements = int(arr[1]);
								fishTypeId = int(arr[2]);
								chose = true;
							}
							else
							{
								item.SetHighLight( -1);
							}
						}
					}
			}
		}
		
		public function AddStars(num:int):void
		{
			var x0:int = 120;
			var y0:int = 192;
			var dx:int = 55;
			var dy:int = 0;
			var tt:TooltipFormat;
			
			var i:int;
			for (i = 0; i < num; i++)
			{
				AddImage("", "GuiChooseSoldier_LuckyStar", x0 + i * dx, y0 + i * dy).SetScaleXY(0.9);
			}
			var txtF:TextField = AddLabel(num + "", 335, 110);
			var tF:TextFormat = new TextFormat();
			tF.size = 20;
			tF.bold = true;
			txtF.setTextFormat(tF);
		}
		
		public function get chose():Boolean 
		{
			return _chose;
		}
		
		public function set chose(value:Boolean):void 
		{
			_chose = value;
			GetButton(BTN_GET_GIFT).SetEnable(value);
		}
		
		public function get giftId():int
		{
			return _giftId;
		}
		
		public function set giftId(value:int):void
		{
			_giftId = value;
		}
	}
}