package GUI.FishWorld 
{
	import com.greensock.easing.Circ;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIInfoWarInWorld extends BaseGUI 
	{
		private var isZoomIn:Boolean = true;
		public var canShowImgEnviroment:Boolean = true;
		public const PRG_ROUND:String = "PrgRound";
		public var imgBound:Image;
		public var ctnBase:Container;
		private var count:int;
		public var imgInfoEnviroment:Image = null;
		public function GUIInfoWarInWorld(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIInfoWarInWorld";
		}
		
		public function initAllGUI(round:int, isBoss:Boolean = false):void 
		{
			Show(Constant.GUI_MIN_LAYER, 0);
			imgBound = AddImage("", "GuiInfoWarInWorld", 425, 300) ;
			ctnBase = AddContainer("ctnBase", "CtnBaseInGUiWarInWorld", 360, 220, true, this);
			ctnBase.AddImage("Round", "ImgRound", 70, 0);
			AddProgress(PRG_ROUND, "PrgStatusRoudInSea_1", Constant.STAGE_WIDTH / 2 - 142, 30, null, true);
			Ultility.SetEnableSprite(GetProgress(PRG_ROUND).imgBg, false);
			GetProgress(PRG_ROUND).setStatus(GetPercent());
			if (isBoss)	
			{
				ctnBase.GetImage("Round").img.visible = false;
				ctnBase.AddImage("IndexRound", "ImgNumberRoundBoss", 70, 70);
			}
			else 
			{
				ctnBase.AddImage("IndexRound", "ImgNumberRound" + round, 70, 70);
			}
			ctnBase.GetImage("IndexRound").FitRect(78, 78, new Point(30, 30));
		}
		
		private function GetPercent():Number
		{
			var round:int = FishWorldController.GetRound();
			switch (round) 
			{
				case 1:
					return 0.168;
				break;
				case 2:
					return 0.408;
				break;
				case 3:
					return 0.665;
				break;
				case 4:
					return 1;
				break;
			}
			return 1;
		}
		
		public override function InitGUI() :void
		{
			LoadRes("ImgFrameFriend");	
			count = 0;
			//SetPos(280, 90);
		}
		
		public function UpdateGui():void 
		{
			if (count < 30)
			{
				count ++;
				ctnBase.img.alpha -= (1 / 30);
			}
			else if(count == 30)
			{
				count++;
			}
			
			//trace((imgInfoEnviroment == null));
			//if(imgInfoEnviroment)
			//{
				//trace((imgInfoEnviroment.img == null));
			//}
			if(canShowImgEnviroment && (imgInfoEnviroment == null || (imgInfoEnviroment != null && imgInfoEnviroment.img == null)) && IsVisible && FishWorldController.CheckHaveEnvironment())
			{
				switch (FishWorldController.GetSeaId()) 
				{
					case Constant.OCEAN_ICE:
						imgInfoEnviroment = AddImage("imgInfoEnviroment", "ImgIceWave", 460, 260);
						canShowImgEnviroment = false;
					break;
				}
			}
			
			if (isZoomIn)
			{
				if(imgInfoEnviroment && imgInfoEnviroment.img && imgInfoEnviroment.img.scaleX < 1.5)
				{
					imgInfoEnviroment.img.scaleX += 0.01;
					imgInfoEnviroment.img.scaleY += 0.01;
					imgInfoEnviroment.img.alpha -= 0.01;
					if (imgInfoEnviroment.img.scaleX >= 1.5)
					{
						isZoomIn = false;
					}
				}
			}
			else
			{
				if(imgInfoEnviroment && imgInfoEnviroment.img && imgInfoEnviroment.img.scaleX > 1)
				{
					imgInfoEnviroment.img.scaleX -= 0.01;
					imgInfoEnviroment.img.scaleY -= 0.01;
					imgInfoEnviroment.img.alpha -= 0.01;
				}
				else if(imgInfoEnviroment && imgInfoEnviroment.img)
				{
					imgInfoEnviroment.img.parent.removeChild(imgInfoEnviroment.img);
					imgInfoEnviroment.ClearEvent();
					imgInfoEnviroment = null;
					isZoomIn = true;
				}
			}
		}
	}

}