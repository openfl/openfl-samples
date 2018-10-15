package;


import hxp.*;
import sys.FileSystem;


class Script extends hxp.Script {
	
	
	private var samples:Array<String>;
	
	
	public function new () {
		
		super ();
		
		initHXCPPCache ();
		
		samples = [];
		findSamples ("", samples);
		
		samples.sort (function (a, b) {
			a = a.toLowerCase ();
			b = b.toLowerCase ();
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		});
		
		switch (command) {
			
			case "list":
				
				listSamples ();
			
			case "build", "run", "test", "update", "clean", "display":
				
				execSamples ();
			
			default:
				
				Log.error ("Unknown command \"" + command + "\"");
			
		}
		
	}
	
	
	private function initHXCPPCache ():Void {
		
		if (!FileSystem.exists (".hxcpp_cache")) {
			
			System.mkdir (".hxcpp_cache");
			
		}
		
		if (!flags.exists ("nocache")) {
			
			Sys.putEnv ("HXCPP_COMPILE_CACHE", Path.tryFullPath (".hxcpp_cache"));
			
		}
		
	}
	
	
	private function execSamples ():Void {
		
		var paths = [];
		
		if (commandArgs.length > 0) {
			
			var sampleName = commandArgs.shift ();
			
			for (sample in samples) {
				if (sample.split ("/").pop () == sampleName) {
					paths.push (sample);
				}
			}
			
			if (paths.length == 0 && sampleName == "all") {
				paths = samples.copy ();
			}
			
			if (paths.length == 0) {
				for (sample in samples) {
					if (StringTools.startsWith (sample, sampleName)) {
						paths.push (sample);
					}
				}
			}
			
			if (paths.length == 0) {
				Log.error ("Could not find sample name \"" + sampleName + "\"");
			}
			
		} else {
			
			paths = paths.concat (samples);
			
		}
		
		var targets = null;
		
		if (commandArgs.length > 0) {
			
			targets = commandArgs;
			
		} else {
			
			var hostPlatform = switch (System.hostPlatform) {
				case WINDOWS: "windows";
				case MAC: "mac";
				case LINUX: "linux";
				default: "";
			}
			
			targets = [];
			if (!flags.exists ("noneko")) targets.push ("neko");
			if (!flags.exists ("noneko") && !flags.exists ("nocairo")) targets.push ("neko -Dcairo");
			if (!flags.exists ("noelectron")) targets.push ("electron");
			if (!flags.exists ("noelectron") && !flags.exists ("nocanvas")) targets.push ("electron -Dcanvas");
			if (!flags.exists ("noelectron") && !flags.exists ("nodom")) targets.push ("electron -Ddom");
			if (!flags.exists ("nocpp")) targets.push (hostPlatform);
			if (!flags.exists ("noflash")) targets.push ("flash");
			
		}
		
		for (path in paths) {
			
			var sampleName = path.split ("/").pop ();
			
			for (target in targets) {
				
				var script = "lime";
				var args = [ command ];
				
				if (FileSystem.exists (Path.combine (path, "script.hx"))) {
					
					script = "hxp";
					args.push (Path.combine (path, "script.hx"));
					if (target.split (" ")[0] == "electron") continue; // TODO, MinimalApplication
					args = args.concat (target.split (" "));
					
					Log.info (Log.accentColor + script + " " + command + " " + sampleName + " " + target + Log.resetColor);
					
				} else if (FileSystem.exists (Path.combine (path, "package.json"))) {
					
					if (target != targets[0]) continue;
					script = "npm";
					if (target == "install") {
						args = [ "install", "-s" ];
					} else {
						args = [ "start", "-s" ];
					}
					
					Log.info (Log.accentColor + "cd " + path + " && " + script + " " + args.join (" ") + Log.resetColor);
					
				} else {
					
					args.push (path);
					args = args.concat (target.split (" "));
					
					Log.info (Log.accentColor + script + " " + command + " " + sampleName + " " + target + Log.resetColor);
					
				}
				
				
				
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
				
				if (target == "flash" && targets.length > 1) {
					args.push ("-notrace");
				}
				
				if (script == "npm") {
					System.runCommand (path, script, args);
				} else {
					System.runCommand ("", script, args);
				}
				
			}
			
		}
		
	}
	
	
	private function findSamples (path:String, list:Array<String>):Void {
		
		for (fileName in FileSystem.readDirectory (path != "" ? path : Sys.getCwd ())) {
			
			var filePath = Path.combine (path, fileName);
			
			if (FileSystem.isDirectory (filePath)) {
				
				var match = false;
				
				for (file in [ "project.xml", "script.hx", "package.json" ]) {
					
					if (FileSystem.exists (Path.combine (filePath, file))) {
						
						list.push (Path.standardize (filePath));
						match = true;
						break;
						
					}
					
				}
				
				if (!match) findSamples (filePath, list);
				
			}
			
		}
		
	}
	
	
	private function listSamples ():Void {
		
		for (sample in samples) {
			
			var sampleName = sample.split ("/").pop ();
			Log.println (Log.accentColor + sampleName + Log.resetColor + " (" + sample + ")");
			
		}
		
	}
	
	
}