package GUI 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GUIGemRefine.Pearl;
	import GUI.GUIGemRefine.Pearl;
	import GUI.GUIGemRefine.PearlMgr;
	import particleSys.Emitter;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CTNPearl extends Container 
	{
		public var idPearl:int = -1;
		public var isPhe:Boolean = false;
		private var imgPhe:Image = null;
		
		public function CTNPearl(id:int,parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.idPearl = id;

			init();
		}
		
		public function init():void 
		{
			SetToolTip();
			img.buttonMode = true;
			img.doubleClickEnabled = true;
			var a:Array = GuiMgr.getInstance().GuiPearlRefine.pearlList;
			var pearl:Pearl = a[idPearl] ;
			if (pearl)
			{
				/*if (pearl.level == 0)
				{
					SetScaleXY(0.3);
				}*/
				if (pearl.timeLife < 1)
				{
					isPhe = true;
					AddDestroy();
				}
			
			
			}
		}
		public function AddDestroy():void 
		{
			if (imgPhe)
			{
				imgPhe = null;
			}
			//imgPhe = AddImage("", "Icon_Phe_TuLuyenNgoc", -10, 25);
			imgPhe= new Image(img.parent, "GuiPearlRefine_Icon_Phe_TuLuyenNgoc", -3, 25,true,ALIGN_CENTER_CENTER);
			imgPhe.img.mouseEnabled = false;
			img.alpha = 0.6;
			
			imgPhe.FitRect(40,45, new Point(0, 0));
			var a:Array = GuiMgr.getInstance().GuiPearlRefine.pearlList;
			var pearl:Pearl = a[idPearl] ;
	
		}
		
		public function RecoverPearl():void 
		{
			isPhe = false;
			img.alpha = 1;
			if (imgPhe)
			{
				img.parent.removeChild(imgPhe.img);
			}
			
		}
		
		private function GetAgencyPoint(el:int,ap:Number):String 
		{
			var s:String = "";
			switch (el) 
			{
				case 1:
					s = "Tăng chí mạng: ";
				break;
				case 2:
					s = "Giảm thủ: ";
				break;
				case 3:
					s = "Tăng thủ: ";
				break;
				case 4:
					s = "Hồi máu: ";
				break;
				case 5:
					s = "Tăng công: ";
				break;
				default:
					s = "";
				break;
			}
			s += ap;
			return s;
			
		}
		
		public function SetToolTip():int 
		{
			var a:Array = GuiMgr.getInstance().GuiPearlRefine.pearlList;
			var pearl:Pearl = a[idPearl] ;
			if (pearl)
			{
				var formatText:TextFormat = new TextFormat();
				formatText.bold = true;
				formatText.color = 0xff0000;
				formatText.size = 12;
				var tip:TooltipFormat = new TooltipFormat();
				tip.setTextFormat(formatText);
				var s:String = "";
				s = GetNameLb(pearl.element, pearl.level);
				
				var str:String;
				str = Localization.getInstance().getString("Gem" + pearl.element);
				str = str.replace("@Type@", Localization.getInstance().getString("GemType" + pearl.level));
				if (pearl.level == 0)
				{
					str = str.replace("@Rank@","");
				}
				else 
				{
					str = str.replace("@Rank@", "cấp " + pearl.level);
				}
				str = str.replace("@value@", pearl.agencyPoint);
				 
				if (pearl.timeLife > 0)
				{
					str = str.replace("@day@", pearl.timeLife);
					s += "\n" + "Thời hạn: " + pearl.timeLife+" ngày";
				}
				else 
				{
					str = str.replace("Thời hạn còn", "Tự hủy");
					str = str.replace("@day@", (pearl.timeLife+7));
					s += "\n" + "Tự hủy: " + (pearl.timeLife+7)+" ngày";
				}
				s +="\n"+ GetAgencyPoint(pearl.element, pearl.agencyPoint);
				tip.text = str;

				setTooltip(tip);
				return pearl.number;
			}
			
			return -1;
			
		}
		
		private function GetNameLb(el:int,lv:int):String 
		{
			var s:String = "";

			switch (el) 
			{
				case 1:
					s = "Kim ";
				break;
				case 2:
					s = "Mộc ";
				break;
				case 3:
					s = "Thổ ";
				break;
				case 4:
					s = "Thủy ";
				break;
				case 5:
					s = "Hỏa ";
				break;
			}
			if (lv > 0)
			{
				s +="đan "+ "cấp " + lv;
			}
			else
			{
				if (lv == 0)
				{
					s += "tán";
				}
			}
			return s;
			
		}
	}

}