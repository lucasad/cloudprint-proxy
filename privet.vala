public class PrivetServer : Soup.Server {
	public PrivetServer() {
		Object (port: 8088);
		assert(this != null);

		this.add_handler(null, PrivetServer.def);
	}

	private static void def(Soup.Server server, Soup.Message msg, string path, GLib.HashTable? query, Soup.ClientContext client) {
		stdout.printf("Req to '%s'\n", path);
		msg.set_response ("text/html", Soup.MemoryUse.COPY, path.data);
	}
}
