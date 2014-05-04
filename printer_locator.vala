using Avahi;

public class PrinterLocator : Object {
	private Avahi.Client client;
	private Avahi.ServiceBrowser browser;

	public signal void found_printer(string uuid, string name, string hostname, int port, string rp, string mfg, string mdl);

	private void on_new_service(Interface @interface, Protocol protocol, string name, string type, string domain, LookupResultFlags flags) {
		ServiceResolver* resolver = new ServiceResolver(@interface, protocol, name, type, domain, Avahi.Protocol.UNSPEC, LookupFlags.NO_FLAGS);
		resolver->found.connect((fce, protocol, name, type, domain, hostname, address, port, txt, flags) => {
				this.got_printer_details(name, hostname, port, txt);
				delete resolver;
			});
		resolver->failure.connect((e) => {delete resolver;});
		try {
			resolver->attach(client);
		} catch(Avahi.Error e) {
			delete resolver;
		}
	}

	private void got_printer_details(string name, string hostname, uint16 port,  StringList txt) {
		string key;
		char[] valuec;

		string? uuid = null;
		string? rp = null;
		string? note = null;
		string? product = null;
		string? pdl = null;
		string? mfg = null;
		string? mdl = null;
		string? adminurl = null;


		for(StringList* kv = txt; kv != null; kv = kv->next) {
			kv->get_pair(out key, out valuec);
			//Begin ugly ugly hack
			string value = (string) kv->text;
			key = key.down();
			value = value.slice(key.length+1, value.length);

			switch(key) {
			case "txtvers":
				if(value != "1")
					return;
				break;
			case "uuid":
				uuid = value;
				break;
			case "rp":
				rp = value;
				break;
			case "product":
				product = value;
				break;
			case "usb_mfg":
				mfg = value;
				break;
			case "usb_mdl":
				mdl = value;
				break;
			case "adminurl":
				adminurl = value;
				break;
			case "pdl":
				pdl = value;
				break;
			case "note":
				note = value;
				break;
			}
		}
		if(uuid == null || pdl == null || rp == null || ((mfg==null||mdl==null) && product == null))
			return;

		this.found_printer(uuid, name, hostname, port, rp, mfg, mdl);
	}

	public PrinterLocator() {
		this.client = new Client();
		this.browser = new ServiceBrowser("_ipp._tcp");

		this.browser.new_service.connect(this.on_new_service);
		try {
			client.start();
			browser.attach(client);
		} catch(Avahi.Error e) {
		}
	}
}
