package Event.EventMidAutumn 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Event.EventMidAutumn.EventPackage.SendGetEventInfo;
	import Event.EventMidAutumn.EventPackage.SendGetGiftStore;
	import Event.EventMidAutumn.ItemEvent.Lantern;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.EventEuro.ItemGiftEuro;
	import GUI.GuiMgr;
	import Logic.FallingObject;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIBackGround extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		static public const BTN_HOME:String = "btnHome";
		static public const BTN_STORE:String = "btnStore";
		static public const NUM_LEVEL:int = 100;
		static public const BTN_NEXT:String = "btnNext";
		static public const NUM_ITEM:int = 8;
		static public const NUM_BACKGROUND:int = 20;
		static public const BTN_PREVIOUS:String = "btnPrevious";
		static public const ITEM_JOURNEY:String = "itemGift";
		private var ctnItem:Container;
		private var time:Number = 0;
		private var speed:Number = 0;
		private var acceleration:Number = 0;
		public var isStop:Boolean = true;
		private var destination:Number;
		private var ctnBackground:Container;
		private var curPage:int;
		private var curPageBackground:int;
		public var eventData:Object;
		private var listGift:Object = new Object();
		private var curPosition:int;
		private var oldPosition:int;//Vị trí vừa đi qua
		private var lanternPosition:int;
		private var isFlying:Boolean;//Đèn đang bay(dùng phân biệt với việc tua màn hình)
		private var mapData:Object;
		private var isLoadContentComplete:Boolean;
		private var fairyFish:Image;
		private var imageStone:Image;
		private var configStone:Object;
		private var configMap:Object;
		public var giftPosition:int;
		public var isShowGift:Boolean;
		
		public function GUIBackGround(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{	
				isStop = true;
				isFlying = false;
				isShowGift = false;
				img.addChild(WaitData);
				WaitData.x = Constant.STAGE_WIDTH / 2 + 296;
				WaitData.y = Constant.STAGE_HEIGHT / 2 + 97;
				isLoadContentComplete = true;
				if (eventData != null)
				{
					updateEventInfo(eventData);
				}
				img.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			isLoadContentComplete = false;
			LoadRes("GuiBackground_Theme");
			Exchange.GetInstance().Send(new SendGetEventInfo());
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (!isFlying)
			{
				//trace(e.delta);
				if (e.delta > 0 && curPosition < lanternPosition + 50 && curPosition <= 759)
				{
					var lantern:Lantern = GuiMgr.getInstance().guiFrontEvent.lantern;
					lantern.SetVisible(false);
					goToPosition(curPosition + 5, 15, 0);
				}
				else if( e.delta < 0)
				{
					goToPosition(lanternPosition, 10, 5);
				}
				
				/*var des:Number = ctnItem.img.y + e.delta * 3;
				trace("des", des);
				var desPositon:int = 6 +(des + (NUM_LEVEL - 1) * Constant.STAGE_HEIGHT ) / (Number(Constant.STAGE_HEIGHT) / NUM_ITEM);
				var desPage:int = 1 + Math.floor(desPositon / NUM_ITEM);
				var desBackground:int = Math.floor(desPage * NUM_BACKGROUND / NUM_LEVEL);
				trace("position", desPositon);
				trace("page", desPage);
				trace("bg", desBackground);
				if (desPositon >= lanternPosition && desPositon <= lanternPosition + 50 && desPositon <= 759)
				{
					ctnItem.img.y = des;
					if (curPage != desPage)
					{
						setPage(desPage);
						curPage = desPage;
					}
					if (desBackground != curPageBackground)
					{
						setBackgroundPage(desBackground);
						curPageBackground = desBackground;
					}
				}*/
			}
		}
		
		/**
		 * Set cho vi tri position
		 * @param	position
		 */
		public function setPosition(position:int):void
		{
			//Quay ve diem position
			//if (position != curPosition)
			{
				curPage = 1 + Math.floor(position / NUM_ITEM);
				curPageBackground = Math.floor(curPage*NUM_BACKGROUND/NUM_LEVEL);
				setBackgroundPage(curPageBackground);
				setPage(curPage);
				goToPosition(position, 10, 5);
				ctnItem.img.y = destination;
				GuiMgr.getInstance().guiFrontEvent.lantern.SetVisible(true);
			}
		}
		
		public function flyByStep(numStep:int, _isRocket:Boolean = false):void
		{
			if (lanternPosition + numStep < 0)
			{
				numStep = -lanternPosition;
			}
			else
			if (lanternPosition + numStep > 759)
			{
				numStep = 759 - lanternPosition;
			}
			//Quay ve diem hien tai
			setPosition(lanternPosition);
			
			//Di tiep
			destination += numStep*Number(Constant.STAGE_HEIGHT)/NUM_ITEM;
			isStop = false;
			speed = 7;
			time = 0;
			if(_isRocket)
			{
				acceleration = 2;
			}
			else
			{
				acceleration = 0;
			}
			isFlying = true;
			//Ăn 2 quà 2 bên nếu dùng tên lửa
			var lantern:Lantern = GuiMgr.getInstance().guiFrontEvent.lantern;
			if ( lantern.Fuel == Lantern.SPACE || (lantern.NumMagnet > 0 && JourneyItem(listGift[lanternPosition]) != null && !JourneyItem(listGift[lanternPosition]).isVIP))
			{
				meetJourneyItem(listGift[lanternPosition]);
			}
			lanternPosition += numStep;
			//trace("lantern position", lanternPosition, "numstep", numStep);
		}
		
/*		private function goTo(_floor:int, _position:int, _speed:Number, _acceleration:Number):void
		{
			//trace("des", _floor, _position);
			isStop = false;
			time = 0;
			speed = _speed;
			acceleration = _acceleration;
			
			destination =  (_floor - NUM_LEVEL) * Constant.STAGE_HEIGHT - (NUM_ITEM-_position) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 224;
		}*/
		
		private function goToPosition(_newPosition:int, _speed:Number, _acceleration:Number):void
		{
			isStop = false;
			time = 0;
			speed = _speed;
			acceleration = _acceleration;
			destination = (_newPosition-5)* Number(Constant.STAGE_HEIGHT) / NUM_ITEM -(NUM_LEVEL - 1) * Constant.STAGE_HEIGHT;
		}
		
		private function setPage(page:int):void
		{
			ctnItem.Clear();
			ctnItem.LoadRes("");
			//trace("set page", curPage);
			for (var i:int = curPage-1; i < curPage+2; i++)
			{
				for (var j:int = 0; j < NUM_ITEM; j++)
				{
					var position:int = (i - 1) * NUM_ITEM + j + 1;
					//trace("ve", position);
					if (position >= 0 && position <= 759)
					{
						if(position < 759)
						{
							ctnItem.AddImage("", "GuiBackground_Ruler", 20, (NUM_ITEM - j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT);
						}
						else
						{
							ctnItem.AddImage("", "GuiBackground_DestinationStone", 9, 19 + (NUM_ITEM - j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT);
						}
						var check:Boolean = false;
						if (configStone[position])
						{
							if (position > curPosition)
							{
								//trace("cur ", curPosition);
								if(position != 759)
								{
									imageStone = ctnItem.AddImage("", "GuiBackground_EffStone", 114 + 273, 67 + (NUM_ITEM - j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT);
									imageStone.GoToAndStop(0);
								}
								else
								{
									imageStone = ctnItem.AddImage("", "GuiBackground_EffEndStone", 114 + 273, 67 + (NUM_ITEM - j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT);
									imageStone.GoToAndStop(0);
								}
							}
							check = true;
							ctnItem.AddImage("", "GuiBackground_GiftTrunk", 114 - 26, 40 + (NUM_ITEM - j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT).SetScaleXY(0.8);
							ctnItem.AddLabel(position + " km", 47,-2 + (NUM_ITEM - j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT, 0xffff00, 0, 0x000000);
						}
						if (!check)
						{
							ctnItem.AddLabel(position + " km", 20,10+ (NUM_ITEM - j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT, 0xffffff, 0, 0x000000);
						}
					}
					if (mapData[position] != null)
					{
						var y:int = mapData[position]["Y"];
						var xGift:int = mapData[position]["YConf"];
						var groupId:String = mapData[position]["gId"];
						var itemId:int = mapData[position]["ItemId"];
						var config:Object = configMap[groupId][xGift][itemId];
						var journeyItem:JourneyItem = new JourneyItem(ctnItem.img);
						journeyItem.EventHandler = this;
						journeyItem.IdObject = ITEM_JOURNEY + "_" + position;
						journeyItem.initItem(config, groupId.search("vip") >= 0);
						journeyItem.xPosition = y;
						journeyItem.yPosition = position;
						listGift[position] = journeyItem;
						if(journeyItem.data["ItemType"] != "Disaster")
						{
							journeyItem.SetPos(75 + 150 * y, (NUM_ITEM-j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT);
						}
						else
						{
							journeyItem.SetPos(0, 100+ (NUM_ITEM-j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT);
						}
						//ctnItem.AddLabel("vi tri " + position, 100 * y, (NUM_ITEM-j) * (Number(Constant.STAGE_HEIGHT) / NUM_ITEM) + 20 + (NUM_LEVEL - i) * Constant.STAGE_HEIGHT);
					}
				}
			}
		}
		
		private function setBackgroundPage(pageBg:int):void
		{
			ctnBackground.ClearComponent();
			for (var i:int = pageBg-1; i < pageBg+2 /*&& i >= 0 && i <= NUM_BACKGROUND-1*/; i++)
			{
				if(i >= 0 && i < 20)
				{
					ctnBackground.AddImage("", "GuiBackground_Background" + (i+1), 0, (NUM_BACKGROUND - i) * (Constant.STAGE_HEIGHT-1), true, ALIGN_LEFT_TOP, false);
					//ctnBackground.AddImage("", "BgLake1", 0, (NUM_BACKGROUND - i) * (Constant.STAGE_HEIGHT-1), true, ALIGN_LEFT_TOP);
				}
				if (Math.random() >= 0.4)
				{
					ctnBackground.AddImage("", "GuiBackground_EffComet",   100 + Math.random()*400, (NUM_BACKGROUND - i) * (Constant.STAGE_HEIGHT-1) + Math.random()*250, true, ALIGN_LEFT_TOP, false);
				}
				if (Math.random() >= 0.4)
				{
					ctnBackground.AddImage("", "GuiBackground_Cloud", 100 + Math.random()*400, (NUM_BACKGROUND - i) * (Constant.STAGE_HEIGHT-1) + Math.random()*250, true, ALIGN_LEFT_TOP, false);
				}
			}
		}
		
		public function onReachDestination():void
		{
			if(isFlying)
			{
				GuiMgr.getInstance().guiFrontEvent.lantern.reachDes();
			}
			isFlying = false;
		}
		
		override public function UpdateObject():void 
		{
			if (ctnItem != null)
			{
				if (isStop)
				{
					return;
				}
				var des:Number;
				//Đèn đi lên
				if (ctnItem.img.y < destination)
				{
					des = ctnItem.img.y + speed + acceleration * time;
					//Set page moi
					if (des >= (curPage-NUM_LEVEL) * Constant.STAGE_HEIGHT)
					{
						curPage++;
						setPage(curPage);
						//trace("curpage", curPage);
					}
					if (des > destination)
					{
						ctnItem.img.y = destination;
						isStop = true;
						onReachDestination();
						return;
					}
					else
					{
						ctnItem.img.y = des;
					}
				}
				//Đèn đi xuống
				else if(ctnItem.img.y > destination)
				{
					des = ctnItem.img.y - speed - acceleration * time;
					//Set page moi
					if (des <= (curPage-NUM_LEVEL) * Constant.STAGE_HEIGHT)
					{
						curPage--;
						setPage(curPage);
					}
					if (des < destination)
					{
						ctnItem.img.y = destination;
						isStop = true;
						onReachDestination();
						if (!isFlying)
						{
							var lantern:Lantern = GuiMgr.getInstance().guiFrontEvent.lantern;
							lantern.SetVisible(true);
						}
						return;
					}
					else
					{
						ctnItem.img.y = des;
					}
				}
				else
				{
					isStop = true;
					onReachDestination();
				}
				//An quà đã đi qua
				curPosition = 6 +(ctnItem.img.y + (NUM_LEVEL - 1) * Constant.STAGE_HEIGHT ) / (Number(Constant.STAGE_HEIGHT) / NUM_ITEM);
				//trace("di qua", curPosition);
				if (isFlying && curPosition != oldPosition)
				{
					//trace("Diem di qua", curPosition);
					//Di len thi an qua o curPosition
					if(ctnItem.img.y <= destination)
					{
						meetJourneyItem(JourneyItem(listGift[curPosition]));
					}
					else
					if (ctnItem.img.y > destination)
					{
						meetJourneyItem(JourneyItem(listGift[curPosition -2]), true);
					}
					oldPosition = curPosition;
					
					//Bảng quà nếu qua mốc
					var configStone:Object = ConfigJSON.getInstance().GetItemList("MidMoon_GenMap")["GiftStone"];
					for (var s:String in configStone)
					{
						if (int(configStone[s]["NumStep"]) == curPosition)
						{
							if (curPosition == 759)
							{
								EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiBackground_EffFinish", null, 320, 172);
								if (imageStone != null && imageStone.img != null)
								{
									imageStone.img.visible = false;
								}
								EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiBackground_EffEndStone", null, 100, 300);
							}
							else
							{
								if (imageStone != null && imageStone.img != null)
								{
									imageStone.img.visible = false;
								}
								EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiBackground_EffStone", null, 100, 300);
							}
							giftPosition = curPosition;
							isShowGift = true;
							//GuiMgr.getInstance().guiGiftStore.showGUI(journeyItem.yPosition, false);
							//isStop = true;
						}
					}
				}
				
				//Di chuyen background
				des = ctnItem.img.y * 0.2;
				if (des > (curPageBackground -NUM_BACKGROUND +1) * Constant.STAGE_HEIGHT)
				{
					curPageBackground++;
					setBackgroundPage(curPageBackground);
				}
				else
				if (des < (curPageBackground - NUM_BACKGROUND -1) * Constant.STAGE_HEIGHT)
				{
					curPageBackground--;
					setBackgroundPage(curPageBackground);
				}
				ctnBackground.img.y = ctnItem.img.y * NUM_BACKGROUND/NUM_LEVEL;
				time += 0.5;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_HOME:
					if (!isFlying && 
						!GuiMgr.getInstance().guiFrontEvent.lantern.inTransform && 
						!GuiMgr.getInstance().guiFrontEvent.inTween &&
						!GuiMgr.getInstance().guiFrontEvent.lantern.isMoving)
					{
						Hide();
					}
					break;
				case BTN_STORE:
					if (!isFlying && 
						!GuiMgr.getInstance().guiFrontEvent.lantern.inTransform && 
						!GuiMgr.getInstance().guiFrontEvent.inTween &&
						!GuiMgr.getInstance().guiFrontEvent.lantern.isMoving)
					{
						GuiMgr.getInstance().guiGiftStore.showGUI(lanternPosition, true);
					}
					break;
				case BTN_NEXT:
					if (!isFlying)
					{
						if (/*(curPage -1) * NUM_ITEM */ curPosition < lanternPosition + 50 && curPosition <= 759)
						{
							/*destination += 2*Number(Constant.STAGE_HEIGHT)/NUM_ITEM;
							isStop = false;
							speed = 7;
							acceleration = 0;*/
							var lantern:Lantern = GuiMgr.getInstance().guiFrontEvent.lantern;
							lantern.SetVisible(false);
							//addImageOnBackground(lantern.ImgName, lantern.img.x, lantern.img.y);
							goToPosition(curPosition + 5, 15, 0);
						}
					}
					break;
				case BTN_PREVIOUS:
					if(!isFlying)
					{
						goToPosition(lanternPosition, 10, 5);
					}
					//goTo(1 + Math.floor(lanternPosition / NUM_ITEM), lanternPosition - Math.max(0, (Math.floor(lanternPosition / NUM_ITEM) - 1)*NUM_ITEM), 10, 5);
					break;
				default:
					//Thổi item
					if (buttonID.search(ITEM_JOURNEY) >= 0 && !isFlying && lanternPosition != 759)
					{
						var position:int = buttonID.split("_")[1];
						if (listGift[position] != null && JourneyItem(listGift[position]).data["ItemType"] != "Disaster")
						{
							if (!JourneyItem(listGift[position]).isVIP)
							{
								var FromX:int = JourneyItem(listGift[position]).xPosition;
								var toX:int = GuiMgr.getInstance().guiFrontEvent.useFan(position, FromX);
								if (toX > 0)
								{
									//JourneyItem(listGift[position]).img.x = 75 + 150 * toX;
									mapData[position]["Y"] = toX;
									JourneyItem(listGift[position]).xPosition = toX;
									
									//Ăn item khi thổi vào vị trí đèn
									if(position == lanternPosition || position == lanternPosition - 1 || position == lanternPosition - 2)
									{
										TweenMax.to(JourneyItem(listGift[position]).img, 1, { bezierThrough:[ { x:75 + 150 * toX, y:JourneyItem(listGift[position]).img.y }], ease:Expo.easeOut , onComplete:completeFly});
									}
									else
									{
										TweenMax.to(JourneyItem(listGift[position]).img, 1, { bezierThrough:[ { x:75 + 150 * toX, y:JourneyItem(listGift[position]).img.y }], ease:Expo.easeOut});
									}
									
									function completeFly():void
									{
										meetJourneyItem(JourneyItem(listGift[position]));
									}
								}
							}
							else
							{
								var txtFormat:TextFormat = new TextFormat("arial", 17, 0xff0000, true); 
								txtFormat.align = "center";
								EffectMgr.getInstance().textFly("Bong bóng tím chỉ có thể ăn bằng\ntên lửa, bạn không thể thổi!", new Point(event.stageX, event.stageY), txtFormat);
							}
						}
					}
					
			}
		}
		
		private function meetJourneyItem(journeyItem:JourneyItem, goDown:Boolean = false):void
		{
			if (journeyItem != null && listGift[journeyItem.yPosition] != null)
			{
				//Quà ở giữa hoặc đang rocket hoặc đang xài nam châm
				var lantern:Lantern = GuiMgr.getInstance().guiFrontEvent.lantern;
				if ((journeyItem.xPosition == 2 || journeyItem.data["ItemType"] == "Disaster" || (lantern.NumMagnet > 0 && !goDown) || lantern.Fuel == Lantern.SPACE)
					&& (!journeyItem.isVIP || lantern.Fuel == Lantern.SPACE))
				{
					switch(journeyItem.data["ItemType"])
					{
						case "Disaster":
							if (lantern.Fuel != Lantern.SPACE && journeyItem.xPosition == 2)
							{
								isStop = true;
								var p:Point = new Point(journeyItem.img.x, journeyItem.img.y);
								p = ctnItem.img.localToGlobal(p);
								var imgCow:Image = new Image(LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER), "GuiBackground_Cow", 100, int(p.y));
								imgCow.SetScaleX( -1);
								TweenMax.to(imgCow.img, 1, { bezierThrough:[ { x:500, y:int(p.y) } ], ease:Expo.easeOut , onComplete:completeCrash } );
								function completeCrash():void
								{
									//trace("trừ máu");
									imgCow.img.visible = false;
									lantern.eatItem(journeyItem.data["ItemType"], journeyItem.data["ItemId"], journeyItem.data["Num"], journeyItem.yPosition);
									isStop = false;
									if (lantern.Blood == 0)
									{
										isStop = true;
										lanternPosition = journeyItem.yPosition;
										goToPosition(lanternPosition, 10, 5);
										onReachDestination();
									}
								}
							}
							journeyItem.SetVisible(false);
							mapData[journeyItem.yPosition] = null;
							listGift[journeyItem.yPosition] = null;
							break;
						case "Cyclone":
							if (lantern.NumArmor <= 0 && lantern.Fuel != Lantern.SPACE && journeyItem.xPosition == 2)
							{
								lanternPosition = journeyItem.yPosition;
								lantern.eatItem(journeyItem.data["ItemType"], journeyItem.data["ItemId"], journeyItem.data["Num"], journeyItem.yPosition);
								mapData[journeyItem.yPosition] = null;
								listGift[journeyItem.yPosition] = null;
								journeyItem.SetVisible(false);
							}
							if (lantern.Fuel == Lantern.SPACE || journeyItem.xPosition == 2)
							{
								journeyItem.SetVisible(false);
								mapData[journeyItem.yPosition] = null;
								listGift[journeyItem.yPosition] = null;
							}
							break;
						case "DropOfWater":
							if (journeyItem.xPosition == 2)
							{
								lantern.eatItem(journeyItem.data["ItemType"], journeyItem.data["ItemId"], journeyItem.data["Num"], journeyItem.yPosition);
							}
							if (lantern.Fuel == Lantern.SPACE || journeyItem.xPosition == 2)
							{
								journeyItem.SetVisible(false);
								mapData[journeyItem.yPosition] = null;
								listGift[journeyItem.yPosition] = null;
							}
							if (lantern.Blood == 0)
							{
								isStop = true;
								lanternPosition = journeyItem.yPosition;
								goToPosition(lanternPosition, 10, 5);
								onReachDestination();
							}
							break;
						case "Health":
						case "Protector":
						case "Speeduper":
						case "Magnetic":
							if(!journeyItem.isVIP || lantern.Fuel == Lantern.SPACE)
							{
								lantern.eatItem(journeyItem.data["ItemType"], journeyItem.data["ItemId"], journeyItem.data["Num"], journeyItem.yPosition);
								journeyItem.dropGift();
								mapData[journeyItem.yPosition] = null;
								listGift[journeyItem.yPosition] = null;
							}
							if (lantern.Fuel == Lantern.SPACE || journeyItem.xPosition == 2)
							{
								journeyItem.SetVisible(false);
								mapData[journeyItem.yPosition] = null;
								listGift[journeyItem.yPosition] = null;
							}
							break;
						default:
							if(!journeyItem.isVIP || lantern.Fuel == Lantern.SPACE)
							{
								journeyItem.dropGift();
								mapData[journeyItem.yPosition] = null;
								listGift[journeyItem.yPosition] = null;
							}
							break;
					}
				}
				/*if (lantern.Blood == 0)
				{
					isStop = true;
					lanternPosition = journeyItem.yPosition;
					goToPosition(lanternPosition, 10, 5);
					onReachDestination();
				}*/
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(ITEM_JOURNEY) >= 0)
			{
				var position:int = buttonID.split("_")[1];
				if (listGift[position] != null)
				{
					var line:int = JourneyItem(listGift[position]).xPosition;
					var dau:int = line == 1 ? -1 : 1;
					GameLogic.getInstance().MouseTransform("EventMidAutumn_Propeller1", dau * 0.7, 0, -dau * 35, dau * ( -20));
					Mouse.hide();
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(ITEM_JOURNEY) >= 0)
			{
				//var position:int = buttonID.split("_")[1];
				//trace(position);
				GameLogic.getInstance().MouseTransform("");
				Mouse.show();
			}
		}
		
		override public function OnHideGUI():void 
		{
			var fallArr:Array = GameLogic.getInstance().user.fallingObjArr;
			for each(var mat:FallingObject in fallArr)
			{
				mat.Destructor();
			}
			fallArr.splice(0, fallArr.length);
			eventData = null;
			GameLogic.getInstance().ShowFish();
			GuiMgr.getInstance().guiFrontEvent.Hide();
			
			GuiMgr.getInstance().guiFrontScreen.img.visible = true;
			GuiMgr.getInstance().GuiMain.img.visible = true;
			GuiMgr.getInstance().GuiFriends.img.visible = true;
			GuiMgr.getInstance().GuiSetting.img.visible = true;
		}
		
		public function updateEventInfo(_eventData:Object):void 
		{
			var stone:Object = ConfigJSON.getInstance().GetItemList("MidMoon_GenMap")["GiftStone"];
			var configStoneNew:Object = new Object();
			for (var s:String in stone)
			{
				configStoneNew[stone[s]["NumStep"]] = true;
			}
			configStone = configStoneNew;
			configMap = ConfigJSON.getInstance().GetItemList("MidMoon_GroupGiftMap");
				
			eventData = _eventData;
			if (!isLoadContentComplete)
			{
				return;
			}
			SetPos(277, 140);
			GuiMgr.getInstance().guiFrontScreen.img.visible = false;
			GuiMgr.getInstance().GuiStore.Hide();
			GuiMgr.getInstance().GuiMain.img.visible = false;
			GuiMgr.getInstance().GuiFriends.img.visible = false;
			GuiMgr.getInstance().GuiSetting.img.visible = false;
			GameLogic.getInstance().HideFish(true);
			
			WaitData.visible = false;
			ctnBackground = AddContainer("", "", 0, -(NUM_BACKGROUND - 1) * Constant.STAGE_HEIGHT);
			ctnBackground.LoadRes("");
			ctnItem = AddContainer("", "", 0, -(NUM_LEVEL - 1) * Constant.STAGE_HEIGHT, true, this);
			ctnItem.LoadRes("");
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xff0000);
			mask.graphics.drawRect(0, 0, Constant.STAGE_WIDTH, Constant.STAGE_HEIGHT);
			mask.graphics.endFill();
			img.addChild(mask);
			img.mask = mask;
			AddButtonEx(BTN_HOME, "BtnHome", Constant.STAGE_WIDTH - 50, 55, this).setTooltipText("Về trại cá");;
			AddButton(BTN_STORE, "GuiBackground_BtnStore", Constant.STAGE_WIDTH - 115, 37, this).setTooltipText("Kho quà");
			AddButton(BTN_NEXT, "GuiBackground_BtnUp", 70, 30);
			AddButton(BTN_PREVIOUS, "GuiBackground_BtnDown", 70, 62);
			//AddImage("", "IcZingXu", 400, 400);
				
			//eventData = GameLogic.getInstance().midMoonData;
			lanternPosition = eventData["MidMoon"]["Lantern"]["X"];
			curPosition = lanternPosition;
			mapData = eventData["MidMoon"]["Map"];
			
			curPage = 1 + Math.floor(lanternPosition / NUM_ITEM);
			curPageBackground = Math.floor(curPage*NUM_BACKGROUND/NUM_LEVEL);
			setBackgroundPage(curPageBackground);
			setPage(curPage);
			//goTo(curPage, lanternPosition - (curPage-1)*NUM_ITEM, 10, 5);
			goToPosition(lanternPosition, 10, 5);
			ctnItem.img.y = destination;
			
			//Ghep noi
			GuiMgr.getInstance().guiFrontEvent.Show();
			var so:SharedObject = SharedObject.getLocal("EventMidAutumnGuide" + GameLogic.getInstance().user.GetMyInfo().Id);
			if ((so == null || so.data.firstTime) && lanternPosition == 0)
			{
				GuiMgr.getInstance().guiTooltipTopUser.showGUI("GuiBackground_GuideImage", 0, 26);
				so.data.firstTime = false;
			}
			
			if(eventData["GiftLost"] != null && eventData["GiftLost"]["Num"] > 0)
			{
				GuiMgr.getInstance().guiFailGift.showGUI(eventData["GiftLost"]["Num"]);
			}
		}
		
		public function addImageOnBackground(_imageName:String, _x:Number, _y:Number):void
		{
			ctnBackground.AddImage("", _imageName, _x - ctnBackground.img.x, _y- ctnBackground.img.y, true, ALIGN_LEFT_TOP);
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			if (event.currentTarget == img)
			{
				GameLogic.getInstance().MouseTransform("");
				Mouse.show();
			}
		}
	}

}