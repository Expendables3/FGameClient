package Logic 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.component.ActiveTooltip;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GUIAddMoneyMagnet;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import NetworkPacket.PacketSend.SendCollectMoney;
	import particleSys.myFish.CometEmit;
	import particleSys.myFish.GhostEmit;
	
	/**
	 * ...
	 * @author Sonbt
	 */
	public class MoneyMagnet extends BaseObject 
	{
		public const POS_X:int = 890;
		public const POS_Y:int = GameController.getInstance().GetLakeTop() - 60;
		private const FREE_TIMES:int = 3;
		private var isSend:Boolean = false;
		public var useTimes:int = 0;
		public var lastTime:Number = 0;
		private var guiAddMoneyMagnet:GUIAddMoneyMagnet = new GUIAddMoneyMagnet(null, "");
		
		public var txtdown:TextField= new TextField();
		private var format:TextFormat = new TextFormat();
		private var toolTip:TooltipFormat = new TooltipFormat();
		
		public var emitStar:Array = [];
		public var emit:CometEmit = null;
		private var speed:Number = 12;
		public var ghostEmit:GhostEmit = null;
		
		private var isShow:Boolean = false;
		private var tf:Boolean = true;
		private var imgSpr:Sprite = null;
		
		private var isMultiClick:Boolean = false;


		
		public function MoneyMagnet(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			img.buttonMode = true;
			SetPos(POS_X, POS_Y);
			addToolTip();
			ReachDes = true;
		}	
		
		public function InitData(data:Object):void 
		{
			if (data)
			{
				if ("NumUseLeft" in data)
				{
					useTimes = data.NumUseLeft;
					lastTime = data.LastTimeUse;
				}
			
			}
			SetImg();	
			
			img.visible = false;
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			var a:Array = GameLogic.getInstance().balloonArr;
			if (a.length > 0)
			{
				ProcessMagnet();
			}
			else
			{
				if(!isMultiClick)
				{
					toolTip.text = "Không có tiền để hút rùi";
					ActiveTooltip.getInstance().showNewToolTip(toolTip, GuiMgr.getInstance().guiFrontScreen.btnGetCoin.img);
					//GuiMgr.getInstance().GuiMessageBox.ShowOK("Không có tiền để hút");
					isMultiClick = true;
				}
				
				if (useTimes < 1)
				{
						// hiển thị Gui thực hiện bằng G
					guiAddMoneyMagnet.ShowGui();
				}
			}
			
		}
		
		public function Clear():void 
		{
			ClearImage();
			if (ghostEmit != null)
			{
				ghostEmit.destroy();
			}
			
		}
		
		private function ClearParticle():void 
		{
			if (ghostEmit != null)
			{
				ghostEmit.destroy();
			}
			/*var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER);

			if (emit)
			{
				emit.stopSpawn();
			}
			layer.stage.removeChild(emit.sp);	*/
		}
		
		public function Reset():void 
		{
			useTimes += FREE_TIMES;
			lastTime = GameLogic.getInstance().CurServerTime;
		}
		
		public function SetImg():void 
		{
			if (useTimes > 0)
			{
				// load lại ảnh
				ClearImage();
				LoadRes("IconNamCham1");
				img.buttonMode = true;
			}
			else
			{
				// load lại ảnh
				ClearImage();
				LoadRes("IconNamcham2");	
				img.buttonMode = true;
			}
			AddTextNumber();
			
			// add mask
			if (imgSpr != null)
			{
				if (imgSpr.parent != null)
				{
					imgSpr.parent.removeChild(imgSpr);
					imgSpr = null;
				}
			}
			imgSpr = new Sprite();
			imgSpr.graphics.beginFill(0x000000, 0);
			imgSpr.graphics.drawRect(0, 0, img.width, img.height);
			imgSpr.graphics.endFill();
			img.addChild(imgSpr);
			isMultiClick = false;
			//trace(img.numChildren);
			
			img.visible = false;
		}
		
		public function ProcessMagnet():void 
		{
			//var isDo:Boolean = false;
			if (!isSend)
			{			
				if (useTimes > 0)
				{
					img.visible = true;
					EffectFlyNumber();
					useTimes--;
					//isDo = true;
					isSend = true;	
				}
				else 
				{
					// hiển thị Gui thực hiện bằng G
					guiAddMoneyMagnet.ShowGui();
				}
			}
			if (isSend)
			{
				lastTime = GameLogic.getInstance().CurServerTime;
				var a:Array = GameLogic.getInstance().balloonArr;
				a.sortOn("idSortX",Array.DESCENDING|Array.NUMERIC);
				MoveTo(POS_X - 470, POS_Y, speed);
				txtdown.text = "";
				if (a.length == 0)
				{
					useTimes++;
				}
				startParticle();
			}
		}
		
		
		private var flag:Boolean = true;
		private var flag2:Boolean = true;
		
		private function DoBall():void 
		{
			if (flag)
			{
				flag = false;
				var a:Array = GameLogic.getInstance().balloonArr;
				for (var i:int = 0; i < a.length; i++) 
				{
					if (!flag2)
					return;
					var item:Balloon = a[i];
					//trace("index_i", i);

					if (item.movingState == Balloon.BL_BOB)
					{

						if( (item.CurPos.x+20) >= img.x)
						{
							//trace("fsfs",a.length);
							if (tf)
							{
								item.collect(true, true, true);
								tf = false;
							}
							else
							{
								item.collect(true, true,false);
							}
							i--;
							//trace("gsgsg",a.length);
						}
					}
					if (i == a.length - 1)
					{
						flag = true;
					}
				}
				
			}
		}
		
		private function DoballF():void 
		{
			flag2 = false;
			flag = false;
			var a:Array = GameLogic.getInstance().balloonArr;
			for (var i:int = 0; i < a.length; i++) 
			{
				//trace("i", i);
				var item:Balloon = a[i];
				if (item.movingState == Balloon.BL_BOB)
				{
					if (tf)
					{
						item.collect(true, true, true);
						tf = false;
					}
					else
					{
						item.collect(true, true,false);
					}
					i--;
				}
				
			}
		}
		
		public function ProcessAddXu(num:int):void 
		{
			useTimes = num;
		}
		
		private function EffectFlyNumber():void 
		{
				//Effect số tiền bay lên
			var child:Sprite = new Sprite();
			var color:int = 0xFF8040;
			var txtFormat:TextFormat = new TextFormat("SansationBold", 22, color, true);
			txtFormat.align = "left";
			txtFormat.font = "SansationBold";
			child.addChild(Ultility.CreateSpriteText("-1" , txtFormat, 6, 0, true));					
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child) as ImgEffectFly;
			var pos:Point = Ultility.PosLakeToScreen(CurPos.x, CurPos.y)
			eff.SetInfo(pos.x + 7, pos.y + 10, pos.x + 7, pos.y - 25 ,3);	
			
		}
		
		public function Update():void 
		{
			
			if (lastTime > 0)
			{
				var datLast:Date = new Date(lastTime * 1000);
				var datCur:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
				if (datLast.getDate() != datCur.getDate() || (datLast.getDate() == datCur.getDate() && datCur.getMonth() != datLast.getMonth()))
				{
					Reset();
				}
			}
			UpdateObject();
			updateParticle();
		}
		override public function UpdateObject():void 
		{
			
			if (ReachDes)
			{
				if (isShow)
				{
					img.alpha -= 0.02;
					if (img.alpha < 0)
					{
						img.alpha = 0;
						if (useTimes < 1)
						{
							SetImg();
						}
						SetPos(POS_X, POS_Y);
						if (GameLogic.getInstance().user.IsViewer())
						{
							SetPos(POS_X - 30,POS_Y);
						}
						txtdown.text = "x"+useTimes.toString();
						format.size = 18;
						format.color = 0x000000;
						format.bold = true;
						txtdown.defaultTextFormat = format;
						img.alpha = 1;
						isShow = false;
						isSend = false;
						
						img.visible = false;
					}
				}
				return;
			}
			DoBall();
			var temp:Point = CurPos.subtract(DesPos);
			img.alpha -= 0.002;
			if ( temp.length <= SpeedVec.length)
			{
				isShow = true;
				ReachDes = true;
				DoballF();
				tf = true;
				ClearParticle();
				trace(GameLogic.getInstance().user.MoneyTotal);
				return;
			}
				
			CurPos = CurPos.add(SpeedVec);
			this.img.x = CurPos.x;
			this.img.y = CurPos.y;	
			
		}
		
		public function updateParticle():void
		{
			if (ghostEmit)
			{
				if (ReachDes)
				{
					ClearParticle();
					return;
				}
				ghostEmit.pos.x = img.x + 40;// + OrientX * img.width / 2;
				ghostEmit.pos.y = img.y + 25;
				ghostEmit.updateEmitter();
				//ghostEmit.vel = new Point(OrientX, 0);
			}
			
				
			/*if (emit)
			{
				if (emit.sp)
				{
					emit.sp.x =img.x+50;
					emit.sp.y = img.y + 30;
					emit.updateEmitter();
				}
				if (emit.allowSpawn && emit.particleList.length < 1)
				{
					emit.destroy();	
					emit = null;
				}
			}
		
			//Update particle
			for (var i:int; i < emitStar.length; i++)
			{
				emitStar[i].updateEmitter();
				if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				{
					emitStar[i].destroy();
					emitStar.splice(i, 1);
					i--;					
				}
			}*/
			
		}
		
		private function AddTextNumber():void 
		{
			txtdown = AddLabel("x"+useTimes.toString(), 45,25, 0x000000,1,0xFFFFFF);
			txtdown.mouseEnabled = false;
			format.size = 16;
			format.color = 0x000000;
			format.bold = true;
			txtdown.defaultTextFormat = format;
			
			GuiMgr.getInstance().guiFrontScreen.txtUseTime.text = "x" + useTimes.toString();
		}
		
		
			
		/**
		 * Thêm particle từ nút chọn skill đến giữa gui lai
		 * @param	SkillName	tên loại kỹ năng lai
		 */
		private function startParticle():void
		{
			if (ghostEmit == null)
			{
				var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER);
				ghostEmit = new GhostEmit(layer, null, 1, true);
				trace ("dfdfd",layer.numChildren);
			}
						
			/*var pos:Point, med:Point;
			var des:Point;
			var time:Number = 1;
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER);
			//var emit:CometEmit ;
			emit= new CometEmit(layer);		
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;			
			//pos = new Point(POS_X, POS_Y);	
			//des = new Point(POS_X-400, POS_Y+90);
			//sao.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 150, 100, 0);
			sao.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 204, 102, 0);			
			emit.imgList.push(sao);
			emitStar.push(emit);
			//med = getThroughPoint(pos, des);	
			
			if (emit)
			{
				layer.stage.addChild(emit.sp);
			
			//	TweenMax.to(emit.sp , time, { bezierThrough:[ { x:med.x, y:med.y }, { x:des.x, y:des.y } ], ease:Cubic.easeOut,onComplete:onCompleteTween }  );		
				//TweenLite.to(emit.sp, time, { x:des.x, y:des.y, onComplete:onCompleteTween } );
			}*/
			
		/*	function onCompleteTween():void
			{
				if (emit)
				{
					emit.stopSpawn();
				}
				layer.stage.removeChild(emit.sp);		
			}*/			
		}
				
		/**
		 * Tìm điểm trung gian giữa 2 điểm nguồn và đích để bay vòng qua đó cho đẹp
		 * @param	psrc	điểm nguồn
		 * @param	pdes	điểm đích
		 * @return
		 */
		private function getThroughPoint(psrc:Point, pdes:Point):Point
		{
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
	
			//Random hướng vuông góc
			var n:int = Math.round(Math.random()) * 2 - 1;
			v.x = n*v.x;
			v.y = n*v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;			
		}
		
		
		private function addToolTip():void 
		{
			toolTip.text = "Click vào nào";		
			
		}
	
		private function AddLabel(st:String, x:int, y:int, color:int = 0x000000, align:int = 1, IsOutline:int = -1):TextField
		{
			var txt:TextField = new TextField();
				
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
			txtFormat.size = 16;
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
		//	LabelArr.push(txt);
			//var img1:Image = new Image(img, "IconNumMagnet", x, y);
			img.addChild(txt);
			txt.x = x;
			txt.y = y;	
			return txt;
		}
		
		override public function OnMouseOver(event:MouseEvent):void 
		{
			toolTip.text = "Click vào nào";
			ActiveTooltip.getInstance().showNewToolTip(toolTip, this.img);
			SetHighLight(0xFFFF00);
		}
		
		override public function OnMouseOut(event:MouseEvent):void 
		{
				ActiveTooltip.getInstance().clearToolTip();
				SetHighLight( -1);
				isMultiClick = false;
		}
		
	
		
		
	}

}