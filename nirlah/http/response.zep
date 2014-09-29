namespace Nirlah\Http;

class Response {
	
	public header;

	public function __construct() {
		let this->header = new Header();
	}

}
