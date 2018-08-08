import hxp.*;
import sys.FileSystem;

class Script extends hxp.Script {
	
	public function new () {
		
		super ();
		
		var paths = [];
		findPaths ("demos", paths);
		findPaths ("features/display", paths);
		findPaths ("features/display3D", paths);
		findPaths ("features/events", paths);
		findPaths ("features/external", paths);
		findPaths ("features/media", paths);
		findPaths ("features/text", paths);
		findPaths ("features/ui", paths);
		findPaths ("libraries/actuate", paths);
		findPaths ("libraries/box2d", paths);
		findPaths ("libraries/layout", paths);
		
		if (command == "list") {
			
			for (path in paths) {
				Log.println (path);
			}
			
		} else {
			
			if (commandArgs.length > 0) {
				var sampleName = commandArgs.shift ();
				var match = false;
				for (path in paths) {
					if (path.split ("/").pop () == sampleName) {
						paths = [ path ];
						match = true;
						break;
					}
				}
				if (!match) {
					paths = [];
					if (sampleName == "features") {
						findPaths ("features/display", paths);
						findPaths ("features/display3D", paths);
						findPaths ("features/events", paths);
						findPaths ("features/external", paths);
						findPaths ("features/media", paths);
						findPaths ("features/text", paths);
						findPaths ("features/ui", paths);
					} else if (sampleName == "libraries") {
						findPaths ("libraries/actuate", paths);
						findPaths ("libraries/box2d", paths);
						findPaths ("libraries/layout", paths);
					} else if (FileSystem.exists (Path.combine ("haxelib", sampleName))) {
						findPaths (sampleName, paths);
					} else {
						commandArgs.unshift (sampleName);
					}
				}
			}
			
			var targets;
			if (commandArgs.length > 0) {
				targets = commandArgs;
			} else {
				var hostPlatform = switch (System.hostPlatform) {
					case WINDOWS: "windows";
					case MAC: "mac";
					case LINUX: "linux";
					default: "";
				}
				if (System.hostPlatform != MAC) {
					targets = [ "neko", "neko -Dcairo", "flash", hostPlatform, "electron", "electron -Dcanvas", "electron -Ddom" ];
				} else {
					targets = [ "neko", "neko -Dcairo", /*"flash", hostPlatform,*/ "electron", "electron -Dcanvas", "electron -Ddom" ];
				}
			}
			
			for (path in paths) {
				var sampleName = Path.standardize (path).split ("/").pop ();
				for (target in targets) {
					Log.info (Log.accentColor + "Running Command: " + command + " " + sampleName + " " + target + Log.resetColor);
					if (FileSystem.exists (Path.combine (path, "script.hx"))) {
						if (target == "electron") continue; // TODO
						var args = [ command, Path.combine (path, "script.hx") ].concat (target.split (" "));
						for (flag in flags.keys ()) {
							args.push ("-" + flag);
						}
						for (define in defines.keys ()) {
							args.push ("-D");
							if (defines.get (define) != "") {
								args.push (define + "=" + defines.get (define));
							} else {
								args.push (define);
							}
						}
						System.runCommand ("", "hxp", args);
					} else {
						var args = [ command, path, ].concat (target.split (" "));
						for (flag in flags.keys ()) {
							args.push ("-" + flag);
						}
						for (define in defines.keys ()) {
							args.push ("-D");
							if (defines.get (define) != "") {
								args.push (define + "=" + defines.get (define));
							} else {
								args.push (define);
							}
						}
						if (target == "flash") args.push ("-notrace");
						System.runCommand ("", "lime", args);
					}
				}
			}
			
		}
		
	}
	
	private function findPaths (directory:String, paths:Array<String>):Void {
		
		directory = Path.combine (Path.combine (Sys.getCwd (), "haxelib"), directory);
		for (path in FileSystem.readDirectory (directory)) {
			path = Path.combine (directory, path);
			if (FileSystem.isDirectory (path)) {
				paths.push (Path.standardize (path));
			}
		}
		
	}
	
}