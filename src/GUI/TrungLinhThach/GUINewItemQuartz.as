package GUI.TrungLinhThach 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import Event.EventMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.TooltipFormat;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.CometEmit;
	
	import Sound.SoundMgr;
	import com.adobe.serialization.json.JSON;
	
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.GuiMgr;
	import GUI.Event8March.CoralTree;
	
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUINewItemQuartz extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		
		public var buttonClose:Button;
		private var numQuartzSix:int;
		private var itemId:int = 13;
		
		private const colorType:Object = 
		{
			"QWhite":"0x00CCFF", "QGreen":"0x00FF00", "QYellow":"0xFFFF00", "QPurple":"0xCC00FF", "QVIP":"0xE49400"
		};
		
		private const nameStartQuartz:Object = 
		{
			"QWhite":"IcWhiteStar", "QGreen":"IcGreenStar", "QYellow":"IcYellowStar", "QPurple":"IcPurpleStar", "QVIP":"IcVIPStar"
		};
		
		public function GUINewItemQuartz(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				OpenRoomOut();
			}
			LoadRes("GuiTrungLinhThach_BonusQuartzNew"); 
		}
		
		public function showGUI(num:int):void
		{
			numQuartzSix = num;
			isDataReady = false;
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function EndingRoomOut():void 
		{
			isDataReady = true;
			
			super.EndingRoomOut();
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void 
		{
			isDataReady = dataAvailable;
			
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			addContent();
		}
		
		private function addContent():void
		{
			buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 530, -5);
			buttonClose.setTooltipText("Đóng lại");
			
			var curEvent:String = EventMgr.NAME_EVENT;
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			var date:Date = new Date(event[curEvent]["BeginTime"] * 1000);
			var startDate:String = date.getDate() + "/" + (date.getMonth() + 1);
			date = new Date(event[curEvent]["ExpireTime"] * 1000);
			var endDate:String = date.getDate() + "/" + (date.getMonth() + 1);
			
			var fmDay:TextFormat = new TextFormat("Arial", 16, 0xFF0000, true);
			var fmText:TextFormat = new TextFormat("Arial", 16, 0x00FF00, true);
			var txtText:TextField = AddLabel(" đến ngày ", 400, 48, 0x00FF00, 1);
			txtText.setTextFormat(fmText);
			txtText.defaultTextFormat = fmText;
			var txtDay1:TextField = AddLabel(startDate, 343, 48, 0x00FF00, 1);
			txtDay1.setTextFormat(fmDay);
			txtDay1.defaultTextFormat = fmDay;
			var txtDay2:TextField = AddLabel(endDate, 455, 48, 0x00FF00, 1);
			txtDay2.setTextFormat(fmDay);
			txtDay2.defaultTextFormat = fmDay;
			
			var numStar:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")['QVIP'][itemId]["Star"];
			for (var m:int = 0; m < numStar; m++)
			{
				AddImage("", nameStartQuartz['QVIP'], (m - numStar / 2) * 17 + 190, 60);
			}
			
			var glow:GlowFilter = new GlowFilter(0x000000, 1, 4, 4, 10); 
			
			var fm:TextFormat = new TextFormat("Arial", 35, 0xFFFF01, true);
			var txtNumQota:TextField = AddLabel(Ultility.StandardNumber(numQuartzSix), 355, 267, 0xFFFF01);
			txtNumQota.setTextFormat(fm);
			txtNumQota.defaultTextFormat = fm;
			
			var textLevel:TextField;
			textLevel = AddLabel("", 0, 117, 0x000000, 1);
			var fmLevel:TextFormat = new TextFormat("arial", 15, 0xFFFFFF);
			textLevel.defaultTextFormat = fmLevel;
			textLevel.text = 'Cấp 1';
			textLevel.filters = [glow];
			
			var numPoint:Number = 0;
			var totalPoint:Number = ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")['QVIP'][2]["RequirePoint"];;
			var textPoint:TextField;
			textPoint = AddLabel("", 120, 117, 0x000000, 1);
			var fmPoint:TextFormat = new TextFormat("arial", 15, 0xFFFFFF, true, null, null, null, null, "center");
			textPoint.defaultTextFormat = fmPoint;
			textPoint.text = Ultility.StandardNumber(numPoint) + ' / ' + Ultility.StandardNumber(totalPoint);
			textPoint.filters = [glow];
			
			var txt:TextField = AddLabel(Ultility.StandardNumber(1), 7, 17, 0xFFFF00, 1);
			txt.filters = [glow];
			
			var fmTang:TextFormat = new TextFormat("arial", 15, colorType['QVIP'], true, null, null, null, null, "left");
			
			var dataStore:Object = GameLogic.getInstance().user.loadFunctionQuartz(itemId, 'QVIP', 1);
			var numHeightGiua:int = 0;
			var Damage:int = dataStore.Damage;
			if (Damage > 0)
			{
				var numDamage:int = dataStore.OptionDamage;
				numHeightGiua += numDamage;
				for (var i:int = 0; i <  numDamage; i++ )
				{
					var txtNameCong:TextField = AddLabel("Tăng Công: ", 50, 154 + (38*i), 0xFFFFFF, 1);
					txtNameCong.defaultTextFormat = fmTang;
					txtNameCong.filters = [glow];
					var textTangCong:TextField;
					textTangCong = AddLabel("", 150, 154 + (38*i), 0x000000, 1);
					textTangCong.defaultTextFormat = fmTang;
					textTangCong.text = Ultility.StandardNumber(Damage);
					textTangCong.filters = [glow];
				}
			}
			
			var Defence:int = dataStore.Defence;
			if (Defence > 0)
			{
				var numDefence:int = dataStore.OptionDefence;
				for (var j:int = 0; j <  numDefence; j++ )
				{
					var txtNameThu:TextField = AddLabel("Tăng Thủ: ", 50,154 + (38*j) + (38*numHeightGiua), 0xFFFFFF, 1);
					txtNameThu.defaultTextFormat = fmTang;
					txtNameThu.filters = [glow];
					var textTangThu:TextField;
					textTangThu = AddLabel("", 150, 154 + (38*j) + (38*numHeightGiua), 0x000000, 1);
					textTangThu.defaultTextFormat = fmTang;
					textTangThu.text = Ultility.StandardNumber(Defence);
					textTangThu.filters = [glow];
				}
				numHeightGiua += numDefence;
			}
			
			var Critical:int = dataStore.Critical;
			//trace("tip Critical== " + Critical);
			if (Critical > 0)
			{
				var numCritical:int = dataStore.OptionCritical;
				for (var h:int = 0; h <  numCritical; h++ )
				{
					var txtNameMang:TextField = AddLabel("Tăng Chí Mạng: ", 50, 154 + (38*h) + (38*numHeightGiua), 0xFFFFFF, 1);
					txtNameMang.defaultTextFormat = fmTang;
					txtNameMang.filters = [glow];
					var textTangChiMang:TextField;
					textTangChiMang = AddLabel("", 150, 154 + (38*h) + (38*numHeightGiua), 0x000000, 1);
					textTangChiMang.defaultTextFormat = fmTang;
					textTangChiMang.text = Ultility.StandardNumber(Critical);
					textTangChiMang.filters = [glow];
				}
				numHeightGiua += numCritical;
			}
			//trace("tip Critical== " + Critical + " |numCritical== " + numCritical);
			var Vitality:int = dataStore.Vitality;
			if (Vitality > 0)
			{
				var numVitality:int = dataStore.OptionVitality;
				for (var k:int = 0; k < numVitality; k++ )
				{
					var txtNameMau:TextField = AddLabel("Tăng Máu: ", 50, 154 + (38*k) + (38*numHeightGiua), 0xFFFFFF, 1);
					txtNameMau.defaultTextFormat = fmTang;
					txtNameMau.filters = [glow];
					var textTangMau:TextField;
					textTangMau = AddLabel("", 150, 154 + (38*k) + (38*numHeightGiua), 0x000000, 1);
					textTangMau.defaultTextFormat = fmTang;
					textTangMau.text = Ultility.StandardNumber(Vitality);
					textTangMau.filters = [glow];
				}
				numHeightGiua += numVitality;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
			}
		}
		
		override public function OnHideGUI():void 
		{
			//trace("OnHideGUI");
		}
		
	}
}