package Logic 
{
	import flash.events.MouseEvent;
	import GUI.component.Image;
	import GUI.GUICongratTuiTanThu;
	import Data.ConfigJSON;
	import GUI.component.TooltipFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.component.ActiveTooltip;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import Effect.EffectMgr;
	import flash.geom.Point;
	import GUI.GUITanThuDetailClickFinish;
	import GUI.GUITanThuDetailClickWait;
	/**
	 * ...
	 * @author ...
	 */
	public class TuiTanThu extends BaseObject 
	{
		
		private var imgTui:String = "";
		private var imgArrow:String = "";
		
		public static const TIMES_OPEN_0:int = 0;
		public static const  TIMES_OPEN_1:int = 1;
		public static const  TIMES_OPEN_2:int = 2;
		public static const  TIMES_OPEN_3:int = 3;
		public static const  TIMES_OPEN_4:int = 4;
		
		public var TIME_OPEN1:int = 30;
		public var TIME_OPEN2:int = 5 * 60;
		public var TIME_OPEN3:int = 10 * 60;
		public var TIME_OPEN4:int = 15 * 60;
		
		private var number:int = 0;
		private var arrow:Image = null;
		public var timesOpen:int = TIMES_OPEN_0;
		public var lastTimeOpenBag:int;		// thời gian cuối mở túi tân thủ
		private var ball:BalloonStart;
		private var isOpen:Boolean = false;
		public var loop:Boolean = true;
		private var count:int = 0;
		public var giftList:Array = [];
		public var error:int = -1;
		
		public var txtCooldown:TextField= new TextField();
		private var format:TextFormat = new TextFormat();
		private var toolTip:TooltipFormat = new TooltipFormat();
		private var guiClick1:GUITanThuDetailClickFinish = new GUITanThuDetailClickFinish(null, "");
		private var guiClick2:GUITanThuDetailClickWait = new GUITanThuDetailClickWait(null, "");
		private var guiCongratTuiTanThu:GUICongratTuiTanThu = new GUICongratTuiTanThu(null, "");
		
		
		public function TuiTanThu(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			this.ClassName = "TuiTanThu";
		}
		
		public function Clear():void 
		{
			if (ball)
			{
				ball.Destructor();
			}
			ClearImage();
		}
		
		/**
		 * 
		 * @param	timeLast
		 * @param	isFirst=true : lần đầu tiên tạo túi
		 */
		public function  init(isFirst:Boolean=true,data:Object=null):void 
		{
			if (!isFirst)
			{
				if (data)
				{
					if ("Gave" in data && "LastGetGiftTime" in data)
					{
						lastTimeOpenBag = data["LastGetGiftTime"];
						var gave:int = data["Gave"];
						if ( gave>= 0 && gave<=4)
						{
							timesOpen=gave+1;
						}	
					}
				}
			}
			else 
			{
				lastTimeOpenBag = GameLogic.getInstance().CurServerTime;
				timesOpen = TIMES_OPEN_1;
				GameLogic.getInstance().user.isFisrtLogin = 1;
			}
			if (lastTimeOpenBag>-1)
			{
				lastTimeOpenBag +=1;
				// time out 5 giây;
				LoadRes("TuiTanThu_Idle");
				img.buttonMode = true;
				SetPos(630, 520);
				SetGiftList();
				isOpen = false;
				loop = true;
				AddTextCountDown();
				addToolTip();
				
				var obj:Object = ConfigJSON.getInstance().GetItemList("NewUserGiftBag");			
				var i:int = 0;
				var a:int;
				var b:int;
				for (var s:String in obj) 
				{
					if (i == 0)
					{
						a = parseInt(s);		
					}
					i++;
				}
				b = a + i - 1;
				var lv:int = GameLogic.getInstance().user.Level;
				if (lv >b||(lv== b && timesOpen == 5))
				{
					Clear();
				}
			}
			
		}
		
		public function  updateLastTimeOpenBag(data:Object):void 
		{
			if ("Error" in data)
			{
				if (data["Error"] == 0)
				{
					if ("LastGetGiftTime" in data)
					{
						lastTimeOpenBag = data["LastGetGiftTime"];
						GameLogic.getInstance().user.isFisrtLogin = 1;
					}
				}
			}
		}
		
		/**
		 * set ảnh túi lúc có thể mở lấy đồ
		 * @param	time
		 */
		public function setImgOpeningBag(time:int):Boolean 
		{
			var temp:Boolean = false;
			switch (timesOpen) 
			{
				case TIMES_OPEN_1:
					if (time >= TIME_OPEN1)
					{
						temp = true;
					}
					break;
				case TIMES_OPEN_2:
					if (time >= TIME_OPEN2)
					{
						temp = true;
					}
					break;
				case TIMES_OPEN_3:
					if (time >= TIME_OPEN3)
					{
						temp = true;
					}
					break;
				case TIMES_OPEN_4:
					if (time >= TIME_OPEN4)
					{
						temp = true;
					}
					break;
			}
			if (temp)
			{
				ClearImage();
				if (!GameLogic.getInstance().user.IsViewer())
				{
					LoadRes("TuiTanThu_Open");
					SetPos(670, 600);
				}
			}
			return temp;
		}
		
		/**
		 * set ảnh túi lúc chưa mở được đồ
		 */
		public function setImgCLoseBag():void 
		{
			ClearImage();
			LoadRes("TuiTanThu_Idle");
			img.buttonMode = true;
			SetPos(630, 520);
			AddTextCountDown();
		}
		
		public function GetGift(data:Object):void 
		{
			if ("Error" in data)
			{
				if (data["Error"]==0)
				{
					if(ball)
					ball.Destructor();
					setImgCLoseBag();
					guiCongratTuiTanThu.ShowGui();
				}
			}
		}
		
		public function SetGiftList():void 
		{
			var obj:Object = ConfigJSON.getInstance().GetItemList("NewUserGiftBag");
			var lv:int = GameLogic.getInstance().user.Level;
			if (lv in obj)
			{
				
				TIME_OPEN1 = obj[lv][1]["Cooldown"];
				TIME_OPEN2 = obj[lv][2]["Cooldown"];
				TIME_OPEN3 = obj[lv][3]["Cooldown"];
				TIME_OPEN4 = obj[lv][4]["Cooldown"];
				var tmp:int = timesOpen;
				if (timesOpen ==0)
				{
					tmp = 1;
					
				}
				if (timesOpen==5) 
				{
					tmp = TIMES_OPEN_4;
					
				}
				
				if (tmp in obj[lv])
				{
					var o:Object = obj[lv][tmp];
					if ("Bonus" in o)
					{
						giftList = [];
						for (var i:String = 0 in o["Bonus"]) 
						{
							giftList.push(o["Bonus"][i]);
						}					
					}
				}
			}
		}
		
		public function ShowGift():void 
		{
			var s:String;
			var a:Array = [];
			for (var i:int = 0; i < giftList.length;i++ )
			{
				if ("ItemType" in giftList[i])
				{
					s = giftList[i]["ItemType"];
					switch (s) 
					{
						case "Exp":
							a.push("ImgEXP");
						break;
						case "OceanTree":
						//imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						//img = AddImage("", imgName, pos.x, pos.y, true, ALIGN_LEFT_TOP);
						//img.SetScaleX(0.6);
						//img.SetScaleY(0.6);
						break;
							
						break;
						case "Money":
							
						break;
						case "ZMoney":
							
						break;
						case "Material":
							
						break;
						case "EnergyItem":
							a.push("IconEnergy");
						break;
						case "BabyFish":
							
						break;
						case "FairyDrop":
							
						break;
						case "SpecialFish":
							
						break;
						case "RareFish":
							
						break;
						case "Other":
							
						break;
					}
					
				}
			}
				
			
		}
		
		public function UpdateBonus():void
		{
			var i:int;
			var obj:Object = ConfigJSON.getInstance().GetItemList("NewUserGiftBag");			
			var j:int = 0;
			var a:int;
			var b:int;
			for (var s:String in obj) 
			{
				if (j == 0)
				{
					a = parseInt(s);		
				}
				j++;
			}
			b = a + j-1;
			for (i = 0; i < giftList.length; i++)
			{
				var tg:Object = giftList[i];
				if ("ItemType" in tg)
				{
					switch (tg["ItemType"])
					{
						case "Money":
							GameLogic.getInstance().user.UpdateUserMoney(tg["Num"]);
							break;
						case "ZMoney":
							GameLogic.getInstance().user.UpdateUserZMoney(tg["Num"]);
						break;
						case "Exp":							
							GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + tg["Num"], false, true);
						break;
						case "FairyDrop":
						GameLogic.getInstance().user.UpdateFairyDrop(tg["Num"]);
						break;
						case "Material":
						case "EnergyItem":
						case "RecoverHealthSoldier":
						case "Samurai":
						case "RankPointBottle":
						case "Ginseng":
							if (GuiMgr.getInstance().GuiStore.IsVisible)
							{
								GuiMgr.getInstance().GuiStore.UpdateStore(tg["ItemType"], tg["ItemId"], tg["Num"]);
							}
							else 
							{
								GameLogic.getInstance().user.UpdateStockThing(tg["ItemType"], tg["ItemId"], tg["Num"]);
							}
						break;
						case "Gem":
							if (GuiMgr.getInstance().GuiStore.IsVisible)
							{
								GuiMgr.getInstance().GuiStore.Hide();
							}
						break;
						case "OceanTree":
						case "Other":
							if (GuiMgr.getInstance().GuiStore.IsVisible)
							{
								GuiMgr.getInstance().GuiStore.Hide();
							}
							for (var k:int = 0; k < tg["Num"]; k++)
							{
								GameLogic.getInstance().user.UpdateStockThing(tg["ItemType"], tg["ItemId"], 1);
							}
						break;
						case "BabyFish":
						case "SpecialFish":
						case "RareFish":
							tg["ItemType"] = "BabyFish";
							if (GuiMgr.getInstance().GuiStore.IsVisible)
							{
								GuiMgr.getInstance().GuiStore.Hide();
								GuiMgr.getInstance().GuiStore.UpdateStore(tg["ItemType"], tg["ItemId"], tg["Num"]);
							}
							else 
							{
								GameLogic.getInstance().user.UpdateStockThing(tg["ItemType"], tg["ItemId"], tg["Num"]);
							}
							GameLogic.getInstance().user.GenerateNextID();
						break;
						case "PowerTinh":
						case "Iron":
						case "Jade":
						case "SixColorTinh":
						case "SoulRock":
							GameLogic.getInstance().user.updateIngradient(tg["ItemType"], tg["Num"], tg["ItemId"]);
						break;
						
					}
				}
			}
		
			timesOpen++;
			if (timesOpen >= 5)
			{
				loop = false;
				var lv:int = GameLogic.getInstance().user.Level;
				lv++;
				txtCooldown.text = "  Mở tiếp ở level:  " + lv ;
				if (lv >b||(lv-1)==b)
				{
					ClearImage();
				}
			}
			SetGiftList();
			SetLastTime();
			loop = true;
			isOpen = false;
		}
		
		public function SetLastTime():void 
		{
			lastTimeOpenBag = GameLogic.getInstance().CurServerTime+1;
		}
	
		/**
		 * cập nhật theo frame
		 */
		public function  Update():void 
		{
			// check level
			var lv:int = GameLogic.getInstance().user.Level;
			
			var obj:Object = ConfigJSON.getInstance().GetItemList("NewUserGiftBag");			
			var i:int = 0;
			var a:int;
			var b:int;
			for (var s:String in obj) 
			{
				if (i == 0)
				{
					a = parseInt(s);		
				}
				i++;
			}
			b = a + i-1;
			if (lv > b)
			{
				// hide
				ClearImage();
				return;
			}
			if (loop&&GameLogic.getInstance().user.isFisrtLogin)
			{
				var tmp:Number = GameLogic.getInstance().CurServerTime - lastTimeOpenBag;
				var regentime:int; 
				switch (timesOpen) 
				{
					case TIMES_OPEN_1:
						regentime = TIME_OPEN1;
					break;
					case TIMES_OPEN_2:
						regentime = TIME_OPEN2;
					break;
					case TIMES_OPEN_3:
						regentime = TIME_OPEN3;
					break;
					case TIMES_OPEN_4:
						regentime = TIME_OPEN4;
					break;
				}
				var cl:Number = regentime - tmp;
				if (cl >=0)
				{
					var min:int = cl / 60;
					var sec:int = cl - min * 60;
					var minSt:String = min.toString();
					var secSt:String = sec.toString();
					if (min < 10)
					{
						minSt = "0" + min.toString();
					}
					if (sec < 10)
					{
						secSt = "0" + sec.toString();
					}
					var cooldown:String = minSt + ":" + secSt;
					
					txtCooldown.text = cooldown;
					if (guiClick2)
					{
						guiClick2.Update(cooldown);
					}
				}
				else
				{
					txtCooldown.text = "";
				}
				
				if (!isOpen)
				{
					isOpen = setImgOpeningBag(tmp);
				}
				else
				{
					count++;
					if (count<20&&count>18)
					{
						if(ball)
						{
							ball.ClearImage();
							ball = null;
						}
						ball = new BalloonStart(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "BalloonStart");
						ball.SetPos(670,530);
						ball.setBob(300);
					}

					if(count>25)
					{
						loop = false;
						ClearImage();
						LoadRes("TuiTanThu_Open_Idle");
						img.buttonMode = true;
						SetPos(670, 600);
						count = 0;
					}
				}
			}
			if (ball)                                
			{
				ball.updateBalloon();
			}
		}
		
		private function AddTextCountDown():void 
		{
			txtCooldown = AddLabel(" ", img.width / 2 - 50, img.height - 40 , 0x800000, 1, 0xFFFFFF);
			txtCooldown.mouseEnabled = false;
			format.size = 12;
			format.color = 0x000000;
			format.bold = true;
			txtCooldown.defaultTextFormat = format;
		}
		
		private function addToolTip():void 
		{
			toolTip.text = "Click để biết thêm chi tiết";		
		}
	
		private function AddLabel(st:String, x:int, y:int, color:int = 0x000000, align:int = 1, IsOutline:int = -1):TextField
		{
			var txt:TextField = new TextField();
			txt.x = x;
			txt.y = y;			
			txt.text = st;
			switch(align)
			{
				case 0:
					txt.autoSize = TextFieldAutoSize.LEFT;
					break;
				case 1:
					txt.autoSize = TextFieldAutoSize.CENTER;
					break;
				case 2:
					txt.autoSize = TextFieldAutoSize.RIGHT;
					break;				
			}
			txt.mouseEnabled = false;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.color = color;
			txtFormat.font = "Arial";
			txtFormat.bold = true;
			txt.setTextFormat(txtFormat);
			txt.defaultTextFormat = txtFormat;
			
			if (IsOutline >= 0)
			{
				var outline:GlowFilter = new GlowFilter();
				outline.blurX = outline.blurY = 3.5;
				outline.strength = 8;
				outline.color = IsOutline;
				var arr:Array = [];
				arr.push(outline);
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.filters = arr;
			}
			img.addChild(txt);
			return txt;
		}
		
		override public function OnMouseOver(event:MouseEvent):void 
		{
			if (loop)
			{
				ActiveTooltip.getInstance().showNewToolTip(toolTip, this.img);
				SetHighLight(0xFFFF00);
			}
			
		}
		
		override public function OnMouseOut(event:MouseEvent):void 
		{
				ActiveTooltip.getInstance().clearToolTip();
				SetHighLight(-1);
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			if (loop)
			{
				if (timesOpen <= 4)
				{
					guiClick2.ShowGui();
				}
				else
				{	
					if (timesOpen >= 5)
					{
						//guiClick1.ShowGui();
						var s:String = "Bạn đã nhận đủ 4 lần quà ! "+"\nHãy lên cấp để nhận típ nha!";
						GuiMgr.getInstance().GuiMessageBox.ShowOK(s,310,215, GUIMessageBox.NPC_MERMAID_NORMAL);
					}
				}
			}
		}
	}

}