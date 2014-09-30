package GUI.EventBirthDay.EventGUI 
{
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.EventBirthDay.EventLogic.MagicLampItemInfo;
	import GUI.EventBirthDay.EventLogic.MagicLampMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIMagicLamp extends BaseGUI 
	{
		// const
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		static public const CMD_WISH:String = "cmdWish";
		static public const ID_PRG_WISHINGPOINT:String = "idPrgWishingpoint";
		
		// gui
		private var btnClose:Button;
		private var lstItemWish:Array=[];
		private var prgWishPoint:ProgressBar;
		private var canInteract:Boolean = true;
		public function GUIMagicLamp(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIMagicLamp";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				addTienCa(checkCookie());
				addBgr();
				addAllItem();
				initProgressWishingPoint();
			}
			LoadRes("GuiMagicLamp_Theme");
			
		}
		
		private function addTienCa(showTienCa:Boolean):void 
		{
			if (showTienCa)
			{
				//xử lý add con tiên cá phụt ra
				var pos:Point = new Point(59, 53);
				pos = img.localToGlobal(pos);
				canInteract = false;
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiMagicLamp_TienCaHidden", null,
														pos.x, pos.y,
														false, false, null, onCompHidden);
				function onCompHidden():void
				{
					canInteract = true;
					AddImage("", "GuiMagicLamp_TienCa", 273, 671);
				}
			}
			else
			{
				canInteract = true;
				AddImage("", "GuiMagicLamp_TienCa", 273, 671);
			}
		}
		
		private function initProgressWishingPoint():void 
		{
			var level:int = MagicLampMgr.getInstance().LevelWish;
			AddImage("", "GuiMagicLamp_No" + level, 240, 471);
			prgWishPoint = AddProgress(ID_PRG_WISHINGPOINT, "GuiMagicLamp_PrgWishingPoint", 272, 458, this, true);
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Điểm ước muốn";
			prgWishPoint.setTooltip(tip);
			var curWishingPoint:int = MagicLampMgr.getInstance().WP;
			var maxWishingPoint:int = MagicLampMgr.getInstance().MaxWP;
			prgWishPoint.setStatus(curWishingPoint / maxWishingPoint);
			var str:String = Ultility.StandardNumber(curWishingPoint) + " / " + 
								Ultility.StandardNumber(maxWishingPoint);
			var tf:TextField = AddLabel(str, 370, 462, 0xffffff, 1, 0x000000);//0x1F4872
			tf.scaleX = tf.scaleY = 1.4;
		}
		
		private function addAllItem():void 
		{
			var length:int = MagicLampMgr.getInstance().NumItem;
			for (var i:int = 0; i < length; i++)
			{
				var item:MagicLampItemInfo = MagicLampMgr.getInstance().getItemByIndex(i);
				addItem(item);
			}
		}
		
		private function addItem(item:MagicLampItemInfo):void 
		{
			var itemMagicLamp:ItemMagicLamp = new ItemMagicLamp(this.img, "KhungFriend");
			itemMagicLamp.initData(item, this);
			itemMagicLamp.drawItem();
			lstItemWish.push(itemMagicLamp);
		}
		
		private function addBgr():void 
		{
			btnClose = AddButton(ID_BTN_CLOSE, "BtnThoat", 706, 17);
			var tf:TextField = AddLabel("Lưu ý: Thần đèn sẽ reset điểm ước muốn khi qua ngày", 322, 529, 0xffffff, 1, 0x000000);
			var fm:TextFormat = new TextFormat();
			fm.color = 0xff0000;
			tf.setTextFormat(fm, 0, 6);
			tf.scaleX = tf.scaleY = 1.2;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (!canInteract)
			{
				return;
			}
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
			}
		}
		
		/*giải phóng phần tử chưa được giải phóng*/
		private function removeListItemWish():void
		{
			for (var i:int = 0; i < lstItemWish.length; i++)
			{
				var it:ItemMagicLamp = lstItemWish[i] as ItemMagicLamp;
				it.Destructor();
				it = null;
			}
			lstItemWish.splice(0, lstItemWish.length);
		}
		
		override public function Clear():void 
		{
			removeListItemWish();
			super.Clear();
		}
		
		/**
		 * 
		 * @return: true nếu mở gui lần đầu tiên trong ngày, false nếu đã mở gui 1 lần trong ngày
		 */
		private function checkCookie():Boolean
		{
			var id:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + 
								date.getMonth().toString() + 
								date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("GuiMagicLamp" + id);
			var data:Object;
			if (so.data.uId != null)//đã mở gui 1 lần trong đời
			{
				data = so.data.uId;
				if (data.lastday != today)//hôm nay chưa mở gui
				{
					data.lastday = today;//cập nhật vào shareobject
					return true;
				}
				else//hôm nay đã mở gui
				{
					return false;
				}
			}
			else//chưa feed lần nào trong đời
			{
				data = new Object();
				so.data.uId = data;
				data.lastday = today;
				return true;
			}
		}
	}

}

































