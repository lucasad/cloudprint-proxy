public class Printer : Object {
	public string UUID { get; construct; }
	public string rp { get; construct; }
	public string manufacturer { get; construct; }
	public string model { get; construct; }
	public string description { get; set; }
	public uint16 port;
	public string hostname;
	public string name;

	public Printer (string uuid, string name, string hostname, uint16 port, string rp, string mfg, string mdl) {
		GLib.Object (
			UUID: uuid,
			rp: rp,
			manufacturer: mfg,
			model: mdl);
		this.name = name;
		this.port = port;

		stdout.printf("Found printer '%s'\n", name);
	}
}