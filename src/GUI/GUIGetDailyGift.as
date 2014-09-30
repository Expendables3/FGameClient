package GUI 
{
	import com.bit101.components.Style;
	import Data.ConfigJSON;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import Logic.GameLogic;
	import Data.Localization;
	import flash.external.ExternalInterface;
	import Logic.Lake;
	import Sound.SoundMgr;
	import com.bit101.components.ComboBox;
	import flash.events.KeyboardEvent;
	import com.adobe.utils.StringUtil;
	import com.greensock.*;
	import NetworkPacket.PacketSend.SendGetDailyGift;
	import Logic.Ultility;
	/**
	 * ...
	 * @author ...
	 */
	public class GUIGetDailyGift extends BaseGUI 
	{		
		private const DAILY_GIFT:String 	= "DayGift";
		
		private const GUI_BUTTON_SLOT_1:String 	= "ButtonSlot1";
		private const GUI_BUTTON_SLOT_2:String 	= "ButtonSlot2";
		private const GUI_BUTTON_SLOT_3:String 	= "ButtonSlot3";
		private const GUI_BUTTON_SLOT_4:String 	= "ButtonSlot4";
		private const GUI_BUTTON_SLOT_5:String 	= "ButtonSlot5";
		private const GUI_BUTTON_SLOT_6:String 	= "ButtonSlot6";
		
		private const GUI_BUTTON_CLOSE:String 	= "ButtonClose";
				
		private const DAY_SEQUENCE_MASK:String 	= "DaySequenceMask";
		private const DAY_SEQUENCE:String 		= "DaySequence";
		
		private const REWARD_MONEY_100:String 	= "RewardMoney100";
		private const REWARD_MONEY_200:String 	= "RewardMoney200";
		private const REWARD_FOOD_20:String 	= "Food20";
		private const REWARD_ENERGY_10:String 	= "Energy10";
		private const REWARD_RECIPE_5:String 	= "Recipe5";
		private const REWARD_EGG_1:String 		= "Egg1";
		private const REWARD_BACK_SUCC:String 	= "Succ";
		private const REWARD_BACK_MISS:String 	= "Miss";		
		
		private const GIFT_TYPE_1:int 		= 1;
		private const GIFT_TYPE_2:int 		= 2;
		private const GIFT_TYPE_3:int 		= 3;
		private const GIFT_TYPE_4:int 		= 4;
		private const GIFT_TYPE_5:int 		= 5;
		private const GIFT_TYPE_6:int 		= 6;
		private const GIFT_MONEY:String 	= "Money";
		private const GIFT_FOOD:String 		= "Food";
		private const GIFT_ENERGY:String 	= "EnergyItem";
		private const GIFT_MATERIAL:String 	= "Material";
		
		private const OPEN:String 				= "Open";
		private const CLOSE:String 				= "Close";
		
		private var ButtonArray:Array;
		// Slot Status: Open or Close
		private var SlotStatus:Array;
		private var GiftArray:Array;
		private var UnusedGiftArray:Array;
		private var ReceivedArray:Array;
		private var CurrentGift:int;
		private var SequenceMask:Image;
		
		private var MAX_SLOT:int 		= 6;
		private var SLOT_PER_ROW:int 	= 3;
		
		private const GUI_FEED_STRING:String 	= "txtContent";
		private const GUI_FEED_OK:String 		= "ButtonOk";
		private const GUI_FEED_CANCEL:String 	= "ButtonCancel";
		
		// GUI components:
		private var txtContent:TextBox;
		private var Title:TextField;
		private var Content:TextField;
		private var FeedIcon:Image;
		private var FeedType:String;
		private var FeedIconPos:Point;
		private var ComboFeed:ComboBox;
		
		public const FEED_TYPE_INIT:String 			= "run";
		public const FEED_TYPE_LEVEL_UP:String 		= "levelUp";
		public const FEED_TYPE_UPGRADE_TANK:String 	= "upgradeLake";
		public const FEED_TYPE_SQ_FINISH:String 	= "completeQuest_1";
		public const FEED_TYPE_BUY_MIXLAKE:String 	= "buyMixLake";
		
		public var OkButton:Button; 
		
		// Store MixLake Name:
		public var MixLakeName:String;
		
		// Store Target Lake:
		public var TargetLake:Lake;
				
		public function GUIGetDailyGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			x = 240;
			y = 800;
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGetDailyGift";
		}
		
		public override function InitGUI(): void
		{
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			LoadRes("Gui_DailyGift");
			
			CurrentGift = 0;
			
			ButtonArray = new Array();
			SlotStatus  = new Array();
			var ButtonPos:Point = new Point();
			var ButtonGap:Point = new Point();
			
			ButtonPos.x = 200;
			ButtonPos.y = 170;
			ButtonGap.x = 120;
			ButtonGap.y = 120;
			
			// Add buttons:
			var SlotButton:ButtonEx;
			
			var Position:Point = new Point();
			for (var i:int = 0; i < MAX_SLOT; i++)
			{
				Position.x = ButtonPos.x + (int)(i % SLOT_PER_ROW) * ButtonGap.x;
				Position.y = ButtonPos.y + (int)(i / SLOT_PER_ROW) * ButtonGap.y;
				SlotButton = AddButtonEx("ButtonSlot" + (i + 1), "icon_gift", Position.x, Position.y);  
				ButtonArray.push(SlotButton);
				SlotStatus.push(CLOSE);
			}
			
			SequenceMask = AddImage(DAY_SEQUENCE_MASK, "Sequence", 385, 120);
			AddImage(DAY_SEQUENCE, "DaySequence", 387, 120);
			GameLogic.getInstance().MouseTransform("Windows");
			
			AddButton(GUI_BUTTON_CLOSE, "Button_Nhan", 310, 400).SetEnable(false);
			
			SetPos(120, 50);
		}
		
		public function ShowDialog(GiftList:Object):void
		{
			GiftArray     =  GiftList as Array;
			ReceivedArray = new Array();
			for (var k:int = 0; k < GiftArray.length; k++)
			{
				ReceivedArray.push(GiftArray[k]);
			}
			
			// Get Unused Gift:
			UnusedGiftArray = new Array();
			for (var i:int = 1; i <= MAX_SLOT; i++)
			{
				var Used:Boolean = true;
				for (var j:int = 0; j < GiftArray.length; j++)
				{
					if (i == GiftArray[j])
					{
						Used = false;
						break;
					}
				}
				if (Used)
					UnusedGiftArray.push(i);
			}
			
			// Shuffle Unused Array:
			var Temp:Number;
			var SwapPos:Number;
			for (var Swap:int = 0; Swap < UnusedGiftArray.length; Swap++)
			{
				Temp = UnusedGiftArray[Swap];
				SwapPos = Ultility.RandomNumber(0, UnusedGiftArray.length - 1);
				UnusedGiftArray[Swap] = UnusedGiftArray[SwapPos];
				UnusedGiftArray[SwapPos] = Temp;
			}
			
			super.Show(Constant.GUI_MIN_LAYER, 3);
			
			var Des:Number;
			switch (GiftArray.length)
			{
				case 1:
					Des = 45;
				break;
				
				case 2:
					Des = 143;
				break;
				
				case 3:
					Des = 240;
				break;
				
			}
			
			// Calculate the mask array:
			var MaskClip:MovieClip;
			MaskClip = new MovieClip();
			MaskClip.graphics.beginFill(0xFF0000,1);
			MaskClip.graphics.drawRect(0, -10 , 1, 70);
			MaskClip.graphics.endFill();
			SequenceMask.img.addChild(MaskClip);
			SequenceMask.img.mask = MaskClip;
			
			// Move it
			TweenLite.to(MaskClip, 1, { width:Des } );
		}
		
		private function ShowAllAvailable():void
		{
				for (var i:int = 0; i < ButtonArray.length; i++)
				{
					if (SlotStatus[i] == CLOSE)
					{
						ShowSlot(i, "Gift_Miss");
					}
				}
		}
		
		private function GetGiftType(GiftType:int):String
		{
			var Type:String;
			switch (GiftType)
			{
				case 1:
					Type = "GiftCoin100";
					break;
				case 2:
					//Type = "GiftCoin200";
					Type = "GiftCoin100";
					break;
				case 3:
					Type = "GiftFood";
					break;
				case 4:
					Type = "EnergyItem";
					break;
				case 5:
					Type = "GiftMaterial1";
					break;
				case 6:
					Type = "GiftMaterial3";					
					break;
					
			}
			return Type;
		}
		
		private function ShowSlot(Position:int, BackgroundType:String, CallBack:Function = null):void
		{
			if (!IsVisible)
			{
				return;
			}
			var Time:Number;
			Time = 0.2;
			// Hide the current button
			ButtonArray[Position].FlipX(0, Time, 40);
			ButtonArray[Position].SetEnable(false);
			
			// Reveal the gift underneath			
			var imgNameGift:String;
			var numGift:int;
			var typeGift:int;
			var isMine:Boolean;
			if (GiftArray.length > 0)
			{
				typeGift = GiftArray.pop();
				isMine = true;
			}
			else
			{
				typeGift = UnusedGiftArray.pop();
				isMine = false;
			}
			
			imgNameGift = GetGiftType(typeGift);
			SlotStatus[Position] = OPEN;
			
			var ctn:Container = AddContainer("", BackgroundType, ButtonArray[Position].img.x + ButtonArray[Position].img.width/4 - 4, ButtonArray[Position].img.y);
			var objGift:Object = ConfigJSON.getInstance().getItemInfo(DAILY_GIFT, typeGift);
			switch (objGift["ItemType"]) 
			{
				case GIFT_MONEY:				
				{
					numGift = objGift["Num"] * GameLogic.getInstance().user.GetLevel(true);
					if (isMine)
					{
						GameLogic.getInstance().user.UpdateUserMoney(numGift)
					}					
					ctn.AddImage(REWARD_EGG_1, imgNameGift, ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
					break;
				}
				case GIFT_FOOD:				
				{
					numGift = ConfigJSON.getInstance().getItemInfo(GIFT_FOOD, objGift["ItemId"])["Num"] * objGift["Num"];
					if (isMine)
					{
						GameLogic.getInstance().user.UpdateFoodCount(numGift);						
					}
					numGift /= 5;
					ctn.AddImage(REWARD_EGG_1, imgNameGift, ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
					break;
				}
				case GIFT_ENERGY:				
				{
					numGift = objGift["Num"]// * ConfigJSON.getInstance().GetItemInfo(GIFT_ENERGY, objGift["ItemId"])["Num"];
					ctn.AddImage(REWARD_EGG_1, imgNameGift + objGift["ItemId"], ctn.img.width / 2 - 8, ctn.img.height / 2 - 14, true, ALIGN_CENTER_CENTER).SetScaleXY(1.5);
					break;
				}
				case GIFT_MATERIAL:				
				{
					numGift = objGift["Num"];
					ctn.AddImage(REWARD_EGG_1, imgNameGift, ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
					break;
				}
				
			}
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 18;
			txtFormat.bold = true;
			ctn.AddLabel("x" + Ultility.StandardNumber(numGift), 0, 70, 0xffffff, 1, 0x26709C).setTextFormat(txtFormat);
			ctn.FlipX(1, Time, -18, Time, CallBack);
			SlotStatus[Position] = OPEN;
		}
		
		public function SendResult():void
		{
			// Send Recieve Message
			var CmdReqGift:SendGetDailyGift = new SendGetDailyGift();
			Exchange.GetInstance().Send(CmdReqGift);
			
			// Add all Gifts:
			for (var t:int = 0; t < ReceivedArray.length; t++)
			{
				switch (ReceivedArray[t])
				{
					//case GIFT_TYPE_1:
						//Type = "GiftCoin100";
						//GameLogic.getInstance().user.UpdateUserMoney(100);
						//break;
					//case GIFT_TYPE_1:
						//Type = "GiftCoin200";
						//GameLogic.getInstance().user.UpdateUserMoney(200);
						//break;
					//case GIFT_TYPE_1:
						//Type = "GiftFood";
						//GameLogic.getInstance().user.UpdateFoodCount(20);
						//break;
					//case GIFT_TYPE_1:
						//Type = "GiftEnergy";
						//GameLogic.getInstance().user.UpdateEnergy(10);
						//break;
					//case GIFT_TYPE_1:
						//Type = "GiftElement";
						//break;
					case GIFT_TYPE_6:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_HUGE_GIFT);
						break;
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_BUTTON_SLOT_1:
				case GUI_BUTTON_SLOT_2:
				case GUI_BUTTON_SLOT_3:
				case GUI_BUTTON_SLOT_4:
				case GUI_BUTTON_SLOT_5:
				case GUI_BUTTON_SLOT_6:
				{
					if (CurrentGift == ReceivedArray.length)
						return;
					// Increase current Gift
					CurrentGift++;
					
					for (var i:int = 0; i < ButtonArray.length; i++)
					{
						if (ButtonArray[i].ButtonID == buttonID)
						{
							// If this is the last gift avalaible, show all the gifts & enable the close button:
							if (CurrentGift == ReceivedArray.length)
							{
								GetButton(GUI_BUTTON_CLOSE).SetEnable(true);
								ShowSlot(i, "Gift_Open", ShowAllAvailable);
								SendResult();
							}
							else
							{
								ShowSlot(i, "Gift_Open");
							}
							break;
						}
					}
				}
				break;
				
				case GUI_BUTTON_CLOSE:
				{				
					// Close the GUI
					Hide();		
				}
				break;				
			}			
		}		
	}

}