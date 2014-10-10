namespace Nirlah\Http;

class Uri {

	protected _protocol = "http";
	protected _secure = false;
	protected _baseUri = "";
	protected _path = "";
	protected _params;
	protected _user;
	protected _pass;
	protected _port;

	public function __construct(const config = null)
	{
		if config != null {
			if typeof config == "array" {
				var component, value;
				for component, value in config {
					let this->{component} = value;
				}
			} else {
				this->parse(config);
			}
		}
	}

	public function __toString() -> string
	{
		return this->build();
	}

	public function parse(const string uri) -> void
	{
		this->setBaseUri(uri);
	}

	public function resolve(path) -> string
	{
		var protocol, auth, query, port;
		let protocol = this->buildProtocol(),
			auth = this->buildAuth(),
			query = this->buildQuery(),
			port = this->buildPort();

		// Remove trailing slash:
		if substr(path, -1) == "/" {
			let path = substr(path, 0, -1);
		}

		boolean isEmptyPath;
		let isEmptyPath = empty(this->_path);
		// Extend or replace?
		if substr(path, 0, 1) == "/" {
			let path = substr(path, 1);
		} elseif !isEmptyPath {
			let path = this->_path . "/" . path;
		}

		return protocol.auth.this->_baseUri.port."/".path.query;
	}

	public function resolveQuery(query, boolean json = false) -> string
	{
		var protocol, auth, port, count;
		let protocol = this->buildProtocol(),
			auth = this->buildAuth(),
			port = this->buildPort();

		let count = count(query);
		if count == 0 {
			let query = "";
		} elseif is_array(query) {
			var pairs = [], key, value;
			for key, value in query {
				if json {
					let value = json_encode(value);
				}
				if typeof key == "string" {
					let pairs[] = urlencode(key)."=".urlencode(value);
				} else {
					let pairs[] = urlencode(value);
				}
			}
			let query = "?".implode("&", pairs);
		} else { // string
			if substr(query, 0, 1) != "?" {
				let query = "?".query;
			}
		}

		return protocol.auth.this->_baseUri.port."/".this->_path.query;
	}

	public function build() -> string
	{
		var protocol, auth, query, port;
		let protocol = this->buildProtocol(),
			auth = this->buildAuth(),
			query = this->buildQuery(),
			port = this->buildPort();
		return protocol.auth.this->_baseUri.port."/".this->_path.query;
	}

	protected function buildProtocol() -> string
	{
		var protocol = "";
		if isset(this->_protocol) {
			let protocol = "".this->_protocol;
			if this->_secure {
				let protocol .= "s";
			}
			let protocol .= "://";
		}
		return protocol;
	}

	protected function buildAuth() -> string
	{
		var auth = "";
		if empty(this->_user) == false {
			let auth = "".this->_user;
			if empty(this->_pass) == false {
				let auth .= ":".this->_pass;
			}
			let auth .= "@";
		}
		return auth;
	}

	protected function buildQuery() -> string
	{
		var query = "", key, value;
		if empty(this->_params) == false {
			let query = "?";
			var pairs = [];
			for key, value in this->_params {
				if typeof key == "string" {
					let pairs[] = key."=".value;
				} else {
					let pairs[] = value;
				}
			}
			let query .= implode("&", pairs);
		}
		return query;
	}

	protected function buildPort() -> string
	{
		var port = "";
		if empty(this->_port) == false {
			let port = ":".this->_port;
		}
		return port;
	}

	// 
	// Components Access
	//

	protected function validateComponentExists(const string component) -> void
	{
		var list = ["protocol","secure","baseUri","path","params","user","pass","port"];
		if in_array(component, list) == false {
			throw new HttpException("The component \"".component."\" is not a part of the uri.");
		}
	}

	public function __get(string component) -> var
	{
		this->validateComponentExists(component);
		string method;
		let method = "get".component->upperfirst();
		if method_exists(this, method) {
			return this->{method}();
		} // else:
		let component = "_".component;
		return this->{component};
	}

	public function __set(string component, const value) -> void
	{
		this->validateComponentExists(component);
		string method;
		let method = "set".component->upperfirst();
		if method_exists(this, method) {
			this->{method}(value);
		} else {
			let component = "_".component;
			let this->{component} = value;
		}
	}

	public function __unset(string component) -> void
	{
		this->validateComponentExists(component);
		let component = "_".component;
		let this->{component} = null;
	}

	public function __isset(string component) -> boolean
	{
		this->validateComponentExists(component);
		let component = "_".component;
		return empty(this->{component}) == false;
	}

	// Protocol

	protected function setProtocol(value) -> void
	{
		if substr(value, -1) == "s" {
			let value = (string) substr(value, 0, -1);
			let this->_secure = true;
		}
		let this->_protocol = value;
	}

	protected function getProtocol() -> string
	{
		if this->_secure {
			return this->_protocol."s";
		} else {
			return this->_protocol;
		}
	}

	// Secure

	protected function setSecure(const bool value) -> void
	{
		let this->_secure = value;
	}

	// BaseUri

	protected function setBaseUri(uri) -> void
	{
		var parts;
		
		// Protocol
		let parts = explode("://", uri, 2);
		if count(parts) > 1 {
			this->setProtocol(parts[0]);
			let uri = (string) parts[1];
		}

		// Auth
		let parts = explode("@", uri, 2);
		if count(parts) > 1 {
			this->setAuth((string) parts[0]);
			let uri = (string) parts[1];
		}

		// Query
		let parts = explode("?", uri, 2);
		if count(parts) > 1 {
			this->setParams((string) parts[1]);
			let uri = (string) parts[0];
		}

		// Path
		let parts = explode("/", uri, 2);
		if count(parts) > 1 {
			this->setPath("/".parts[1]);
			let uri = (string) parts[0];
		}

		// Port
		let parts = explode(":", uri, 2);
		if count(parts) > 1 {
			this->setPort(parts[1]);
			let uri = (string) parts[0];
		}

		// Remove trailing slash
		if substr(uri, -1) == "/" {
			let uri = substr(uri, 0, -1);
		}

		let this->_baseUri = uri;
	}

	// Path

	protected function setPath(value) -> void
	{
		// remove trailing slash:
		if substr(value, -1) == "/" {
			let value = substr(value, 0, -1);
		}

		// remove leadig slash:
		if substr(value, 0, 1) == "/" {
			let value = substr(value, 1);
		}

		let this->_path = value;
	}

	// Params / Query

	protected function setParams(query) -> void
	{
		if typeof query == "array" {
			let this->_params = query;
		} else {
			var pairs, pair, params = [];
			if substr(query, 0, 1) == "?" {
				let query = substr(query, 1);
			}
			let pairs = explode("&", query);
			for pair in pairs {
				if strpos(pair, "=") !== false {
					var parts;
					let parts = explode("=", pair);
					let params[parts[0]] = parts[1];
				} else {
					let params[] = pair;
				}
			}
			let this->_params = params;
		}
	}

	// Auth

	protected function setAuth(const string auth) -> void
	{
		var parts;
		let parts = explode(":", auth, 2);
		let this->_user = parts[0];
		let this->_pass = parts[1];
	}

	// Port

	protected function setPort(const port) -> void
	{
		var match = [];
		if preg_match("/(\\d+)/", port, match) {
			let this->_port = (int) match[1];
		}
	}
	
}
