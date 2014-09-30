package Logic 
{
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import Effect.ImgEffectFly;
	import Effect.EffectMgr;
	import flash.geom.Point;
	import NetworkPacket.PacketSend.SendGetGiftEventSoldier;
	import NetworkPacket.PacketSend.SendGetNewUserGiftBag;
	import GUI.component.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class BalloonStart extends Balloon 
	{
		
		private var isFinishToFace:Boolean = false; // chuyển động tới mật nước
		private var arrow:Image = null;		// mũi tên để trỏ xuống 
		private var isClick:Boolean = false;

		
		public function BalloonStart(parent:Object = null, imgName:String = "") 
		{
			super(parent, imgName);
			img.buttonMode = true;
			
		}
		
		
		public function MakeArrow():void
		{	
			
			arrow = new Image(this.Parent,"IcHelper", CurPos.x+10, CurPos.y - 30);
		}
		
		override protected function bob():void 
		{
			if(isStop)
			return;
			if (CurPos.y <= waterSurface - 7)
			{
				SpeedVec.y = Math.random() * 0.3 + 0.2;
				isFinishToFace = true;
			}			
			else if(CurPos.y >= waterSurface + 7)
			{
				
				if (isFinishToFace)
				{
					SpeedVec.y = -(Math.random() * 0.3 + 0.2);
					if (!arrow&& !isClick)
					{
						MakeArrow();
					}
				}
				else
				{
					SpeedVec.y = -(Math.random() * 0.8 + 2.7);
				}
			}
			CurPos.y += SpeedVec.y;
			SetPos(CurPos.x, CurPos.y);
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			
			//GameLogic.getInstance().user.tuiTanThu.GetGift();
			// send server
			if (!isClick)
			{
				isClick = true;
				var cmdNew:SendGetNewUserGiftBag = new SendGetNewUserGiftBag();
				Exchange.GetInstance().Send(cmdNew);
			}
		}
		
		public function AddEffect():void 
		{
			//
			//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffMoneyBalloon", null, CurPos.x - 57, CurPos.y - 22);
			//
			//Effect số tiền bay lên
			//var child:Sprite = new Sprite();
			//var color:int = 0xffff00;
			//var txtFormat:TextFormat = new TextFormat("SansationBold", 22, color, true);
			//txtFormat.align = "left";
			//txtFormat.font = "SansationBold";
			//child.addChild(Ultility.CreateSpriteText("+" , txtFormat, 6, 0, true));					
			//var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child) as ImgEffectFly;
			//var pos:Point = Ultility.PosLakeToScreen(CurPos.x, CurPos.y)
			//eff.SetInfo(pos.x + 7, pos.y + 10, pos.x + 7, pos.y - 25 + 5, 3);

			//Hủy bong bóng
			Destructor();
		}
		override public function Destructor():void 
		{
			isStop = true;
			if (arrow)
			{
				if (this.Parent != null && arrow!= null &&arrow.img!=null&& arrow.img.parent== Parent)
				{
					this.Parent.removeChild(arrow.img);
					arrow.Destructor();
					arrow = null;
				}
			}
			
			ClearImage();
			DesPos = null;
			SpeedVec = null;
			CurPos = null;
			
		}
		
	
		
		
	}

}