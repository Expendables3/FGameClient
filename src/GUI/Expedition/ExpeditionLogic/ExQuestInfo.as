package GUI.Expedition.ExpeditionLogic 
{
	import Data.ConfigJSON;
	import NetworkPacket.BasePacket;
	/**
	 * Thông tin về 1 quest trong viễn chinh
	 * @author HiepNM2
	 */
	public class ExQuestInfo 
	{
		private var _type:int;		//Loại quest 1: 2: 3:
		private var _id:int;		//id của quest
		private var _hardId:int;	//id của độ khó (tương ứng luôn với độ khó 1 -> 5)
		private var _numTaskComp:int;	//số lượng task đã hoàn thành
		
		public function ExQuestInfo() 
		{
			_numTaskComp = 0;
			_type = 0;
			_id = -1;
			_hardId = -1;
		}
		public function set Type(value:int):void 
		{
			_type = value;
		}
		public function set QuestId(value:int):void 
		{
			_id = value;
		}
		public function set HardId(value:int):void 
		{
			_hardId = value;
		}
		public function get Type():int 
		{
			return _type;
		}
		public function get QuestId():int 
		{
			return _id;
		}
		public function get HardId():int 
		{
			return _hardId;
		}
		public function get NumTaskComp():int 
		{
			return _numTaskComp;
		}
		public function set NumTaskComp(value:int):void 
		{
			_numTaskComp = value;
		}
		public function get Name():String
		{
			if (_id <= 0)
			{
				return "Unknown";
			}
			else 
			{
				return ExpeditionXML.getInstance().getQuestName(TypeXML, _id);
			}
		}
		/**
		 * Số lượng task cần thực hiện
		 */
		public function get MaxNumTask():int
		{
			if (_id <= 0 || _hardId <= 0)
			{
				return int.MAX_VALUE;
			}
			else 
			{
				var HardConf:Object = ConfigJSON.getInstance().getItemInfo("ExpeditionQuest")[_type][_id]["Hard"];
				return HardConf[_hardId];
			}
		}
		
		public function get TypeXML():String 
		{
			switch(_type) 
			{
				case 1:
					return "TaskWar";
				case 2:
					return "TaskFish";
				case 3:
					return "TaskWorld";
				default:
					return "";
			}
		}
		
		public function get TypeName():String 
		{
			switch(_type) 
			{
				case 1:
					return "Chiến thần";
				case 2:
					return "Ngư thần";
				case 3:
					return "Giới thần";
				default:
					return "";
			}
		}
		public function get Action():String
		{
			if ((_type == 1 || _type == 2 || _type == 3) && _id > 0)
			{
				return ConfigJSON.getInstance().getItemInfo("ExpeditionQuest")[_type][_id]["Action"];
			}
			else
			{
				return "";
			}
		}
		/*function*/
		/**
		 * xét xem gói cmd có phải là quest hay không
		 * @param	cmd : gói tin chuẩn bị được gửi lên
		 * @return : có phải là quest trong Viễn chinh hay không
		 */
		public function IsQuest(cmd:BasePacket):Boolean
		{
			return false;
		}
		public function setInfo(data:Object):void
		{
			if (data == null)
			{
				return;
			}
			for (var itm:String in data)
			{
				this[itm] = data[itm];
			}
		}
		public function IsComplete():Boolean
		{
			return NumTaskComp >= MaxNumTask;
		}
	}
}













