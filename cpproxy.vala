int main(string[] args) {
	HashTable<string, Printer> local = new HashTable<string, Printer> (str_hash, str_equal);
	HashTable<string, string> cloud = new HashTable<string, string> (str_hash, str_equal);

	PrinterLocator locator = new PrinterLocator();
	locator.found_printer.connect((uuid, name, hostname, port, rp, manufacturer, model) => {
			if(local.contains(uuid))
				stdout.printf("TODO: Implement update\n");
			else
				local.insert(uuid, new Printer(uuid, name, hostname, (uint16)port, rp, manufacturer, model));
		});

	PrivetServer privet = new PrivetServer();
	privet.run();

	MainLoop loop = new MainLoop();
	loop.run();
	return 0;
}