package GUI.FishMeridian 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import Logic.FishSoldier;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMeridianAchievement extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		private var soldier:FishSoldier;
		private var ctnBg:Container;
		private var ctnInfo:Container;
		
		public function GUIMeridianAchievement(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(200 - 85, 50 + 97);
				ctnInfo = AddContainer("", "GuiMeridian_CtnInfo", 0, -300);
				var txtFormat:TextFormat = new TextFormat("arial", 16, 0x00ff00, true);
				txtFormat.color = 0xffff00;
				ctnInfo.AddLabel(soldier.meridianRank + "/" + GUIMeridian.MAX_RANK, 50 + 108, 18, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				txtFormat.color= 0x00ff00;
				ctnInfo.AddLabel("+ " + Ultility.StandardNumber(soldier.meridianDamage), 127, 86, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
				ctnInfo.AddLabel("+ " + Ultility.StandardNumber(soldier.meridianDefence), 127, 86+ 30, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
				ctnInfo.AddLabel("+ " + Ultility.StandardNumber(soldier.meridianCritical), 162, 86+ 64, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
				ctnInfo.AddLabel("+ " + Ultility.StandardNumber(soldier.meridianVitality), 127, 88 + 95, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
				ctnInfo.AddButton(BTN_CLOSE, "GuiMeridian_BtnUp", 120, 201, this);
				
				var mask:Sprite = new Sprite();
				mask.graphics.beginFill(0xff0000);
				mask.graphics.drawRect(0, 0, ctnInfo.img.width + 10, ctnInfo.img.height + 10);
				mask.graphics.endFill();
				img.addChild(mask);
				ctnInfo.img.mask = mask;
				
				TweenMax.to(ctnInfo.img, 0.3, { bezierThrough:[ { x:0, y:0 } ], ease:Expo.easeIn } );
			}
			LoadRes("");
		}
		
		public function showGUI(_soldier:FishSoldier):void
		{
			soldier = _soldier;
			Show(Constant.GUI_MIN_LAYER);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_CLOSE)
			{
				TweenMax.to(ctnInfo.img, 0.3, { bezierThrough:[ { x:0, y:-300 } ], ease:Expo.easeIn, onComplete:Hide } );
			}
		}
		
	}

}