namespace Nirlah\Http;

class Response {
	
	public header;
	public body;

	public function __construct()
	{
		let this->header = new Header();
	}

	public function toObject() -> <\stdClass>
	{
		return self::decodeJson(this->body);
	}

	public function toArray() -> array
	{
		return self::decodeJson(this->body, true);
	}

	protected static function decodeJson(const string json, const boolean toArray = false) -> array|<\stdClass>
	{
		var parsed;
		let parsed = json_decode(json, toArray);

		if json_last_error() == JSON_ERROR_NONE {
			return parsed;
		} else {
			throw new HttpException(json_last_error_msg());
		}
	}

}
