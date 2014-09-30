package GUI.BossServer 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIListBoss extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var dataRoom:Object;
		private var isLoadComplete:Boolean;
		public var curRoom:int;
		private var totalJudgedPoint:int;
		private var prgTime:ProgressBar;
		private var labelCurTime:TextField;
		private var arrTimeStone:Array;
		private var labelMessage:TextField;
		private var hasRoomInfo:Boolean;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_MONSTER:String = "btnMonster";
		static public const TIME_STONE:String = "timeStone";
		public var roomGift:int;
		
		public function GUIListBoss(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				isLoadComplete = true;
				hasRoomInfo = false;
				SetPos(125, 30);
				AddButton(BTN_CLOSE, "BtnThoat", 543, 22);
				WaitData.x = img.width / 2;
				WaitData.y = img.height / 2;
				img.addChild(WaitData);
				
				//Mốc time
				labelMessage = AddLabel("", 20 + 215, 50 + 104, 0xffffff, 1, 0x000000);
				prgTime = AddProgress("", "GuiListBossServer_TimeBar", 195, 120);
				var configJoinTime:Object = ConfigJSON.getInstance().GetItemList("Param")["ServerBoss"]["JoinTime"];
				var curTime:Date = new Date();
				curTime.setTime((GameLogic.getInstance().CurServerTime  + 7 * 3600) * 1000);
				prgTime.setStatus((curTime.hoursUTC * 3600 + curTime.minutesUTC * 60 + curTime.secondsUTC) / (24 * 3600));
				var txtFormat:TextFormat = new TextFormat("arial", 17, 0xffffff, true);
				labelCurTime = AddLabel(curTime.hoursUTC + ":" + curTime.minutesUTC + ":" + curTime.secondsUTC, 105, 117, 0xffff00, 1, 0x000000);
				labelCurTime.defaultTextFormat = txtFormat;
				labelCurTime.setTextFormat(txtFormat);
				arrTimeStone = new Array();
				var date:Date;
				for (var s:String in configJoinTime)
				{
					var beginTime:String = configJoinTime[s]["BeginTime"];
					var arr:Array = beginTime.split("-");
					date = new Date();
					date.setTime(curTime.time);
					date.hoursUTC = arr[0];
					date.minutesUTC = arr[1];
					date.secondsUTC = arr[2];
					arrTimeStone.push(date);
				}
				
				for each(date in arrTimeStone)
				{
					var percent:Number;
					percent = (date.hoursUTC * 3600 + date.minutesUTC * 60 + date.secondsUTC) / (24 * 3600);
					var timeColor:String;
					if (date.hoursUTC == curTime.hoursUTC)
					{
						timeColor = "GuiListBossServer_TimeStoneYellow"
					}
					else if (date.hoursUTC < curTime.hoursUTC)
					{
						timeColor = "GuiListBossServer_TimeStoneGreen";
						
					}
					else
					{
						timeColor = "GuiListBossServer_TimeStoneWhite";
					}
					AddImage(TIME_STONE + date.hoursUTC, timeColor, percent * prgTime.width + 200, 118);
					AddLabel(date.hoursUTC + "h", percent * prgTime.width + 150, 102);
				}
				
				for (var i:int = 1; i <= 3; i++)
				{
					var btnMonster:Button = AddButton(BTN_MONSTER + "_" + i, "GuiListBossServer_BtnJoin", i * 173 - 117, 350 + 136);
					btnMonster.SetEnable(false);
					btnMonster.img.scaleX = btnMonster.img.scaleY = 0.7;
					
					var material:Container = AddContainer("", "Material" + (9 + i), i * 173 + 40, 300 + 136);
					material.FitRect(35, 35, new Point( i * 172 -122, 308 + 136));
					material.setTooltipText("Ngư thạch cấp " + (9 + i));
					var rankBottle:Container = AddContainer("", "RankPointBottle3", i * 173 + 80, 300 + 136);
					rankBottle.FitRect(35, 35, new Point(i * 172 -122 + 49, 308 + 136));
					rankBottle.setTooltipText("Bình chiến công");
					var trunk:Container = AddContainer("", "AllChest4_AllChest", i * 173 + 120, 300 + 136);
					trunk.FitRect(35, 35, new Point( i * 172 - 122 + 98, 310 + 136));
					trunk.setTooltipText("Trang bị cấp " + (i+1));
					AddImage("", "ImgLaMa" + (i+1),  i * 173 - 120 + 96+36, 343 + 136).SetScaleXY(0.7);
				}
				
				var arrSoldier:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
				totalJudgedPoint = 0;
				for each( var soldier:FishSoldier in arrSoldier)
				{
					if(soldier.Status != FishSoldier.STATUS_REVIVE)
					{
						totalJudgedPoint += soldier.getJudgedPoint();
					}
				}
				var labelJudgedP:TextField = AddLabel(Ultility.StandardNumber(totalJudgedPoint), 300 - 53, 90 + 136, 0xffffff, 1, 0x000000);
				txtFormat = new TextFormat("arial", 18, 0xffe052, true);
				txtFormat.align = "center";
				labelJudgedP.setTextFormat(txtFormat);
				
				var ctn:Container = AddContainer("", "", 250, 220);
				ctn.LoadRes("");
				ctn.img.graphics.beginFill(0xff0000, 0);
				ctn.img.graphics.drawRect(0, 0, 140, 35);
				ctn.img.graphics.endFill();
				ctn.setTooltipText("Công + Thủ + Chí Mạng + Máu/3");
				
				var config:Object = ConfigJSON.getInstance().GetItemList("ServerBossInfo");
				AddLabel(Ultility.StandardNumber(config[1]["DamageRequire"]) + " - " + Ultility.StandardNumber(config[2]["DamageRequire"] - 1), 70, 260 + 136, 0xffe052, 1, 0x000000).setTextFormat(txtFormat);
				txtFormat.size = 13;
				AddLabel(Ultility.StandardNumber(config[2]["DamageRequire"]) + " - " + Ultility.StandardNumber(config[3]["DamageRequire"] - 1), 70 + 183, 263 + 136, 0xffe052, 1, 0x000000).setTextFormat(txtFormat);
				txtFormat.size = 18;
				AddLabel(">" + Ultility.StandardNumber(config[3]["DamageRequire"] - 1), 70 + 2 * 173, 260 + 136, 0xdf9b00, 1, 0x000000).setTextFormat(txtFormat);
				
				for (i = 1; i < 4; i++)
				{
					txtFormat.size = 13;
					AddLabel(Localization.getInstance().getString("BossServer" + i), i * 173 - 105, 145 + 136, 0xffe052, 1, 0x000000).setTextFormat(txtFormat);
				}
				
				if (dataRoom != null)
				{
					updateRoomInfo(dataRoom);
				}
			}
			isLoadComplete = false;
			Exchange.GetInstance().Send(new SendGetRoomInfo());
			LoadRes("GuiListBossServer_Theme");
		}
		
		public function updateRoomInfo(_data:Object):void
		{
			dataRoom = _data;
			//trace(_data);
			curRoom = dataRoom["RoomInfo"];
			if (isLoadComplete)
			{
				WaitData.visible = false;
				if (checkTime())
				{
					hasRoomInfo = true;
					var config:Object = ConfigJSON.getInstance().GetItemList("ServerBossInfo");
					if (totalJudgedPoint >= config[3]["DamageRequire"])
					{
						GetButton(BTN_MONSTER + "_3").SetEnable(true);
						GetButton(BTN_MONSTER + "_3").setTooltip(null);
					}
					else
					if (totalJudgedPoint >= config[2]["DamageRequire"])
					{
						GetButton(BTN_MONSTER + "_2").SetEnable(true);
						GetButton(BTN_MONSTER + "_2").setTooltip(null);
					}
					else if(totalJudgedPoint >= config[1]["DamageRequire"])
					{
						GetButton(BTN_MONSTER + "_1").SetEnable(true);
						GetButton(BTN_MONSTER + "_1").setTooltip(null);
					}
					
					for (var s:String in dataRoom["BossList"])
					{
						if (dataRoom["BossList"][s] != null && Number(dataRoom["BossList"][s] <= 0))
						{
							GetButton(BTN_MONSTER + "_" + s).SetEnable(false);
							GetButton(BTN_MONSTER + "_" + s).setTooltipText("Boss đã chết bạn quay\nlại vào lượt sau nhé");
							AddImage("", "GuiListBossServer_DiedSign", int(s) * 172-45, 226 + 136);
						}
					}
					labelMessage.text = "Thủy Quái đang đánh phá Thủy Cung";
				}
				else
				{
					GetButton(BTN_MONSTER + "_1").setTooltipText("Chưa đến thời gian Thủy Quái xuât hiện");
					GetButton(BTN_MONSTER + "_2").setTooltipText("Chưa đến thời gian Thủy Quái xuât hiện");
					GetButton(BTN_MONSTER + "_3").setTooltipText("Chưa đến thời gian Thủy Quái xuât hiện");
					var curTime:Date = new Date();
					curTime.setTime((GameLogic.getInstance().CurServerTime  + 7 * 3600) * 1000);
					if (curTime.hoursUTC >= arrTimeStone[0].hoursUTC && curTime.hoursUTC <= arrTimeStone[1].hoursUTC)
					{
						labelMessage.text = "Thủy Quái sẽ xuât hiện vào lúc " + arrTimeStone[1].hoursUTC + "h";
					}
					else
					if (curTime.hoursUTC >= arrTimeStone[1].hoursUTC && curTime.hoursUTC <= arrTimeStone[0].hoursUTC)
					{
						labelMessage.text = "Thủy Quái sẽ xuât hiện vào lúc " + arrTimeStone[0].hoursUTC + "h";
					}
					else if (arrTimeStone[0].hoursUTC > arrTimeStone[1].hoursUTC)
					{
						labelMessage.text = "Thủy Quái sẽ xuât hiện vào lúc " + arrTimeStone[1].hoursUTC + "h";
					}
					else
					{
						labelMessage.text = "Thủy Quái sẽ xuât hiện vào lúc " + arrTimeStone[0].hoursUTC + "h";
					}
				}
			}
			if(dataRoom["GiftList"] != null)
			{
				roomGift = dataRoom["RoomGift"];
				var position:int;
				if (dataRoom["UserInfo"] != null)
				{
					position = dataRoom["UserInfo"]["Position"];
				}
				GuiMgr.getInstance().guiGiftBossServer.showGUI(dataRoom["GiftList"], false, position);
			}
		}
		
		override public function OnHideGUI():void 
		{
			dataRoom = null;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				default:
					if (buttonID.search(BTN_MONSTER) >= 0)
					{
						var i:int = buttonID.split("_")[1];
						//trace(i);
						if (i != curRoom && curRoom != 0)
						{
							GuiMgr.getInstance().guiConfirm.showGUI("Tham gia cửa Boss mới sẽ không nhận được phần thưởng của cửa Boss cũ, bạn có chắc chắn không?"
							, function f():void
							{
								Exchange.GetInstance().Send(new SendJoinRoom(i));
								GameController.getInstance().gotoMode(GameController.GAME_MODE_BOSS_SERVER);
								GuiMgr.getInstance().guiMainBossServer.showGUI(i);
								curRoom = i;
							});
						}
						else
						{
							Exchange.GetInstance().Send(new SendJoinRoom(i));
							GameController.getInstance().gotoMode(GameController.GAME_MODE_BOSS_SERVER);
							GuiMgr.getInstance().guiMainBossServer.showGUI(i);
							curRoom = i;
						}
					}
			}
		}
		
		override public function UpdateObject():void 
		{
			var curTime:Date = new Date();
			curTime.setTime((GameLogic.getInstance().CurServerTime  + 7 * 3600) * 1000);
			prgTime.setStatus((curTime.hoursUTC * 3600 + curTime.minutesUTC * 60 + curTime.secondsUTC) / (24 * 3600));
			var hour:String =  (curTime.hoursUTC > 9) ? curTime.hoursUTC.toString() : ("0" + curTime.hoursUTC);
			var minute:String =  (curTime.minutesUTC > 9) ? curTime.minutesUTC.toString() : ("0" + curTime.minutesUTC);
			var second:String = (curTime.secondsUTC > 9) ? curTime.secondsUTC.toString() : ("0" + curTime.secondsUTC);
			labelCurTime.text = hour + ":" + minute + ":" + second;
			
			if (isLoadComplete && checkTime() && !hasRoomInfo)
			{
				Exchange.GetInstance().Send(new SendGetRoomInfo());
				WaitData.visible = true;
				hasRoomInfo = true;
				var oldIndex:int = img.getChildIndex(GetImage(TIME_STONE + curTime.hoursUTC).img);
				GetImage(TIME_STONE + curTime.hoursUTC).LoadRes("GuiListBossServer_TimeStoneYellow");
				img.setChildIndex(GetImage(TIME_STONE + curTime.hoursUTC).img, oldIndex);
			}
			else if(!checkTime())
			{
				for (var i:int = 1; i < 4; i++)
				{
					GetButton(BTN_MONSTER + "_" + i).SetEnable(false);
					GetButton(BTN_MONSTER + "_" + i).setTooltipText("Chưa đến thời gian Thủy Quái xuất hiện");
				}
			}
		}
		
		private function checkTime():Boolean
		{
			var curTime:Date = new Date();
			curTime.setTime((GameLogic.getInstance().CurServerTime  + 7 * 3600) * 1000);
			for each(var date:Date in arrTimeStone)
			{
				var expriteDate:Date = new Date();
				expriteDate.setTime(date.time);
				expriteDate.hoursUTC += 1;
				if (curTime.time >= date.time && curTime.time <= expriteDate.time)
				{
					return true;
				}
			}
			return false;
		}
		
	}

}