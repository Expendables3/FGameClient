package GUI 
{
	import com.greensock.loading.core.DisplayObjectLoader;
	import Data.Localization;
	import Data.ResMgr;
	import fl.containers.ScrollPane;
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.events.ScrollEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import Logic.Friend;
	import Logic.GameLogic;
	import Logic.LogInfo;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendGetLog;
	import NetworkPacket.PacketSend.SendRemoveLog;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class GUILog extends BaseGUI
	{
		public static const GUI_LOG_EXIT:String = "BtnExit";
		public static const GUI_LOG_REMOVE:String = "BtnRemove";
		
		private var IsDataReady:Boolean;
		private var LogArr:Array = [];
		private var scp:ScrollPane = new ScrollPane();
		private var content:Sprite = new Sprite();
		
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		public function GUILog(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		private function AddCloseButton():void
		{
			//Add button đóng ở góc trên bên phải
			var bt:Button = AddButton(GUI_LOG_EXIT, "BtnThoat", 418, 19, this);
			//bt.img.scaleX = bt.img.scaleY = 0.75;
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				var cmd1:SendGetLog = new SendGetLog(GameLogic.getInstance().user.Id);
				Exchange.GetInstance().Send(cmd1);
				
				SetPos(180, 60);		
				AddCloseButton();
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				OpenRoomOut();
			}
			
			LoadRes("GuiLog_Theme");
		}
		
		
		
		public function ShowLog(dataAvailable:Boolean = true):void
		{
			IsDataReady = dataAvailable;
			GameLogic.getInstance().BackToIdleGameState();
			//this.Hide();
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public override function  EndingRoomOut():void
		{
			if (IsDataReady)
			{
				RefreshComponent();
			}
		}
		
		public function RefreshComponent(dataAvailable:Boolean = true):void
		{
			IsDataReady = dataAvailable;
			if (!IsDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			//Clear các component trong gui
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			RemoveComponent();
						
			//Add các component của gui
			AddCloseButton();			
			
			scp.move(35, 60);
			//scp.move(100, 100);
			scp.setSize(370, 290);
			content = new Sprite;
			content.graphics.beginFill(0xffffff, 0);
			content.graphics.drawRect(0, 0, 300, 2000);
			content.graphics.endFill();					
						
			var x:int = 0, y:int = 5;
			var friend:Friend;
			var log:LogInfo;
			var user:User = GameLogic.getInstance().user;
			var tf:TextField;
			for (var i:int = 0; i < LogArr.length; i++) 
			{
				log = LogArr[i] as LogInfo;
				//if (ValidateLog(log) == false) continue;
				
				friend = user.GetFriend(log.UserId);
				if (friend == null)
				{
					continue;
				}
				
				x = 3;
				//y = i * 75;
				//add ảnh avatar của bạn bè
				var image:Image = new Image(content, friend.imgName, x, y, false, ALIGN_LEFT_TOP);
				image.SetSize(63, 63);
				
				//add container
				var container:Image = new Image(content, "GuiLog_ImgContainerLog", x + 74, y);
				//container.img.width = 330;
				if (log.ActNumArr.length >= 4) //container nhỏ quá không chứa nổi 4 dòng :D
				{
					container.img.height = (log.ActNumArr.length + 1) * 17; //20 là độ cao của 1 txtField, số dòng = số hành động  + 1 dòng nickname
				}
												
				//thời gian
				var t:Number = GameLogic.getInstance().CurServerTime - log.LastTimeAct;
				var time:String;
				if (t < 3600)
				{
					if (t < 60) t = 60;
					time = Ultility.ConvertTimeToString(t, false, false, true);
				}
				else if (t < 86400)
				{
					time = Ultility.ConvertTimeToString(t, false, true, false);
				}
				else
				{
					time = Ultility.ConvertTimeToString(t, true, false, false);
				}
				tf = AddLabel(time + " trước", x + 77, y, 0x0000ff, 0);
				changeTxtFieldParent(content, tf);
				
				//add nick name của bạn
				x = tf.x + tf.width;
				tf = AddLabel(Ultility.StandardString(friend.NickName, 10), x, y, 0xff0000, 0);
				changeTxtFieldParent(content, tf);
				
				x += tf.width;
				tf = AddLabel("đã sang nhà bạn", x, y, 0x000000, 0);
				changeTxtFieldParent(content, tf);
				
				var y1:int = tf.y;
				for (var j:int = 0; j < log.ActNumArr.length; j++) 
				{
					y1 += 15;					
					var actName:String = Localization.getInstance().getString("Log" + log.ActNumArr[j][ConfigJSON.KEY_ID]).replace("@num", log.ActNumArr[j]["Num"] );
					if (actName != "")
					{
						tf = AddLabel("+ " + actName, container.img.x, y1, 0x000000, 0);	
						changeTxtFieldParent(content, tf);
					}
				}
				
				y += container.img.height + 3;
			}
			
			//Không có log
			if (LogArr.length <= 0)
			{
				var fmt:TextFormat = new TextFormat("Arial", 24, 0x604220, true);
				tf = AddLabel("Không có nhật ký nào được ghi", 45, 170, 0x000000, 0);
				tf.setTextFormat(fmt);
				//changeTxtFieldParent(content, tf);
			}
			else
			{
				if (y > scp.y + scp.height)
				{
					scp.source = content;		
					UpdateConentScrollPane(scp);
					img.addChild(scp);
					scp.addEventListener(ScrollEvent.SCROLL, scroll);	
				}
				else
				{
					img.addChild(content);
					content.x = scp.x;
					content.y = scp.y;
				}
				
			}		
			
			
			//Add buttion xóa
			//var bt:Button = AddButton(GUI_LOG_REMOVE, "ButtonRed", 220, 400, this);
			//bt.img.width = 80;
			//bt.img.height = 30;
			//var tf:TextField = AddLabel("Xóa hết", bt.img.x - 10, bt.img.y - 25);
			AddButton(GUI_LOG_REMOVE, "GuiLog_BtnXoaHet", 175, 355, this);
		}
		
		private function scroll(event:ScrollEvent):void 
		{
		
		}
		
		private function UpdateConentScrollPane(scp:ScrollPane):void
		{
			//scp.scrollDrag = true;			

			
			//scp.setStyle("disabledSkin", new bar());	
			//scp.enabled = false;
			//scp.setStyle("contentPadding", 30);
		
			
			//Thay đổi content background của scrollpane
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 400, 400);
			bg.graphics.endFill();
			scp.setStyle("upSkin", bg);
			
			//Thay đổi content nút lên
			var up:Sprite = ResMgr.getInstance().GetRes("GuiLog_ImgArrowUp") as Sprite;
			scp.setStyle("upArrowUpSkin", up);
			scp.setStyle("upArrowDownSkin", up);
			var over:Sprite = ResMgr.getInstance().GetRes("GuiLog_ImgArrowUp") as Sprite;
			var color:ColorTransform = new ColorTransform(1.8, 1.8, 1.8);
			over.transform.colorTransform = color;
			scp.setStyle("upArrowOverSkin", over);
						
			
			//Thay đổi content nút xuống
			up= ResMgr.getInstance().GetRes("GuiLog_ImgArrowDown") as Sprite;
			scp.setStyle("downArrowUpSkin", up);
			scp.setStyle("downArrowDownSkin", up);
			over= ResMgr.getInstance().GetRes("GuiLog_ImgArrowDown") as Sprite;
			over.transform.colorTransform = color;
			scp.setStyle("downArrowOverSkin", over);
			
			
			//Thay đổi content thanh kéo
			up = ResMgr.getInstance().GetRes("GuiLog_ImgThanhTruot") as Sprite;
			scp.setStyle("thumbUpSkin", up);	
			scp.setStyle("thumbDownSkin", up);	
			over= ResMgr.getInstance().GetRes("GuiLog_ImgThanhTruot") as Sprite;
			over.transform.colorTransform = color;
			scp.setStyle("thumbOverSkin", over);
			
			//Icon trên thanh kéo
			scp.setStyle("thumbIcon", "");
			
			//Thay đổi content track
			up = ResMgr.getInstance().GetRes("GuiLog_BtnKhungKeo") as Sprite;
			scp.setStyle("trackUpSkin", up);		
			scp.setStyle("trackOverSkin", up);		
			scp.setStyle("trackDownSkin", up);		
			
			var newSC:Sprite = new Sprite();
			newSC.addChild(scp.verticalScrollBar);
			scp.addChild(newSC);
			//scp.setSize(350, 419);
			newSC.x = -140;
			newSC.y = 5;
			newSC.scaleX = 1.4;
		}
		
		public function setInfo(data:Object):void
		{
			LogArr = new Array;
			var log:LogInfo;
			for (var i:String in data.AllHistory) 
			{
				log = new LogInfo();
				log.UserId = data.AllHistory[i].FriendId;
				log.LastTimeAct = data.AllHistory[i].Time;
				log.ActNumArr = data.AllHistory[i].Log.slice();
				LogArr.push(log);
			}
			LogArr.sortOn("LastTimeAct", Array.DESCENDING | Array.NUMERIC);
		}
		
		public function ValidateLog(log:LogInfo):Boolean
		{
			var count:int = 0;
			for (var j:int = 0; j < log.ActNumArr.length; j++) 
			{
				if(ConfigJSON.KEY_ID in log.ActNumArr[j] && "Num" in log.ActNumArr[j])
				{
					count++;
				}
			}		
			
			if (count > 0) return true;
			return false
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_LOG_EXIT:
					this.Hide();
					break;
				case GUI_LOG_REMOVE:
					//Gui goi tin
					if (LogArr.length > 0)
					{
						var cmd:SendRemoveLog = new SendRemoveLog();
						Exchange.GetInstance().Send(cmd);
					}
				
					//Xoa nhat ki
					LogArr.splice(0, LogArr.length);
					RefreshComponent();				
					break;
				default:					
					break;
			}
		}
		
		private function changeTxtFieldParent(newParent:Sprite, txtField:TextField):void
		{
			img.removeChild(txtField);
			LabelArr.splice(LabelArr.indexOf(txtField), 1);
			newParent.addChild(txtField);
		}
		
		private function RemoveComponent():void
		{
			ClearComponent();
			if (scp != null && img.contains(scp))
			{
				img.removeChild(scp);
			}
			if (img.contains(content))
			{
				img.removeChild(content);
			}
		}
	}

}