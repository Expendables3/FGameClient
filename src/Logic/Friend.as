package Logic 
{
	/**
	 * ...
	 * @author Hien
	 */
	public class Friend
	{
		public var ID: int; // ID nguoi choi
		public var NickName: String; // Nickname nguoi choi
		public var imgName: String; // Anh avatar
		public var Level: int;
		public var Exp: int;
		public var Index: int;
		public var IsChoose: Boolean = false;
		
		public function Friend()
		{
			
		}		
		public function Init(ID: int,imgName: String, NickName: String,Index: int): void
		{
			ID = ID;
			imgName = imgName;			
			NickName = NickName;
			Index = Index;
		}		
	}

}