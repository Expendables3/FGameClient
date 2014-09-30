package GUI.ChampionLeague.GuiLeague 
{
	import Effect.EffectMgr;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.component.BaseGUI;
	
	/**
	 * GUI để chứa cái effect Versus tĩnh và Versus động
	 * Khi kết thúc Versus động thì Hide GUI => trận đấu bắt đầu
	 * @author HiepNM2
	 */
	public class GUIEffVersus extends BaseGUI 
	{
		
		public function GUIEffVersus(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIEffVersus";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2 + 271, Constant.STAGE_HEIGHT / 2 - img.height / 2 + 170);
			}
			LoadRes("GuiLeagueGift_EffVersusIdle");
		}
		public function runEffect():void
		{
			var x:int = this.img.x;
			var y:int = this.img.y;
			Hide();
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiLeagueGift_EffVersusExpand", null,
													x, y,
													false, false, null, onCompleteEff);
			function onCompleteEff():void
			{
				trace("kết thúc effect Versus Expand");
			}
		}
	}

}




























