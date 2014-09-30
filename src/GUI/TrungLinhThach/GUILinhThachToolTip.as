package GUI.TrungLinhThach 
{
	import com.adobe.images.BitString;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.GUIToolTip;
	import GUI.component.Image;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.component.ProgressBar;
	import Logic.GameLogic;
	import Logic.Ultility;
	import flash.filters.GlowFilter;
	import Data.ConfigJSON;
	
	/**
	 * GUI thông tin của trang bị (kiểu như tooltip)
	 * @author ThanhNT2
	 */
	public class GUILinhThachToolTip extends GUIToolTip 
	{
		private const IMG_GIFT:String = "ImgGift_";
		private const STATE_LOCK:int = 0;
		private const STATE_UNLOCK:int = 1;
		
		private var posParent:Point = new Point();
		private var sizePX:Number;
		private var sizePY:Number;
		private var sizeX:Number;
		private var sizeY:Number;
		
		private var arrImageGift:Array = [];
		private var arrItemGift:Array = [];
		private var arrStateLockGift:Array = [];
		private var IdSea:int = -1;
		
		private var objData:Object = null;
		private var prgLevel:ProgressBar;
		private var bg_giua:Image;
		private var bg_cuoi:Image;
		
		private const nameType:Object = 
		{
			"QWhite":"Thường", "QGreen":"Đặc biệt", "QYellow":"Quý", "QPurple":"Thần", "QVIP":"VIP"
		};
		
		private const colorType:Object = 
		{
			"QWhite":"0x00CCFF", "QGreen":"0x00FF00", "QYellow":"0xFFFF00", "QPurple":"0xCC00FF", "QVIP":"0xE49400"
		};
		
		private const nameQuartz:Object = 
		{
			"1":"Huy Hiệu Dũng Mãnh", "2":"Huy Hiệu Phi Phàm", "3":"Huy Hiệu Sức Mạnh", "4":"Huy Hiệu Khổng Tước", "5":"Huy Hiệu Chiến Tranh", 
			"6":"Huy Hiệu Thần Vệ", "7":"Huy Hiệu Thần Linh", "8":"Huy Hiệu Biển Cả", "9":"Huy Hiệu Song Ngư", "10":"Huy Hiệu Thánh Ngư", 
			"11":"Huy Hiệu Mãng Xà", "12":"Huy Hiệu Hải Tặc", "13":"Huy Hiệu Hải Mã"
		};
		
		private const maxLevl:Object = 
		{
			"QWhite":"5", "QGreen":"10", "QYellow":"15", "QPurple":"20", "QVIP":"20"
		};
		
		private const nameStartQuartz:Object = 
		{
			"QWhite":"IcWhiteStar", "QGreen":"IcGreenStar", "QYellow":"IcYellowStar", "QPurple":"IcPurpleStar", "QVIP":"IcVIPStar"
		};
		
		public function GUILinhThachToolTip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			this.ClassName = "GUILinhThachToolTip";
		};
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("bg_dau_trang");
			
			ClearComponent();
			//linhThach.SetScaleXY(0.6);
			var data:Object = objData;
			loadContentBonus();
			
			getPosGui(getTypeBg());
			SetPos(posToolTipX, posToolTipY);
		}
		
		/**
		 * 
		 * @param	Data		:	Dữ liệu đã nhập vào như gui trước, có chứa danh sách các item
		 * @param	pos			:	vị trí của cha
		 * @param	sizeParentX	:	kích thước chiều rộng của cha
		 * @param	sizeParentY	:	Kích thước chiều đài của cha
		 */
		public function Init(Data:Object):void 
		{
			objData = null;
			objData = new Object();
			objData = Data;
		}
		
		private function loadContentBonus():void
		{
			var numHeightGiua:int = 0;
			bg_giua = AddImage("", "bg_giua_trang", 139, 222);
			bg_cuoi = AddImage("", "bg_cuoi_trang", 139, bg_giua.img.y + bg_giua.img.height + 10);
			
			var imageNen:Image  = AddImage("", "Bg_Item_" + objData.Type, 54, 49);
			imageNen.img.cacheAsBitmap = false;
			
			var numStar:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[objData.Type][objData.ItemId]["Star"];
			for (var m:int = 0; m < numStar; m++)
			{
				AddImage("", nameStartQuartz[objData.Type], (m - numStar / 2) * 17 + 190, 60);
			}
			
			/*if (objData.ItemId > 4)
			{
				objData.ItemId = 0;
			}*/
			var imagName:String = objData.Type + objData.ItemId;
			var tF:TextFormat = new TextFormat();
			var imag1:Image = AddImage(objData.Id, imagName, 56, 58);
			
			var glow:GlowFilter = new GlowFilter(0x000000, 1, 4, 4, 10); 
			var txt:TextField = AddLabel(Ultility.StandardNumber(objData.Level), 5, 5, 0xFFFF00, 1);
			txt.filters = [glow];
					
			var textName:TextField;
			textName = AddLabel("", 130, 10, 0x000000, 1);
			var fmName:TextFormat = new TextFormat("arial", 17, colorType[objData.Type]);
			textName.defaultTextFormat = fmName;
			textName.text = nameQuartz[objData.ItemId];
			textName.filters = [glow];
			
			var textType:TextField;
			textType = AddLabel("", 130, 70, 0x000000, 1);
			var fmType:TextFormat = new TextFormat("arial", 15, 0xFFFFFF);
			textType.defaultTextFormat = fmType;
			textType.text = "[ " + nameType[objData.Type] + " ]";
			textType.filters = [glow];
			
			//trace("data===== " + nameType[objData.Type]);
			
			var textLevel:TextField;
			textLevel = AddLabel("", -5, 110, 0x000000, 1);
			var fmLevel:TextFormat = new TextFormat("arial", 15, 0xFFFFFF);
			textLevel.defaultTextFormat = fmLevel;
			textLevel.text = 'Cấp ' + objData.Level;
			textLevel.filters = [glow];
			
			var numPoint:Number = objData.Point;// ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[objData.Type][objData.Level]["Point"];
			var totalPoint:Number = 0;
			var max:int = maxLevl[objData.Type];
			if (objData.Level == max)
			{
				//totalPoint = ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[objData.Type][objData.Level]["RequirePoint"];
				numPoint = 0;
				totalPoint = 1;
			}
			else
			{
				totalPoint = ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[objData.Type][objData.Level + 1]["RequirePoint"];
			}
			prgLevel = AddProgress("", "progessLevelLinhThach", 75, 111, this);
			prgLevel.setStatus(numPoint / totalPoint);
			
			var textPoint:TextField;
			textPoint = AddLabel("", 110, 110, 0x000000, 1);
			var fmPoint:TextFormat = new TextFormat("arial", 15, 0xFFFFFF, true, null, null, null, null, "center");
			textPoint.defaultTextFormat = fmPoint;
			if (objData.Level == max)
			{
				numPoint = 0;
				totalPoint = 0;
			}
			textPoint.text = Ultility.StandardNumber(numPoint) + ' / ' + Ultility.StandardNumber(totalPoint);
			textPoint.filters = [glow];
			
			var fmTang:TextFormat = new TextFormat("arial", 15, colorType[objData.Type], true, null, null, null, null, "left");
			
			var dataStore:Object = GameLogic.getInstance().user.loadFunctionQuartz(objData.ItemId, objData.Type, objData.Level);
			
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
			//trace("numHeightGiua== " + numHeightGiua);
			bg_giua.img.height = 38 * numHeightGiua;
			bg_cuoi.img.y = bg_giua.img.y + bg_giua.img.height - 2;
		}
		
		override public function OnHideGUI():void 
		{
			ClearComponent();
		}
	}

}