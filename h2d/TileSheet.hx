package h2d;

class TileSheet
{
	public var mainTile		: Tile;
	var groups				: Map<String, Array<Tile>>;
	
	public function new(t) {
		this.mainTile = t;
		groups = new Map<String, Array<Tile>>();
	}
	
	public inline function getTile(name : String, frame = 0) {
		return groups.get(name)[frame];
	}
	
	public inline function getGroup(name : String) {
		return groups.get(name);
	}
	
	public inline function setTile(name : String, x, y, w, h, dx = 0, dy = 0) {
		groups.set(name, [mainTile.sub(x, y, w, h, dx, dy)]);
	}
	
	public inline function pushTile(group : String, x, y, w, h, dx = 0, dy = 0) {
		var g = groups.get(group);
		if (g == null) {
			g = new Array<Tile>();
			groups.set(group, g);
		}
		g.push(mainTile.sub(x, y, w, h, dx, dy));
	}
	
	public inline function toString() {
		for (k in groups.keys()) {
			trace(k + " : " + groups.get(k));
		}
	}
}