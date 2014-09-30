package Event.EventHalloween.HalloweenGui 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Event.EventHalloween.HalloweenGui.ItemGui.ItemHalloween;
	import Event.EventHalloween.HalloweenGui.ItemGui.StoreHalloween;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventHalloween.HalloweenLogic.ItemHalloweenInfo;
	import Event.EventHalloween.HalloweenPackage.SendTrickOrTreat;
	import Event.EventHalloween.HalloweenPackage.SendUnlockNode;
	import Event.EventMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.ActorFish;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.SpriteExt;
	import GUI.GuiBuyAbstract.BuyItemSvc;
	import GUI.GUIFeedWall;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.BasePacket;
	
	/**
	 * Gui Chính của Halloween
	 * @author HiepNM2
	 */
	public class GuiHalloween extends GUIGetStatusAbstract 
	{
		static public var CMD_NODE:String = "cmdNode";
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		static public const CMD_USE_ROCK:String = "cmdUseRock";
		static public const CMD_TRUNK:String = "cmdTrunk";
		static public const CMD_BUY:String = "cmdBuy";
		static public const ID_IMG_ROCK:String = "idImgRock";
		static public const CMD_FINISH_AUTO:String = "cmdFinishAuto";
		static public const CMD_BUY_ROCK:String = "cmdBuyRock";
		static public const CMD_GUIDE:String = "cmdGuide";
		
		private var _listNode:Array = [];
		public var inUnlock:Boolean = false;
		private var inWaitUnlockPackage:Boolean = false;
		private var inTweenAndShiftUnlock:Boolean = false;
		private var _actor:ActorFish;
		private var ctnTrunk:Container;
		private var imgTrunkOpen:Image;
		private var _trunk:StoreHalloween;
		private var tfNumKey:TextField;
		private var inDelay:Boolean;
		private var timeLockDelay:Number;
		private var xClick:int;
		private var yClick:int;
		private var _timeShowUserInfo:Number = -1;
		private var delayTime:Number = 0.8;
		private var tfTime:TextField;
		private var zerohour:int;		//mốc 00:00:00 của ngày kế tiếp
		private var _timeGui:Number;
		private var inOverTime:Boolean;
		public var inBuyPack:Boolean = false;
		public var inTrickOrTreat:Boolean = false;
		private var target:ItemHalloween;
		private var imgRock1:ButtonEx, imgRock2:ButtonEx, imgRock3:ButtonEx, imgRock4:ButtonEx, imgRock5:ButtonEx, 
					imgRock6:ButtonEx, imgRock7:ButtonEx, imgRock8:ButtonEx, imgRock9:ButtonEx, imgRock10:ButtonEx, 
					imgRock11:ButtonEx, imgRock12:ButtonEx, imgKey:ButtonEx;
		private var inVibrateTrunk:Boolean = false;
		private var so:SharedObject;
		
		public function GuiHalloween(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiHalloween";
			_imgThemeName = "GuiHalloween_Theme";
			_urlService = "EventService.hal_getInfo";
			_idPacket = Constant.CMD_GET_STATUS_EVENT_HALLOWEEN;
		}
		
		override protected function onInitGuiBeforeServer():void 
		{
			SetPos(0, 0);
			BuyItemSvc.getInstance().UrlBuyAPI = "EventService.hal_buyItem";
			BuyItemSvc.getInstance().IdBuyAPI = Constant.CMD_BUY_PACK_HALLOWEEN;
			
			var btnClose:Button = AddButton(ID_BTN_CLOSE, "GuiHalloween_BtnGoHome", 760, 24);
			btnClose.setTooltipText("Trở về nhà");
			var imgHalloween:ButtonEx;
			imgHalloween = AddButtonEx("", "GuiHalloween_ImgBag", 600, 270);
			imgHalloween.setTooltipText("Túi Bảo Thạch\nMua thành công sẽ nhận được ngẫu nhiên 10 viên bảo thạch các loại ");
			imgHalloween.img.buttonMode = false;
			imgKey = AddButtonEx(ID_IMG_ROCK + "_End_1", "GuiHalloween_ImgKey", 723, 270);
			imgKey.setTooltipText(Localization.getInstance().getString("EventHalloween_TipHalItem13"));
			imgKey.img.buttonMode = false;
			var imgCLock:ButtonEx = AddButtonEx("", "GuiHalloween_ImgClock", 380, 40);
			imgCLock.setTooltipText(Localization.getInstance().getString("EventHalloween_TipTime"));
			tfTime = AddLabel("", 435, 50, 0xfffffff, 1, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 16);
			tfTime.defaultTextFormat = fm;
		}
		
		override protected function onInitData(data1:Object):void 
		{
			HalloweenMgr.getInstance().initData(data1);
		}
		
		override protected function onInitGuiAfterServer():void 
		{
			var uid:int = GameLogic.getInstance().user.GetMyInfo().Id;
			so = SharedObject.getLocal("EventHalloweenGuide" + uid);
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var lastDay:String;
			if (so == null)
			{
				GuiMgr.getInstance().guiGuideHalloween.Show(Constant.GUI_MIN_LAYER, 5);
				so.data.lastDay = today;
			}
			else
			{
				lastDay = so.data.lastDay;
				if (lastDay != today)
				{
					GuiMgr.getInstance().guiGuideHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					so.data.lastDay = today;
				}
			}
			AddButton(CMD_GUIDE, "GuiHalloween_BtnGuide", 726, 35);
			/*vẽ toàn map*/
			var itemNode:ItemHalloween;
			var info:ItemHalloweenInfo;
			var i:int, j:int;
			var mapInfo:Array = HalloweenMgr.getInstance().getMap();
			var x:int = 18, y:int = 88;
			var line:Array;
			for (i = 0; i < ItemHalloweenInfo.MAX_Y; i++)
			{
				x = 18;
				line = new Array();
				for (j = 0; j < ItemHalloweenInfo.MAX_X; j++)
				{
					info = mapInfo[i][j];
					itemNode = new ItemHalloween(this.img, "KhungFriend", x, y);
					itemNode.Node = info;
					itemNode.IdObject = CMD_NODE + "_" + i + "_" + j;
					itemNode.EventHandler = this;
					itemNode.drawGift();
					line.push(itemNode);
					
					if (info.isBound)
					{
						itemNode.showAsBound();
					}
					if (info.ItemType == "End" && info.ItemId == 1)
					{
						target = itemNode;
						target.setTooltipText(Localization.getInstance().getString("EventHalloween_TipEnd"));
					}
					if (info.ItemType == "Chest")
					{
						itemNode.setTooltipText(Localization.getInstance().getString("EventHalloween_Tip" + info.ItemType + info.ItemId));
					}
					x += 54;
				}
				_listNode.push(line);
				y += 52;
			}
			/*khởi tạo cho actorFish*/
			_actor = new ActorFish(this.img, "GuiHalloween_ActorFish", 0, 0);
			_actor.setTooltipText(Localization.getInstance().getString("EventHalloween_TipActorFish"));
			var pScr:Point = HalloweenMgr.getInstance().pScr;
			itemNode = _listNode[pScr.x][pScr.y];
			_actor.SetPos(itemNode.img.x + 25, itemNode.img.y + 24);
			/*Vẽ phần điều khiển*/
			y = 83;
			var id:int;
			var tfNum:TextField;
			var num:int;
			for (i = 1; i <= 3; i++)
			{
				x = 585;
				for (j = 1; j <= 4; j++)
				{
					AddImage("", "GuiHalloween_HalItem0", x + 22, y + 22);
					id = 4 * (i - 1) + j;
					this["imgRock" + id] = AddButtonEx(ID_IMG_ROCK + "_HalItem_" + id, "GuiHalloween_HalItem" + id, x, y);
					var imgRock:ButtonEx = this["imgRock" + id];
					imgRock.setTooltipText(Localization.getInstance().getString("EventHalloween_TipHalItem" + id));
					imgRock.img.buttonMode = false;
					tfNum = AddLabel("", x - 28, y + 38, 0xffffff, 1, 0x000000);
					tfNum.name = CMD_USE_ROCK + "_" + id;
					num = HalloweenMgr.getInstance().getRockNum(id);
					tfNum.text = "x" + Ultility.StandardNumber(num);
					x += 54;
				}
				y += 58;
			}
			/*Mua chìa khóa*/
			var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["BuyKey"]["ZMoney"];
			AddButton(CMD_BUY + "_BuyKey_1_" + price + "_ZMoney", "GuiHalloween_BtnBuyZMoney", 715, 340);
			AddLabel(Ultility.StandardNumber(price), 695, 346, 0xffffff, 1, 0x000000);
			tfNumKey = AddLabel("", 695, 315, 0xffffff, 1, 0x000000);
			tfNumKey.text = "x" + Ultility.StandardNumber(HalloweenMgr.getInstance().Key);
			/*Mua túi đá*/
			AddButton(CMD_BUY + "_BuyPack_1_" + price + "_ZMoney", "GuiHalloween_BtnBuyZMoney", 600, 340);
			price = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["BuyPack"]["ZMoney"];
			AddLabel(Ultility.StandardNumber(price), 580, 346, 0xffffff, 1, 0x000000);
			/*tự động hoàn thành*/
			AddButton(CMD_FINISH_AUTO, "GuiHalloween_BtnAuto", 630, 380);
			/*cái rương*/
			ctnTrunk = AddContainer(CMD_TRUNK, "GuiHalloween_TrunkOpen", 615, 450, true, this);
			ctnTrunk.img.buttonMode = true;
			ctnTrunk.setTooltipText("Đựng phần thưởng\nnhặt được trong bảo đồ");
			AddButton(CMD_TRUNK, "GuiHalloween_BtnOpenTrunk", 585, 500);
			_trunk = GuiMgr.getInstance().TrunkHalloween;//trỏ vào đây
			_trunk.Show();
			GuiMgr.getInstance().guiUserEventInfo.Show();
			_timeShowUserInfo = GameLogic.getInstance().CurServerTime;
			_timeGui = int(_timeShowUserInfo);
			zerohour = int(_timeGui) + 86400 - int(_timeGui) % 86400 - 7 * 3600;
			var remain:int = zerohour - int(_timeGui);
			tfTime.text = Ultility.convertToTime(remain);
			if (remain <= 0)
			{
				zerohour += 86400;
				inOverTime = false;
			}
			//phần thưởng an ủi
			if (!HalloweenMgr.getInstance().IsGetSaveGift)
			{
				GuiMgr.getInstance().guiGiftSaveHalloween.Show(Constant.GUI_MIN_LAYER, 5);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (_trunk.inShift || inUnlock)//chan het cac truong hop
			{
				return;
			}
			
			if (buttonID == ID_BTN_CLOSE)
			{
				if (inVibrateTrunk)
				{
					return;
				}
				Hide();
				return;
			}
			
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var pk:BasePacket;
			switch(cmd)
			{
				case CMD_NODE:
					var xStart:Number;
					if (inTrickOrTreat) return;
					var posStart:Point;
					var posEnd:Point;
					var str:String;
					var x:int = int(data[1]);
					var y:int = int(data[2]);
					//trace("click vao vi tri node (x = " + x + ", y = " + y + ")");
					var mapInfo:Array = HalloweenMgr.getInstance().getMap();
					var node:ItemHalloweenInfo = mapInfo[x][y];
					
					if (node.isBound)
					{
						//xStart = event.stageX;
						//if (xStart < 75)
						//{
							//xStart = 75;
						//}
						//posStart = new Point(xStart, event.stageY);
						//posEnd = new Point(xStart, event.stageY - 20);
						//str = "Click để mở ô";
						//Ultility.ShowEffText(str, null, posStart, posEnd);
						
						if (inBuyPack)
						{
							posStart = new Point(event.stageX, event.stageY);
							posEnd = new Point(event.stageX, event.stageY - 20);
							str = "Hệ thống đang mua đá";
							Ultility.ShowEffText(str, null, posStart, posEnd);
							break;
						}
						if (checkUnlockNode(x, y))
						{
							var itNode:ItemHalloween = _listNode[x][y];
							//if (itNode.guiTooltip)
							//{
								//if (itNode.guiTooltip.IsVisible)
								//{
									//itNode.guiTooltip.Hide();
									//itNode.guiTooltip = null;
								//}
							//}
							inUnlock = true;
							/*gửi dữ liệu lên server về việc unlock node này*/
							inWaitUnlockPackage = true;
							pk = new SendUnlockNode(x, y);
							Exchange.GetInstance().Send(pk);
							inTweenAndShiftUnlock = true;
							if (node.Thick == ItemHalloweenInfo.FREEZE)
							{
								xClick = x;
								yClick = y;
								inDelay = true;
								timeLockDelay = GameLogic.getInstance().CurServerTime;
								delayTime = 0;
							}
							else if (node.Thick == ItemHalloweenInfo.LAND)
							{
								var line:Array = findLine(x, y, false);
								line.shift();//bỏ đỉnh đầu tiên, vì đây là vị trí con cá
								if (!inOverTime)
								{
									if (EventMgr.CheckEvent("Hal2012") == EventMgr.CURRENT_IN_EVENT)
									{
										_actor.move(line, fMoveComp);		//cho con cá di chuyển đến gần vị trí đích
										xClick = x;
										yClick = y;
										function fMoveComp():void
										{
											inDelay = true;
											timeLockDelay = GameLogic.getInstance().CurServerTime;
											delayTime = 0.2;
										}
									}
								}
							}
						}
					}
					else
					{
						if (node.Thick == ItemHalloweenInfo.ROAD)
						{
							break;
						}
						xStart = event.stageX;
						if (xStart < 75)
						{
							xStart = 75;
						}
						posStart = new Point(xStart, event.stageY);
						posEnd = new Point(xStart, event.stageY - 20);
						str = "Không có đường đến ô này";
						Ultility.ShowEffText(str, null, posStart, posEnd);
					}
					break;
				case CMD_TRUNK:
					showTrunk(true);
					break;
				case CMD_BUY:
					var type:String = data[1];
					var id:int = data[2];
					var price:int = int(data[3]);
					var priceType:String = data[4];

					if (type == "BuyKey")
					{
						if (BuyItemSvc.getInstance().buyItem(type, id, priceType, price))
						{
							EffectMgr.setEffBounceDown("Mua thành công", "GuiHalloween_ImgKey", 330, 280);
							HalloweenMgr.getInstance().Key++;
							tfNumKey.text = "x" + Ultility.StandardNumber(HalloweenMgr.getInstance().Key);
						}
					}
					else if (type == "BuyPack")
					{
						var myMoney:int;
						if (priceType == "ZMoney")
						{
							myMoney = GameLogic.getInstance().user.GetZMoney();
						}
						else if (priceType == "Money")
						{
							myMoney = GameLogic.getInstance().user.GetMoney();
						}
						else if (priceType == "Diamond")
						{
							myMoney = GameLogic.getInstance().user.getDiamond();
						}
						GuiMgr.getInstance().guiBuyMultiRock.priceType = priceType;
						GuiMgr.getInstance().guiBuyMultiRock.costPerPack = price;
						GuiMgr.getInstance().guiBuyMultiRock.showGUI(int(myMoney / price), "Túi đá mật mã", "GuiHalloween_ImgBag", function f(numPack:int):void
						{
							if (numPack > 0)
							{
								if (Ultility.payMoney(priceType, price * numPack))
								{
									GuiMgr.getInstance().guiBuyContinue.numPack = numPack;
									GuiMgr.getInstance().guiBuyContinue.Show(Constant.GUI_MIN_LAYER, 5);
									inBuyPack = true;
								}
							}
						});
						//if (Ultility.payMoney(priceType, price))
						//{
							//GuiMgr.getInstance().guiBuyContinue.Show(Constant.GUI_MIN_LAYER, 5);
							//inBuyPack = true;
						//}
					}
					break;
				case CMD_FINISH_AUTO:
					if (inTrickOrTreat) return;
					if (!HalloweenMgr.getInstance().isMoved)
					{
						GuiMgr.getInstance().guiFinishAuto.Show(Constant.GUI_MIN_LAYER, 5);
					}
					else
					{
						GuiMgr.getInstance().guiMessageAuto.Show(Constant.GUI_MIN_LAYER, 5);
					}
					break;
				case CMD_GUIDE:
					GuiMgr.getInstance().guiGuideHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					break;
			}
		}
		
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_NODE:
					var x:int = int(data[1]);
					var y:int = int(data[2]);
					var mapInfo:Array = HalloweenMgr.getInstance().getMap();
					var node:ItemHalloweenInfo = mapInfo[x][y];
					if (node.isBound)
					{
						if (node.ItemId > 0 && node.ItemId < 13)
						{
							(this["imgRock" + node.ItemId] as ButtonEx).SetHighLight();
						}
					}
					break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_NODE:
					var x:int = int(data[1]);
					var y:int = int(data[2]);
					var mapInfo:Array = HalloweenMgr.getInstance().getMap();
					var node:ItemHalloweenInfo = mapInfo[x][y];
					if (node.isBound)
					{
						if (node.ItemId > 0 && node.ItemId < 13)
						{
							(this["imgRock" + node.ItemId] as ButtonEx).SetHighLight( -1);
						}
					}
					break;
			}
		}
		override protected function onUpdateGui(curTime:Number):void 
		{
			if (inDelay)//đang trong delay
			{
				if (curTime - timeLockDelay > delayTime)
				{
					inDelay = false;
					var mapInfo:Array = HalloweenMgr.getInstance().getMap();
					var node:ItemHalloweenInfo = mapInfo[xClick][yClick];
					var res:String = "EventHalloween_" + node.ItemType + node.ItemId;
					var type:String = node.ItemType;
					var id:int = node.ItemId;
					function breakChest():void
					{
						inTweenAndShiftUnlock = false;
						if (!inWaitUnlockPackage)//dữ liệu server đã sẵn sàng
						{
							breakRock(xClick, yClick, HalloweenMgr.getInstance().getAgent());
						}
						HalloweenMgr.getInstance().breakRock(xClick, yClick, node.Thick == ItemHalloweenInfo.FREEZE);
					}
					if (type == "Chest")
					{
						if (id == 1)
						{
							breakChest();
							return;
						}
						res = "EventHalloween_End1";
						type = "End"; id = 1;
					}
					else if (type == "End")
					{
						if (HalloweenMgr.getInstance().HasKey)
						{
							breakChest();
							return;
						}
					}
					var mc:Sprite = ResMgr.getInstance().GetRes(res) as Sprite;
					var imgSrc:ButtonEx;
					if ((type == "End" && id == 1) || (type == "Chest" && id == 2))
					{
						imgSrc = imgKey;
					}
					else
					{
						imgSrc = this["imgRock" + id];
					}
					img.addChild(mc);
					mc.rotationX = 180;
					mc.rotationY = 180;
					mc.x = imgSrc.img.x + 100;
					mc.y = imgSrc.img.y;
					var des:ItemHalloween = _listNode[xClick][yClick];
					
					TweenMax.to(mc, 0.8, 
							{ 
								bezierThrough:[ { x:des.img.x, y:des.img.y + 10} ], 
								orientToBezier:true, 
								ease:Expo.easeOut, onComplete:compTween
							} );
					function compTween():void
					{
						img.removeChild(mc);
						mc = null;
						inTweenAndShiftUnlock = false;
						if (!inWaitUnlockPackage)//dữ liệu server đã sẵn sàng
						{
							breakRock(xClick, yClick, HalloweenMgr.getInstance().getAgent());
						}
						HalloweenMgr.getInstance().breakRock(xClick, yClick, node.Thick == ItemHalloweenInfo.FREEZE);
					}
					
					
				}
			}
			if (_timeShowUserInfo > 0)
			{
				if (curTime - _timeShowUserInfo > 0.5)
				{
					GuiMgr.getInstance().guiUserEventInfo.updateUserData();
					_timeShowUserInfo = -1;
				}
			}
			if (curTime - _timeGui > 1 && !inOverTime)
			{
				if (EventMgr.CheckEvent("Hal2012") != EventMgr.CURRENT_IN_EVENT)//hết event
				{
					inOverTime = true;
				}
				tfTime.text = Ultility.convertToTime(zerohour - int(curTime));
				_timeGui = curTime;
				if (zerohour - int(curTime) < 1)//cho hết trước 1s
				{
					inOverTime = true;
					zerohour += 86400;
					if (!inUnlock)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian khám phá trong ngày", 310, 200, 1);
						Hide();
					}
				}
				
			}
			BuyItemSvc.getInstance().updateTime(curTime);
		}
		
		public function showTrunk(isShow:Boolean):void
		{
			//imgTrunkClose.img.visible = !isShow;
			//imgTrunkOpen.img.visible = isShow;
			_trunk.showTrunk(isShow);
		}
		
		public function processUnlock(oldData:SendUnlockNode, data1:Object):void 
		{
			//thực hiện khởi tạo cho 1 cái quà hoặc ma ở node đó
			HalloweenMgr.getInstance().initAgent(oldData, data1);
			inWaitUnlockPackage = false;
			if (!inTweenAndShiftUnlock)
			{
				breakRock(oldData.X, oldData.Y, HalloweenMgr.getInstance().getAgent());
			}
		}
		
		private function breakRock(x:int, y:int, agent:Array):void
		{
			var node:ItemHalloween = _listNode[x][y];
			var type:String = node.Node.ItemType;
			var id:int = node.Node.ItemId;
			var isTrick:Boolean = node.Node.isTrick;
			var line:Array = [new Point(node.img.x + 25, node.img.y + 24)];//còn lại mỗi vị trí đích cần di chuyển vào
			var ptr:Sprite = this.img;
			node.fTransformComp = function():void//hàm gọi sau khi transform xong
			{
				if (this.Node.Thick == ItemHalloweenInfo.LAND)//nếu vừa phá băng xong
				{
					inUnlock = false;
					if (inOverTime || EventMgr.CheckEvent("Hal2012") != EventMgr.CURRENT_IN_EVENT)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian khám phá trong ngày", 310, 200, 1);
						Hide();
					}
					return;
				}
				/*tạo 1 cái ảnh quà*/
				var gift:AbstractGift;
				if (type != "End" && !isTrick)
				{
					gift = agent[0];
					var spt:SpriteExt = new SpriteExt();
					
					spt.loadComp = function():void
					{
						ptr.addChild(this.img);
						this.img.x = node.img.x;
						this.img.y = node.img.y;
						_actor.move(line, fGetAgent);//cho con cá di chuyển đến nút đích
						function fGetAgent():void//gặp quà hoặc ma tại nút đích
						{
							var str:String;
							node.showAsLand();
							change4LandToBound(x, y);
							HalloweenMgr.getInstance().pScr = new Point(x, y);
							var xSrc:int = 640, ySrc:int = 470;
							if (type == "Chest")
							{
								if (id == 2)
								{
									str = "+1";
								}
								else if (id == 1)//rương thường
								{
									if (gift["ItemType"] == "HalItem" && gift["ItemId"] == 13)
									{
										xSrc = target.img.x + 25;
										ySrc = target.img.y + 24;
									}
									str = "+" + Ultility.StandardNumber(gift["Num"]);
								}
							}
							else
							{
								str = "+" + Ultility.StandardNumber(gift["Num"]);
							}
							var posStart:Point = new Point(node.img.x + 25, node.img.y + 25);
							posStart  = ptr.localToGlobal(posStart);
							var posEnd:Point = new Point(node.img.x + 25, node.img.y + 5);
							posEnd = ptr.localToGlobal(posEnd);
							var fm:TextFormat = new TextFormat("Arial", 16, 0xFFFF00);
							fm.align = "center";
							fm.bold = true;
							Ultility.ShowEffText(str, null, posStart, posEnd, fm);
							if (gift["ItemType"] != "HalItem" || gift["ItemId"] != 13)
							{
								ctnTrunk.SetVisible(false);
								inVibrateTrunk = true;
								EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
																		"GuiHalloween_EffTrunk", null,
																		ctnTrunk.img.x, ctnTrunk.img.y,
																		false, false, null,
																		fCompBlinkTrunk);
								function fCompBlinkTrunk():void
								{
									ctnTrunk.SetVisible(true);
									inVibrateTrunk = false;
									if (inOverTime || EventMgr.CheckEvent("Hal2012") != EventMgr.CURRENT_IN_EVENT)
									{
										if (inUnlock)
										{
											inUnlock = false;
										}
										GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian khám phá trong ngày", 310, 200, 1);
										Hide();
									}
								}
							}
							
							TweenMax.to(spt.img, 0.8, 
										{ 
											bezierThrough:[ { x: xSrc, y: ySrc} ], 
											orientToBezier:true, 
											ease:Expo.easeOut, onComplete:compFlyGift
										} 
								);
							function compFlyGift():void
							{
								if (gift["ItemType"] == "HalItem" && gift["ItemId"] == 13)
								{
									//thay cái ảnh mở khóa
									target.transform();
								}
								else
								{
									_trunk.updateItem(gift);
								}
								
								ptr.removeChild(spt.img);
								spt.img = null; spt = null;
								inUnlock = false;
								if (inOverTime || EventMgr.CheckEvent("Hal2012") != EventMgr.CURRENT_IN_EVENT)
								{
									if (!inVibrateTrunk)
									{
										if (inUnlock)
										{
											inUnlock = false;
										}
										GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian khám phá trong ngày", 310, 200, 1);
										Hide();
									}
								}
							}
						}
					}
					spt.loadRes(gift.getImageName());
				}
				else
				{
					_actor.move(line, fGetAgent2);//cho con cá di chuyển đến nút đích
					function fGetAgent2():void
					{
						node.showAsLand();
						change4LandToBound(x, y);
						HalloweenMgr.getInstance().pScr = new Point(x, y);
						inUnlock = false;
						if (isTrick)
						{
							GuiMgr.getInstance().guiTrickTreat.Show(Constant.GUI_MIN_LAYER, 5);
						}
						else if (type == "End")
						{
							var xEff:int = Constant.STAGE_WIDTH / 2;
							var yEff:int = Constant.STAGE_HEIGHT / 2;
							EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
																	"GuiHalloween_EffFinish", null,
																	xEff, yEff, false, false, null,
																	fCompEffFinish);
							function fCompEffFinish():void
							{
								GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_HALLOWEEN_FINISHMAP);
								GuiMgr.getInstance().guiGiftHalloween.Show(Constant.GUI_MIN_LAYER, 5);
							}
						}
					}
				}
			}
			node.transform();		//biến cái nút đó thành agent => quà hoặc ma
		}
		
		private function change4LandToBound(x:int, y:int):void 
		{
			changeLandToBound(x, y - 1);
			changeLandToBound(x - 1, y);
			changeLandToBound(x, y + 1);
			changeLandToBound(x + 1, y);
		}
		
		private function changeLandToBound(x:int, y:int):void 
		{
			if (x < ItemHalloweenInfo.MAX_X &&
				x >= 0 &&
				y < ItemHalloweenInfo.MAX_Y &&
				y >= 0)
			{
				
				var itemNode:ItemHalloween = _listNode[x][y];
				var node:ItemHalloweenInfo = itemNode.Node;
				if (node.isBound)
				{
					itemNode.showAsBound();
				}
			}
		}
		
		/**
		 * trả về 1 mảng Point chứa những điểm mà cá phải trượt qua
		 * @param	xDes : index cuối
		 * @param	yDes
		 * @return
		 */
		private function findLine(xDes:int, yDes:int, hasNodeDes:Boolean = true):Array 
		{
			/*xScr và yScr lấy trong HalloweenMgr*/
			var line:Array = [];
			var lineIndex:Array = HalloweenMgr.getInstance().findLine(xDes, yDes, hasNodeDes);
			var node:ItemHalloween;
			var pIndex:Point;
			var pos:Point;
			for (var i:int = 0; i < lineIndex.length; i++)
			{
				pos = new Point();
				pIndex = lineIndex[i];
				node = _listNode[pIndex.x][pIndex.y];
				pos = new Point(node.CurPos.x + 25, node.CurPos.y + 24);
				line.push(pos);
			}
			return line;
		}
		
		private function checkUnlockNode(x:int, y:int):Boolean
		{
			var mapInfo:Array = HalloweenMgr.getInstance().getMap();
			var node:ItemHalloweenInfo = mapInfo[x][y];
			var id:int = node.ItemId;
			var type:String = node.ItemType;
			if (node.ItemType == "Chest")
			{
				if (id == 1)
				{
					return true;
				}
				else if (id == 2)//rương thần
				{
					if (HalloweenMgr.getInstance().Key == 0)
					{
						GuiMgr.getInstance().guiBuyKey.Show(Constant.GUI_MIN_LAYER, 5);
						return false;
					}
					HalloweenMgr.getInstance().Key--;
					tfNumKey.text = "x" + Ultility.StandardNumber(HalloweenMgr.getInstance().Key);
					return true;
				}
				else
				{
					return false;
				}
			}
			else if (node.ItemType == "End")
			{
				if (HalloweenMgr.getInstance().HasKey)
				{
					return true;
				}
				if (HalloweenMgr.getInstance().Key == 0)
				{
					GuiMgr.getInstance().guiBuyKey.Show(Constant.GUI_MIN_LAYER, 5);
					return false;
				}
				HalloweenMgr.getInstance().Key--;
				tfNumKey.text = "x" + Ultility.StandardNumber(HalloweenMgr.getInstance().Key);
				return true;
			}
			else
			{
				if (id >= 1 && id <= 12)
				{
					if (HalloweenMgr.getInstance().getRockNum(id) == 0)
					{
						GuiMgr.getInstance().guiBuyRock.Show(Constant.GUI_MIN_LAYER, 5);
						return false;
					}
					HalloweenMgr.getInstance().updateRockStore(id, -1);
					effSubtractRock(id, -1);
					/*hiển thị lại textNum*/
					var tf:TextField = img.getChildByName(CMD_USE_ROCK + "_" + id) as TextField;
					tf.text = "x" + Ultility.StandardNumber(HalloweenMgr.getInstance().getRockNum(id));
					return true;
				}
				else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Là biên nhưng không phải ô đá", 310, 200, 1);
					return false;
				}
			}
		}
		
		public function effSubtractRock(id:int, num:int):void
		{
			/*Effect trừ đá*/
			var imgSrc:ButtonEx = this["imgRock" + id];
			var posStart:Point = new Point(imgSrc.img.x + 25, imgSrc.img.y + 50);
			posStart = img.localToGlobal(posStart);
			var posEnd:Point = new Point(imgSrc.img.x + 25, imgSrc.img.y + 10);
			posEnd = img.localToGlobal(posEnd);
			var fm:TextFormat = new TextFormat("Arial", 16);
			fm.bold = true;
			if (num < 0)
			{
				fm.color = 0xff0000;
			}
			else
			{
				fm.color = 0xffff00;
			}
			fm.align = TextFormatAlign.CENTER;
			Ultility.ShowEffText(num.toString(), null, posStart, posEnd, fm);
		}
		public function refreshAllTextNumRock():void
		{
			var name:String;
			var tf:TextField;
			for (var i:int = 1; i <= 12; i++)
			{
				name = CMD_USE_ROCK + "_" + i;
				tf = img.getChildByName(name) as TextField;
				tf.text = "x" + Ultility.StandardNumber(HalloweenMgr.getInstance().getRockNum(i));
			}
		}
		public function refreshNumKey():void
		{
			tfNumKey.text = "x" + Ultility.StandardNumber(HalloweenMgr.getInstance().Key);
		}
		private function getNodeById(id:String):ItemHalloween
		{
			var item:ItemHalloween;
			var line:Array;
			for (var i:int = 0; i < _listNode.length; i++)
			{
				line = _listNode[i];
				for (var j:int = 0; j < line.length; j++)
				{
					item = line[j];
					if (item.IdObject == id)
					{
						return item;
					}
				}
			}
			return null;
		}
		
		override public function OnHideGUI():void 
		{
			BuyItemSvc.getInstance().sendBuyAction();
			//xóa 1 vài cái content
			if(_actor)
				_actor.Destructor();
			if (_trunk && _trunk.IsVisible)
			{
				_trunk.Hide();
				_trunk = null;
			}
			GuiMgr.getInstance().guiUserEventInfo.Hide();
		}
		
		override public function ClearComponent():void 
		{
			removeAllListNode();
			super.ClearComponent();
		}
		
		/**
		 * xử lý khi thực hiện fail task khi bị ghẹo
		 * @param	data : dữ liệu của các ô bị đóng băng
		 */
		public function processFailTask(data:Object):void 
		{
			
		}
		
		public function processTrickorTreat(oldData:Object, data:Object):void 
		{
			var pk:SendTrickOrTreat = oldData as SendTrickOrTreat;
			inTrickOrTreat = false;
			if (pk.Ans == 1)
			{
				return;
			}
			var i:int;
			var temp:Array;
			var itemNode:ItemHalloween;
			for (i = 0; i < data["Freeze"].length; i++)
			{
				temp = data["Freeze"][i];
				itemNode = _listNode[temp[0]][temp[1]];
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiHalloween_EffFreeze",
														null, itemNode.img.x + 29, itemNode.img.y + 29,
														false, false, null, null);
				itemNode.freeze();
				
			}
		}
		
		private function removeAllListNode():void
		{
			var item:ItemHalloween;
			var i:int, j:int;
			var line:Array;
			for (i = 0; i < _listNode.length; i++)
			{
				line = _listNode[i];
				for (j = 0; j < line.length; j++)
				{
					item = line[j];
					item.Destructor();
					line[j] = null;
				}
				line.splice(0, line.length);
				_listNode[i] = null;
			}
			_listNode.splice(0, _listNode.length);
		}
	}

}


















