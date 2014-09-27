namespace Nirlah\Http;

class Request {

	protected curl;
	protected uri;
	protected header;
	protected options = [];

	public function __construct()
	{
		// Check for CURL extension:
		if !extension_loaded("curl") {
			throw new HttpException("The \"curl\" extension is required.");
		}

		let this->curl = curl_init();
		let this->uri = new Uri();
		let this->header = new Header();
		this->setDefaultOptions();
	}

	public function __destruct()
	{
		curl_close(this->curl);
	}

	//
	// Uri
	//

	public function setBaseUri(const string uri) -> void
	{
		let this->uri = new Uri(uri);
	}

	public function getUri() -> string
	{
		return this->uri->build();
	}

	public function resolveUri(const string path) -> string
	{
		return this->uri->resolve(path);
	}

	//
	// Options
	//

	protected function setDefaultOptions() -> void
	{
		array options = [];
		this->setOption(options);
	}

	public function setOption(const option, value = null) -> void
	{
		if typeof option == "array" {
			var key;
			for key, value in option {
				let this->options[key] = value;
			}
		} else {
			let this->options[option] = value;
		}
	}

	public function getOption(const option) -> var|null
	{
		if isset(this->options[option]) {
			return this->options[option];
		} else {
			return null;
		}
	}

}
