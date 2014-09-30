package GUI.Tournament 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class GUITournamentReceiveGift extends BaseGUI 
	{
		private static const BTN_FEED:String = "BtnFeed";
		private static const CTN_EXP:String = "ctnExp";
		private static const CTN_MATERIAL:String = "ctnMaterial";
		private static const CTN_RANKPOINT:String = "ctnBottle";
		private static const CTN_ENERGY:String = "ctnEnergy";
		private static const CTN_EQUIPMENT:String = "ctnEquipment";
		private var equip:FishEquipment = null;
		private var expGift:int = 0;
		private var diamondGift:int = 0;
		
		public function GUITournamentReceiveGift(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUITournamentReceiveGift";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);				
				AddButton(BTN_FEED, "BtnFeed", 170, 279);
				expGift = 0;
				diamondGift = 0;
				OpenRoomOut();
			}
			
			LoadRes("GuiTournament_ReceiveGift");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_FEED:
					if (expGift > 0)
					{
						GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + expGift);
					}
					if (diamondGift > 0)
					{
						GameLogic.getInstance().user.updateDiamond(diamondGift);
					}
					Hide();
					
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_TOURNAMENT_GET_GIFT);
					break;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_FEED:
					break;
				case CTN_EQUIPMENT:
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null, 0);
					break;
				case CTN_ENERGY:
					break;
				case CTN_EXP:
					break;
				case CTN_MATERIAL:
					break;
				case CTN_RANKPOINT:
					break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_FEED:
					break;
				case CTN_EQUIPMENT:
					GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					break;
				case CTN_ENERGY:
					break;
				case CTN_EXP:
					break;
				case CTN_MATERIAL:
					break;
				case CTN_RANKPOINT:
					break;
			}
		}
		
		public function ShowGui(cardId:int, numStar:int, groupId:int, equipment:Object):void 
		{
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Tournament_Card", cardId)[groupId];
			if (!obj)
			{
				return;
			}
			obj = obj[numStar];
			Show(Constant.GUI_MIN_LAYER, 1);
			var reward:String;
			var x:int = 50;
			var y:int = 157;
			var dx:int = 90;
			var dy:int = 0;
			var i:int = 0;
			var numReward:int = 0;
			for (reward in obj)
			{
				if(reward != "Mask")
				{
					numReward++;
				}
			}
			switch(numReward)
			{
				case 2:
					x = 140;
					break;
				case 3:
					x = 95;
					break;
				case 4:
					x = 50;
					break;
				case 5:
					x = 95;
					dy = 50;
					break;
			}
			
			var fm:TextFormat = new TextFormat();
			fm.font = "arial";
			fm.bold = true;
			fm.color = 0xffffff;
			fm.align = "center";
			
			var ctn:Container;
			var tip:TooltipFormat;
			
			expGift = 0;
			for (reward in obj)
			{
				switch(reward)
				{
					case "Exp":
					{
						ctn = AddContainer(CTN_EXP, "CtnBgAward", x + dx * i, y + (i / 4) * dy, true, this);
						ctn.SetSize(77, 77);
						ctn.AddImage("", "ImgEXP", 10, 8, true, ALIGN_LEFT_TOP).SetScaleXY(1.5);
						ctn.AddLabel("x" + Ultility.StandardNumber(obj[reward]), -12, 55, 0, 1, 0).setTextFormat(fm);
						tip = new TooltipFormat();
						tip.text = Ultility.StandardNumber(obj[reward]) + " kinh nghiệm";
						ctn.setTooltip(tip);
						expGift = obj[reward];
						break;
					}
					case "Material":
					{
						ctn = AddContainer(CTN_MATERIAL, "CtnBgAward", x + dx * i, y + (i / 4) * dy, true, this);
						ctn.SetSize(77, 77);
						ctn.AddImage("", "Material" + obj[reward]["Type"], 37, 28, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
						ctn.AddLabel("x" + Ultility.StandardNumber(obj[reward]["Num"]), -12, 55, 0, 1, 0).setTextFormat(fm);
						tip = new TooltipFormat();
						tip.text = Localization.getInstance().getString("Material" + obj[reward]["Type"]);
						ctn.setTooltip(tip);
						break;
					}
					case "Diamond":
					{
						ctn = AddContainer(CTN_MATERIAL, "CtnBgAward", x + dx * i, y + (i / 4) * dy, true, this);
						ctn.SetSize(77, 77);
						ctn.AddImage("", "IcDiamond", 10, 12, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
						ctn.AddLabel("x" + Ultility.StandardNumber(obj[reward]), -12, 55, 0, 1, 0).setTextFormat(fm);
						tip = new TooltipFormat();
						tip.text = Ultility.StandardNumber(obj[reward]) + " kim cương";
						ctn.setTooltip(tip);
						diamondGift = obj[reward];
						break;
					}
					case "Dice":
					{
						ctn = AddContainer(CTN_MATERIAL, "CtnBgAward", x + dx * i, y + (i / 4) * dy, true, this);
						ctn.SetSize(77, 77);
						ctn.AddImage("", "Dice1", 10, 12, true, ALIGN_LEFT_TOP).FitRect(50, 50);
						ctn.AddLabel("x" + Ultility.StandardNumber(obj[reward]), -12, 55, 0, 1, 0).setTextFormat(fm);
						tip = new TooltipFormat();
						tip.text = Ultility.StandardNumber(obj[reward]) + " xí ngầu cầu may";
						ctn.setTooltip(tip);
						break;
					}
					case "RankPointBottle":
					{
						ctn = AddContainer(CTN_RANKPOINT, "CtnBgAward", x + dx * i, y + (i / 4) * dy, true, this);
						ctn.SetSize(77, 77);
						ctn.AddImage("", "RankPointBottle" + obj[reward]["Type"], 11, 0, true, ALIGN_LEFT_TOP);
						ctn.AddLabel("x" + Ultility.StandardNumber(obj[reward]["Num"]), -12, 55, 0, 1, 0).setTextFormat(fm);
						tip = new TooltipFormat();
						tip.text = Localization.getInstance().getString("RankPointBottle" + obj[reward]["Type"]);
						ctn.setTooltip(tip);
						break;
					}
					case "EnergyItem":
					{
						ctn = AddContainer(CTN_ENERGY, "CtnBgAward", x + dx * i, y + (i / 4) * dy, true, this);
						ctn.SetSize(77, 77);
						ctn.AddImage("", "EnergyItem" + obj[reward]["Type"], 12, 0, true, ALIGN_LEFT_TOP).SetScaleXY(1.5);
						ctn.AddLabel("x" + Ultility.StandardNumber(obj[reward]["Num"]), -12, 55, 0, 1, 0).setTextFormat(fm);
						tip = new TooltipFormat();
						tip.text = Localization.getInstance().getString("EnergyItem" + obj[reward]["Type"]);
						ctn.setTooltip(tip);
						break;
					}                
					case "Equipment":
					case "Jewel":
					{	
						if (equipment != null)
						{
							equip = new FishEquipment();
							equip.SetInfo(equipment);
							ctn = AddContainer(CTN_EQUIPMENT, FishEquipment.GetBackgroundName(equip.Color), x + dx * i, y + (i / 4) * dy, true, this);
							var minh:Image = ctn.AddImage("", equip.imageName + "_Shop", 40, 40);
							GameLogic.getInstance().user.GenerateNextID();
						}
						break;
					}
					case "Mask":
					{
						i--;
						break;
					}
				}
				i++;
			}
		}
	}

}