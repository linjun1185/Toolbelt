namespace Nirlah\Neo4j\Connections;

use Nirlah\Http\Request;
use Nirlah\Http\Response;
use Nirlah\Http\Uri;
use Nirlah\Http\Exception;
use Nirlah\Neo4j\Neo4jException;

class Connection {

	const DATA_PATH = "db/data";

	protected host;
	protected port;
	protected secure;
	protected user;
	protected pass;

	public function __construct(const host = null, const int port = null, const boolean secure = false, const string user = null, const string pass = null)
	{
		if host != null {
			this->config(host, port, user, pass);
		}
	}

	public function config(const host, const int port = null, const boolean secure = false, const string user = null, const string pass = null) -> void
	{
		if typeof host == "array" {
			this->arrayConfig(host);
		} else {
			let this->host = host,
			this->port = port,
			this->secure = secure,
			this->user = user,
			this->pass = pass;	
		}
	}

	protected function arrayConfig(const array config) -> void
	{
		var component;
		for component in ["host","port","secure","user","pass"] {
			if isset(config[component]) {
				let this->{component} = config[component];
			}
		}
	}

	// ->post(path = "", params = []);
	public function __call(const string method, const array arguments) -> <Response>
	{
		if !in_array(method->lower(), ["get","post","put","delete"]) {
			throw new Neo4jException("The method \"".method->upper()."\" is not supported.");
		}

		var request;
		let request = this->buildRequest();

		if isset(arguments[1]) && !empty(arguments[1]) {
			request->setParams(arguments[1]);
		}

		var path = "";
		if isset(arguments[0]) && !empty(arguments[0]) {
			if substr(arguments[0], 0, 1) == "/" {
				let path = substr(arguments[0], 1);
			} else {
				let path = arguments[0];
			}
		}

		return request->{method}(path);
	}

	protected function buildRequest()
	{
		if empty(this->host) {
			throw new Neo4jException("The connection must be configured before executing requests.");
		}

		var uri;
		let uri = new Uri;
		let uri->baseUri = this->host;
		let uri->path = self::DATA_PATH;
		let uri->port = this->port;
		let uri->secure = this->secure;
		let uri->user = this->user;
		let uri->pass = this->pass;

		var request;
		let request = new Request;
		request->setBaseUri(uri);
		return request;
	}

}
