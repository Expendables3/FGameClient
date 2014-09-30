package GUI.FishWorld.ForestWorld 
{
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.Network.SendAttackWorld;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIEffRandomSeaRightGreen extends BaseGUI 
	{
		public const MY_CTN_EFF:String = "myImgEff";
		public const THEIR_CTN_EFF:String = "theirImgEff";
		public const MY_IMG_EFF:String = "myImgEff";
		public const THEIR_IMG_EFF:String = "theirImgEff";
		public var myIdEff:int = -1;
		public var theirIdEff:int = -1;
		public var countEff:int = 0;
		public var oldMyRand:int = -1;
		public var oldTheirRand:int = -1;
		public var myCtnEff:Container;
		public var theirCtnEff:Container;
		public var myTooltipEff:TooltipFormat;
		public var theirTooltipEff:TooltipFormat;
		public var myImgEff:Image;
		public var theirImgEff:Image;
		public var startRandom:Boolean = false;
		private var fightWorld:SendAttackWorld = null;
		public function GUIEffRandomSeaRightGreen(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIEffRandomSeaRightGreen";
		}
		override public function InitGUI():void 
		{
			//super.InitGUI();
			LoadRes("LoadingForestWorld_BgGuiRandomEffect");
			SetPos(Constant.STAGE_WIDTH / 2, 115);
			startRandom = true;
		}
		public function initGUI(myEff:String, theirEff:String, _fightWorld:SendAttackWorld = null):void 
		{
			if (this.IsVisible)	this.Hide();
			myIdEff = getIdEff(myEff);
			theirIdEff = getIdEff(theirEff);
			myTooltipEff = new TooltipFormat();
			theirTooltipEff = new TooltipFormat();
			myTooltipEff.text = GetStringEff(myIdEff).replace("@value", "");
			theirTooltipEff.text = GetStringEff(theirIdEff).replace("@value", "");
			if ( myIdEff < 0 || theirIdEff < 0)
			{
				return;
			}
			fightWorld = _fightWorld;
			this.Show();
		}
		public function Update():void 
		{
			if (!startRandom)	return;
			if (myIdEff < 0 || theirIdEff < 0)	return;
			
			if (myImgEff == null)
			{
				myCtnEff = AddContainer(MY_CTN_EFF, "LoadingForestWorld_ImgFrameFriend", 34 - 60, 19 - 20, true, this);
				myImgEff = myCtnEff.AddImage(MY_IMG_EFF, "LoadingForestWorld_RandomEffect_1", 0, 0, true, ALIGN_LEFT_TOP);
			}
			if (theirImgEff == null)
			{
				theirCtnEff= AddContainer(THEIR_CTN_EFF, "LoadingForestWorld_ImgFrameFriend", 112 - 90, 19 - 20, true, this);
				theirImgEff = theirCtnEff.AddImage(THEIR_IMG_EFF, "LoadingForestWorld_RandomEffect_1", 0, 0, true, ALIGN_LEFT_TOP);
			}
			
			countEff ++;
			var myRand:int = Math.floor(Math.random() * 7 + 1);
			var theirRand:int = Math.floor(Math.random() * 7 + 1);
			if (countEff < 20)
			{
				ReLoadResImg(myRand, theirRand);
			}
			else 
			{
				if (oldMyRand == myIdEff)
				{
					myRand = -1;
				}
				
				if (oldTheirRand == theirIdEff)
				{
					theirRand = -1;
				}
				
				theirCtnEff.setTooltip(theirTooltipEff);
				myCtnEff.setTooltip(myTooltipEff);
				
				var ef:SwfEffect = null;
				var mf:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
				var tf:FishSoldier = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen[0];
				var alpha:Number = 0;
				var startX:Number;
				var startY:Number;
				var length:Number;
				if (myRand == -1 && theirRand == -1)	
				{
					startRandom = false;
					if (myIdEff == 7)
					{
						startX = myCtnEff.img.localToGlobal(new Point(0, 0)).x;
						startY = myCtnEff.img.localToGlobal(new Point(0, 0)).y;
						var tempMy:Point = Ultility.PosScreenToLake(startX, startY);
						startX = tempMy.x;
						startY = tempMy.y;
						length = Math.sqrt((mf.CurPos.y - startY) * (mf.CurPos.y - startY) + 
							(startX - mf.CurPos.x) * (startX - mf.CurPos.x));
						ef = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffBolt", null,
							mf.standbyPos.x, mf.standbyPos.y, false, false, null, onCompleteBolt);
						ef.img.height = length;
						alpha = Math.atan((startX - mf.standbyPos.x) / (mf.standbyPos.y - startY));
						alpha = alpha / Math.PI * 180;
						ef.img.rotationZ = alpha;
					}
					else if(theirIdEff == 7)
					{
						startX = img.localToGlobal(new Point(theirCtnEff.CurPos.x, theirCtnEff.CurPos.y)).x;
						startY = img.localToGlobal(new Point(theirCtnEff.CurPos.x, theirCtnEff.CurPos.y)).y;
						var tempTheir:Point = Ultility.PosScreenToLake(startX, startY);
						startX = tempTheir.x;
						startY = tempTheir.y;
						length = Math.sqrt((tf.CurPos.y - startY) * (tf.CurPos.y - startY) + 
							(startX - tf.CurPos.x) * (startX - tf.CurPos.x));
						ef = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffBolt", null,
							tf.CurPos.x, tf.CurPos.y, false, false, null, onCompleteBolt);
						ef.img.height = length;
						alpha = Math.atan((startX - tf.CurPos.x) / (tf.CurPos.y - startY));
						alpha = alpha / Math.PI * 180;
						ef.img.rotationZ = alpha
					}
					else 
					{
						onCompleteBolt();
					}
					countEff = 0;
				}
				
				ReLoadResImg(myRand, theirRand);
			}
		}
		//
		//public function tempMy():void 
		//{
			//var ef:SwfEffect = null;
			//var mf:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			//var tf:FishSoldier = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen[0];
			//var alpha:Number = 0;
			//var startX:Number;
			//var startY:Number;
			//startX = myCtnEff.img.localToGlobal(new Point(0, 0)).x;
			//startY = myCtnEff.img.localToGlobal(new Point(0, 0)).y;
			//var tempMy:Point = Ultility.PosScreenToLake(startX, startY);
			//startX = tempMy.x;
			//startY = tempMy.y;
			//var length:Number = Math.sqrt((mf.CurPos.y - startY) * (mf.CurPos.y - startY) + 
				//(startX - mf.CurPos.x) * (startX - mf.CurPos.x));
			//ef = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffBolt", null,
				//mf.standbyPos.x, mf.standbyPos.y, false, false, null, onCompleteBolt);
			//ef.img.height = length;
			//alpha = Math.atan((startX - mf.standbyPos.x) / (mf.standbyPos.y - startY));
			//alpha = alpha / Math.PI * 180;
			//ef.img.rotationZ = alpha;
		//}
		//
		//public function temp1():void 
		//{
			//var ef:SwfEffect = null;
			//var mf:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			//var tf:FishSoldier = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen[0];
			//var alpha:Number = 0;
			//var startX:Number;
			//var startY:Number;
			//startX = img.localToGlobal(new Point(theirCtnEff.CurPos.x, theirCtnEff.CurPos.y)).x;
			//startY = img.localToGlobal(new Point(theirCtnEff.CurPos.x, theirCtnEff.CurPos.y)).y;
			//var tempTheir:Point = Ultility.PosScreenToLake(startX, startY);
			//startX = tempTheir.x;
			//startY = tempTheir.y;
			//var length:Number = Math.sqrt((tf.CurPos.y - startY) * (tf.CurPos.y - startY) + 
				//(startX - tf.CurPos.x) * (startX - tf.CurPos.x));
			//ef = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "LoadingForestWorld_EffBolt", null,
				//tf.CurPos.x, tf.CurPos.y, false, false, null, onCompleteBolt);
			//ef.img.height = length;
			//alpha = Math.atan((startX - tf.CurPos.x) / (tf.CurPos.y - startY));
			//alpha = alpha / Math.PI * 180;
			//ef.img.rotationZ = alpha
		//}
		//
		public function onCompleteBolt():void 
		{
			Exchange.GetInstance().Send(fightWorld);
			ShowEffect();
		}
		
		public function ShowEffect():void 
		{
			var mf:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			var tf:FishSoldier = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen[0];
			var posStart:Point;
			var posEnd:Point;
			var txtFormat:TextFormat;
			if (mf == null || tf == null)	return;
			posStart = Ultility.PosLakeToScreen(mf.GetPos().x, mf.GetPos().y);
			posEnd = Ultility.PosLakeToScreen(tf.GetPos().x - 150, tf.GetPos().y - 70);
			//posEnd = new Point(posStart.x, posStart.y - 100);
			txtFormat = new TextFormat(null, 14, 0xFF0000);
			if (myIdEff < 7 && myIdEff % 2 == 1)	txtFormat.color = 0x00FF00;
			txtFormat.align = "center";
			txtFormat.bold = true;
			txtFormat.font = "Arial";
			txtFormat.size = 20;
			var str:String = GetStringEff(myIdEff);
			var value:int = GetValueEff(myIdEff,mf, tf);
			str = str.replace("@value", value.toString());
			if (myIdEff < 7 && myIdEff % 2 == 1)
			{
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0x000000, 10);
			}
			else
			{
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff, 10);
			}
			
			posStart = Ultility.PosLakeToScreen(tf.GetPos().x, tf.GetPos().y);
			posEnd = new Point(posStart.x, posStart.y - 100);
			txtFormat = new TextFormat(null, 14, 0xFF0000);
			if (theirIdEff < 7 && theirIdEff % 2 == 1)	txtFormat.color = 0x00FF00;
			txtFormat.align = "center";
			txtFormat.bold = true;
			txtFormat.font = "Arial";
			str = GetStringEff(theirIdEff);
			value = GetValueEff(theirIdEff, tf, mf);
			str = str.replace("@value", value.toString());
			if (theirIdEff < 7 && theirIdEff % 2 == 1)
			{
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0x000000);
			}
			else
			{
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
			}
		} 
		
		public function GetValueEff(id:int, fis:FishSoldier, fis2:FishSoldier):int
		{
			var value:int;
			switch (id) 
			{
				case 1:
				case 2:
					value = fis.getTotalDamage() / 2;
					
					if ((fis.Element - fis2.Element == -1 || fis.Element - fis2.Element == 4) && 
						!GuiMgr.getInstance().GuiFishWarForest.isResistance)
					{
						value = value * 1.2;
					}
					else if ((fis.Element - fis2.Element == 1 || fis.Element - fis2.Element == -4) && 
						!GuiMgr.getInstance().GuiFishWarForest.isResistance)
					{
						value = value * 0.8;
					}
					
				break;
				case 3:
				case 4:
					value = fis.getTotalDefence() / 2;
				break;
				case 5:
				case 6:
					value = fis.getTotalVitality() / 2;
				break;
			}
			
			return value;
		}
		
		public function GetStringEff(id:int):String
		{
			var str:String = "";
			switch (id) 
			{
				case 1:
					str = Localization.getInstance().getString("FishWorldMsg10");
				break;
				case 2:
					str = Localization.getInstance().getString("FishWorldMsg11");
				break;
				case 3:
					str = Localization.getInstance().getString("FishWorldMsg12");
				break;
				case 4:
					str = Localization.getInstance().getString("FishWorldMsg13");
				break;
				case 5:
					str = Localization.getInstance().getString("FishWorldMsg14");
				break;
				case 6:
					str = Localization.getInstance().getString("FishWorldMsg15");
				break;
				case 7:
					str = Localization.getInstance().getString("FishWorldMsg16");
				break;
			}
			return str;
		}
		
		public function ReLoadResImg(myRand:int = -1, theirRand:int = -1):void 
		{
			if (myRand > 0)	
			{
				myImgEff.LoadRes("LoadingForestWorld_RandomEffect_" + myRand);
				oldMyRand = myRand;
			}
			if (theirRand > 0)	
			{
				oldTheirRand = theirRand;
				theirImgEff.LoadRes("LoadingForestWorld_RandomEffect_" + theirRand);
			}
		}
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			myIdEff = -1;
			theirIdEff = -1;
			myImgEff = null;
			theirImgEff = null;
			startRandom = false;
		}
		public function getIdEff(idStringEff:String):int
		{
			var idIntEff:int = -1;
			switch (idStringEff) 
			{
				case "IncreaseDamage":
					idIntEff = 1;
				break;
				case "DecreaseDamage":
					idIntEff = 2;
				break;
				case "IncreaseHealthy":
					idIntEff = 5;
				break;
				case "DecreaseHealthy":
					idIntEff = 6;
				break;
				case "IncreaseDefence":
					idIntEff = 3;
				break;
				case "DecreaseDefence":
					idIntEff = 4;
				break;
				case "Bolt":
					idIntEff = 7;
				break;
			}
			return idIntEff;
		}
	}

}