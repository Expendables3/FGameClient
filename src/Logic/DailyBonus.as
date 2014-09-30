package Logic 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.ActiveTooltip;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import NetworkPacket.PacketSend.GetDailyFriendBonus;
	/**
	 * ...
	 * @author 
	 */
	public class DailyBonus extends BaseObject 
	{
		public static const DAILY_BONUS:String = "DailyBonus";	
		
		public static const SUCCESS:String = "success";					
		public static const IS_FULL:String = "isFullEnergy";			// đang đầy năng lượng thì thôi
		public static const NOT_ACTIVED:String = "isNotActived";		// chưa hết 24h hoặc gia chủ chưa active
		public static const IS_CLICKED:String = "isClicked";			// đã nhận quà của hàng xóm này
		public static const IS_COLLECT_MAX:String = "isCollectMax";		// đã nhận đủ số bonus trong ngày
		
		public static const NAME_ACTIVED:String = "BottleFull";
		public static const NAME_DEACTIVED:String = "BottleNone";
		
		public var arrow:Image = null;		// mũi tên để trỏ xuống cái chai
		public var energy:int;				// lượng energy trong chai
		
		public function DailyBonus(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			this.ClassName = DAILY_BONUS;
			MakeArrow();
		}
		
		public static function CheckUser():String
		{
			var currentTime:Number = GameLogic.getInstance().CurServerTime;
			var user:User = GameLogic.getInstance().user;
			var oneDay:int = 24 * 60 * 60;
			var maxCollect:int = ConfigJSON.getInstance().getConstantInfo("pa_28");
			// check 24h
			if (user.IsViewer())			
			{
				// nếu ở nhà hàng xóm mà cái chai quá 1 ngày chưa đc click thì nghỉ
				if (currentTime - user.EnergyBoxTime > oneDay)
				{
					return NOT_ACTIVED;
				}	
				
				var arr:Array = GameLogic.getInstance().user.GetMyInfo().EnergyBox;
				
				// check số bonus đã nhận từ hàng xóm trong ngày
				if (arr.length >= maxCollect)
				{
					return IS_COLLECT_MAX;
				}
				
				// check clicked
				for (var i:int = 0; i < arr.length; i++)
				{
					if (user.Id == arr[i])				
					{
						return IS_CLICKED;
					}
				}
				//if (GameLogic.getInstance().user.GetMyInfo().bonusMachine > 0)
				//{
					//return IS_FULL;
				//}
			}
			else
			{
				// nếu ở nhà mình mà cái chai đã được click trong ngày thì cũng nghỉ luôn
				if (currentTime - user.EnergyBoxTime < oneDay)
				{
					return IS_CLICKED;
				}
				
				// Check full năng lượng
				GameLogic.getInstance().user.UpdateEnergyOntime();
				var curEnergy:int = user.GetEnergy();
				var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
				var Param:Object = ConfigJSON.getInstance().GetItemList("Param");
				var numBonus:int;
				if (user.IsViewer()) numBonus = ConfigJSON.getInstance().getConstantInfo("pa_27");
				else numBonus = ConfigJSON.getInstance().getConstantInfo("pa_26");				
				if (curEnergy + numBonus > maxEnergy)
				{					
					return IS_FULL;
				}
			}
			
			return SUCCESS;
		}
		
		public override function OnMouseOver(event:MouseEvent):void
		{
			var mc:MovieClip = img as MovieClip;
			mc.stop();
			SetHighLight(0x990099);
		}
		
		public override function OnMouseOut(event:MouseEvent):void
		{
			var mc:MovieClip = img as MovieClip;
			mc.play();
			SetHighLight(-1);
		}
		
		public override function OnMouseClick(event:MouseEvent):void
		{
			var st:String;
			var tooltip:TooltipFormat = new TooltipFormat();
			
			switch (CheckUser())
			{
				case NOT_ACTIVED:
				{
					tooltip.text = "Hàng xóm quên chưa thu hoạch rồi.\nHãy nhắc bạn ý đã nào";
					ActiveTooltip.getInstance().showNewToolTip(tooltip, this.img);
					ActiveTooltip.getInstance().setCountDownHide(20);
					ActiveTooltip.getInstance().setCountShow(1);
					break;
				}
				case IS_CLICKED:
				{
					var user:User = GameLogic.getInstance().user;
					if (!user.IsViewer())
					{						
						var currentTime:Number = GameLogic.getInstance().CurServerTime;
						var remainTime:Number = 24 * 3600 - (currentTime - user.EnergyBoxTime);
						var h:int = remainTime / 3600;
						var m:int = Math.ceil((remainTime - h * 3600) / 60);						
						tooltip.text = "hồi phục: " + h + " giờ " + m + " phút";
						ActiveTooltip.getInstance().showNewToolTip(tooltip, this.img);
						ActiveTooltip.getInstance().setCountDownHide(20);
						ActiveTooltip.getInstance().setCountShow(1);
					}
					else
					{
						tooltip.text = "Bạn đã thu hoạch rồi mà.\nHãy quay lai sau nhé!";
						ActiveTooltip.getInstance().showNewToolTip(tooltip, this.img);
						ActiveTooltip.getInstance().setCountDownHide(20);
						ActiveTooltip.getInstance().setCountShow(1);
					}
					break;
				}
				case IS_COLLECT_MAX:
				{
					//st = "Hôm nay bạn đã cá kiếm rất nhiều rồi";
					//GuiMgr.getInstance().GuiMessageBox.ShowOK(st, 310, 200, false);
					tooltip.text = "Hôm nay bạn đã\nnhận đủ năng lượng rồi.\nMai nhớ quay lại nhé";
					ActiveTooltip.getInstance().showNewToolTip(tooltip, this.img);
					ActiveTooltip.getInstance().setCountDownHide(20);
					ActiveTooltip.getInstance().setCountShow(1);
					break;
				}
				case IS_FULL:
				{
					tooltip.text = "Bạn đang có nhiều năng lượng mà.\nHãy dùng bớt đi nào!";
					ActiveTooltip.getInstance().showNewToolTip(tooltip, this.img);
					ActiveTooltip.getInstance().setCountDownHide(20);
					ActiveTooltip.getInstance().setCountShow(1);
					break;
				}
				case SUCCESS:
				{
					CollectBonus();
					break;
				}
			}
		}
		
		public function CollectBonus():void
		{			
			var user:User = GameLogic.getInstance().user;
			var curEnergy:int = user.GetEnergy();
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
			var numBonus:int;
			if (user.IsViewer())
				numBonus = ConfigJSON.getInstance().getConstantInfo("pa_27");
			else
				numBonus = ConfigJSON.getInstance().getConstantInfo("pa_26");
			
			if (GameLogic.getInstance().user.GetMyInfo().bonusMachine > 0)
			{
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = "Bạn đang có nhiều năng lượng mà.\nHãy dùng bớt đi nào!";
				ActiveTooltip.getInstance().showNewToolTip(tooltip, this.img);
				ActiveTooltip.getInstance().setCountDownHide(20);
				ActiveTooltip.getInstance().setCountShow(1);
				return;
			}
			var cmd:GetDailyFriendBonus = new GetDailyFriendBonus(user.Id);
			Exchange.GetInstance().Send(cmd);
			if (!user.IsViewer())
			{
				user.EnergyBoxTime = GameLogic.getInstance().CurServerTime;
				user.GetMyInfo().EnergyBoxTime = GameLogic.getInstance().CurServerTime;				
			}
			else
			{
				var arr:Array = GameLogic.getInstance().user.GetMyInfo().EnergyBox;
				arr.push(user.Id);
				if (arr.length >= ConfigJSON.getInstance().GetItemList("Param")["pa_28"])
				{
					var st:String = "Bạn đã nhận đủ năng lượng bổ sung của hôm nay.\nHãy quay lại vào ngày mai để nhận tiếp nhé!";
					GuiMgr.getInstance().GuiMessageBox.ShowOK(st, 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
				}
			}
			user.UpdateEnergy(numBonus);
			
			// effect
			var mc:Sprite = ResMgr.getInstance().GetRes("IcEnergy") as Sprite;
			LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).addChild(mc);			
			var pS:Point = this.Parent.localToGlobal(this.CurPos);
			//var pD:Point = new Point(GuiMgr.getInstance().GuiTopInfo.img.x + GuiMgr.getInstance().GuiTopInfo.prgEnergy.x - 1, GuiMgr.getInstance().GuiTopInfo.img.y + GuiMgr.getInstance().GuiTopInfo.prgEnergy.y - 1);
			var pD:Point = new Point(40, 98);
			mc.x = pS.x;
			mc.y = pS.y;
			TweenMax.to(mc, 1, { bezier:[ { x:pD.x, y:pD.y } ], ease:Expo.easeOut, onComplete:onFinishTween, onCompleteParams:[mc, numBonus] } );
			
			ClearImage();
			LoadRes(NAME_DEACTIVED);
			MakeArrow();
		}
		
		private function onFinishTween(mc:Sprite, numBonus:int):void 
		{
			if (mc && mc.parent)
			{
				mc.parent.removeChild(mc);
				
				// Effect				
				//var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
				//txtFormat.align = "left";
				//txtFormat.font = "SansationBold";
				//var st:String;
				//st = "+" + numBonus;
				//txtFormat.color = 0x00FF00;
				//
				//var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);				
				//var guiTop:GUITopInfo = GuiMgr.getInstance().GuiTopInfo;
				//var pos:Point = new Point(guiTop.prgEnergy.x, guiTop.prgEnergy.y);
				//pos = guiTop.img.localToGlobal(pos);
				//var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				//eff.SetInfo(pos.x + guiTop.prgEnergy.width, pos.y + 30, pos.x - 25, pos.y + 30, 7);
			}
		}
		
		public function MakeArrow():void
		{
			if (arrow == null)
			{
				arrow = new Image(this.Parent,"IcHelper", CurPos.x, CurPos.y - 40);
			}
			if (CheckUser() == SUCCESS)
			{
				arrow.img.visible= true;
			}
			else
			{
				arrow.img.visible = false;
			}
		}
		
		public function updateStateBonusEnergy():void
		{
			var currentTime:Number = GameLogic.getInstance().CurServerTime;
			var user:User = GameLogic.getInstance().user;
			var oneDay:int = 24 * 60 * 60;
			// check 24h
			if (!user.IsViewer())			
			{
				if (currentTime - user.EnergyBoxTime >= oneDay && ImgName != NAME_ACTIVED)
				{					
					ClearImage();
					LoadRes(NAME_ACTIVED);
				}
			}
		}
	}

}