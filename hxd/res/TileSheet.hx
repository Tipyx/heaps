package hxd.res;

import hxd.res.Resource;

/**
 * ...
 * @author Tipyx
 */
class TileSheet extends Resource {
	
	var img : hxd.res.Image;
	var sheet : h2d.TileSheet;

	public function new(img:hxd.res.Image, entry) 
	{
		super(entry);
		
		this.img = img;
	}
	
	public function toTileSheet() : h2d.TileSheet {
		if (sheet != null)
			return sheet;
		
		var j = haxe.Json.parse(entry.getBytes().toString());
		if (j.meta.app != "http://www.codeandweb.com/texturepacker")
			throw "invalid data file " + "\"" + name + "\" should ba a JSON (Array or Hash) Texture Packer file";
		
		sheet = new h2d.TileSheet(img.toTile());
		
		var frames = cast(j.frames, Array<Dynamic>);
		var groups  = new Map<String, Array<{ index : Int, data : Dynamic}>>();
		var r = ~/([a-zA-Z]+)[-_]?([0-9]*)/;
		
		inline function pushFrame(group, index, data) {
			var g = groups.get(group);
			if (g == null) {
				g = [];
				groups.set(group, g);
			}
			g.push( {
				index : index != "" ? Std.parseInt(index) : 0, 
				data : data } );
		}
		
		if (Std.is(frames, Array)) for (f in frames) {
			r.match(f.filename);
			pushFrame(r.matched(1), r.matched(2), f);
		}
		else for (f in Reflect.fields(frames)) {
			r.match(f);
			pushFrame(r.matched(1), r.matched(2), Reflect.field(frames, f));
		}
		
		for (k in groups.keys()) {
			var g = groups.get(k);
			g.sort(function(a, b) return a.index - b.index);
			for (f in g) {
				var t = f.data;
				var px : Float = t.pivot.x;
				var py : Float = t.pivot.y;
				sheet.pushTile(k,
					t.frame.x, t.frame.y,
					t.frame.w, t.frame.h, 
					Std.int(t.spriteSourceSize.x - t.sourceSize.w * px),
					Std.int(t.spriteSourceSize.y - t.sourceSize.h * py));
			}
		}
		return sheet;
	}
	
}