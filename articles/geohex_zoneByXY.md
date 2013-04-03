:title: Geohex.getZoneByXY
:section: blue
:tags: blue, hexscan.js, code, TL;DR, Geohex-V3, JavaScript, Ruby
:weight: 20
---
### TL;DR
### Adjacentcy

In order to be usefull beyond the basic concept HexScan needed the ability to find & return Tiles adjacent to itself. I wanted to implemnt this as a two way relation, in that we can ask a tile `T`, being a equladral hexagon, for the six tiles surounding it... `N`, `NE`, `SE`, `S`, `SW`, `NW` & Have returned some kind of pointer to those tiles. *What Kind I don't exactly know yet*. For the time being I have modeled the relationship on the [Self referential many-to-many relationship](http://datamapper.org/docs/associations.html) *followed/followers* example.

Rather than a *person* who is *followed* we have a `Tile A` that is `adjacent_to` another `Tile B`. as well, a *Tile* doesn't have followers but other tiles it is `adjacent_from`.

As the relationship between *tiles*, there defining *zones* & the relative position to each other is fixed in the context of the relevant graticule Adjacency can be calculated programmatically. This will also be required to identify *nodal* tiles later on *(more on that in a later post)*. 

In order to do that, we need a way to look up the adjacent tiles by their X Y coordinates. Then all manner of fun can be had. Unfortunately, the gem'd & ruby'd implementation of GeohexV3 that I have been using did not implement a way to do that. However, sa2da's canonical javascript does. So, long story short, I re-implemented the JS `getZoneByXY` in ruby. 

### And here is the code…

#### Original Javascript Implementation

    :::javascript
    
    function getZoneByXY(_x, _y, _level) {
	   var h_size = calcHexSize(_level);
	
	   var h_x =_x;
	   var h_y=_y;

	   var unit_x = 6 * h_size;
	   var unit_y = 6 * h_size * h_k;

	   var h_lat = (h_k * h_x * unit_x + h_y * unit_y) / 2;
	   var h_lon = (h_lat - h_y * unit_y) / h_k;

	   var z_loc = xy2loc(h_lon, h_lat);
	   var z_loc_x = z_loc.lon;
	   var z_loc_y = z_loc.lat;
	
	   var max_hsteps = Math.pow(3,_level+2);
	   var hsteps = Math.abs(h_x - h_y);
	
	   if(hsteps==max_hsteps){
		  if(h_x>h_y){
		  var tmp = h_x;
		  h_x = h_y;
		  h_y = tmp;
		  }
		  z_loc_x = -180;
	   }
	
	   var h_code ="";
	   var code3_x =new Array();
	   var code3_y =new Array();
	   var code3 ="";
	   var code9="";
	   var mod_x = h_x;
	   var mod_y = h_y;


	   for(i = 0;i <= _level+2 ; i++){
	     var h_pow = Math.pow(3,_level+2-i);
	   if(mod_x >= Math.ceil(h_pow/2)){
	     code3_x[i] = 2;
	     mod_x -= h_pow;
	   }else if(mod_x <= -Math.ceil(h_pow/2)){
	     code3_x[i] = 0;
	     mod_x += h_pow;
	   }else{
	     code3_x[i] = 1;
	   }
	  if(mod_y >= Math.ceil(h_pow/2)){
	    code3_y[i] = 2;
	    mod_y -= h_pow;
	  }else if(mod_y <= -Math.ceil(h_pow/2)){
	    code3_y[i] = 0;
	    mod_y += h_pow;
	  }else{
	    code3_y[i] = 1;
	  }
	  if(i==2&&(z_loc_x==-180 || z_loc_x>=0)){
	    if(code3_x[0]==2&&code3_y[0]==1&&code3_x[1]==code3_y[1]&&code3_x[2]==code3_y[2]){
		  code3_x[0]=1;
		  code3_y[0]=2;
		 }else if(code3_x[0]==1&&code3_y[0]==0&&code3_x[1]==code3_y[1]&&code3_x[2]==code3_y[2]){
		   code3_x[0]=0;
		   code3_y[0]=1
		  }
	   }
	 }

    for(i=0;i<code3_x.length;i++){
	   code3 += ("" + code3_x[i] + code3_y[i]);
	   code9 += parseInt(code3,3);
	   h_code += code9;
	   code9="";
	   code3="";
	 }
	 var h_2 = h_code.substring(3);
	 var h_1 = h_code.substring(0,3);
	 var h_a1 = Math.floor(h_1/30);
	 var h_a2 = h_1%30;
	 h_code = (h_key.charAt(h_a1)+h_key.charAt(h_a2)) + h_2;

	 if(GEOHEX.cache_on){
		if (!!_zoneCache[h_code])	return _zoneCache[h_code];
		  return (_zoneCache[h_code] = new Zone(z_loc_y, z_loc_x, _x, _y, h_code));
	   }else{
		  return new Zone(z_loc_y, z_loc_x, _x, _y, h_code);
	   }
    }
    
### Ruby Re-implementation

    :::ruby
    
    def getZoneByXY(x, y, level)
        h_size = calcHexSize(level)
  
        h_x = x
        h_y = y
  
        unit_x = 6 * h_size
        unit_y = 6 * h_size * H_K
  
        h_lat = (H_K * h_x * unit_x + h_y * unit_y) / 2
        h_lon = (h_lat - h_y * unit_y) / H_K
  
        z_loc = xy2loc(h_lon, h_lat)
        z_loc_x = z_loc.lon
        z_loc_y = z_loc.lat
  
        max_hsteps = 3 ** ( level + 2)
        hsteps = (h_x - h_y).abs
  
        if hsteps == max_hsteps
          if h_x > h_y
            tmp = h_x
            h_x = h_y
            h_y = tmp
          end
          z_loc_x = -180
        end
  
        h_code = ""
        code3_x = []
        code3_y = []
        code3 = ""
        code9 = ""
        mod_x = h_x
        mod_y = h_y

        (level + 3).times do |i|
          h_pow = 3 ** (level + 2 - i)
          if mod_x >= (h_pow / 2.0).ceil
            code3_x[i] = 2
            mod_x -= h_pow
          elsif mod_x <= -(h_pow / 2.0).ceil
            code3_x[i] = 0
            mod_x += h_pow
          else
            code3_x[i] = 1
          end
    
          if (mod_y >= (h_pow / 2.0).ceil)
            code3_y[i] = 2
            mod_y -= h_pow
          elsif (mod_y <= -(h_pow / 2.0).ceil)
            code3_y[i] = 0
            mod_y += h_pow
          else
            code3_y[i] = 1
          end
    
          if i == 2 && (z_loc_x == -180 || z_loc_x >= 0)
            if code3_x[0] == 2 && code3_y[0] == 1 && code3_x[1] == code3_y[1] && code3_x[2] == code3_y[2]
              code3_x[0] = 1
              code3_y[0] = 2
            elsif
              code3_x[0] == 1 && code3_y[0] == 0 && code3_x[1] == code3_y[1] && code3_x[2] == code3_y[2]
              code3_x[0] = 0
              code3_y[0] = 1
            end   
          end
    
        end
        
        code3_x.length.to_i.times do |i|
          code3 = "#{ code3_x[i] }#{ code3_y[i] }"
          code9 = code3.to_i(3).to_s
          h_code += code9.to_s
        end
        
        h_2 = h_code.slice(3, h_code.size).to_s
        h_1 = h_code.slice(0,3).to_i
        h_a1 = (h_1/30).floor.to_i
        h_a2 = h_1 % 30
        @code = "#{ H_KEY.slice(h_a1) }#{ H_KEY.slice(h_a2)}#{h_2}"
        @x = h_x
        @y = h_y
        @latitude = latitude
        @longitude = longitude
        @code
      end
      
Other then some inconsistencies in the way iteration is done in javascript, after about 4 hours of refactoring it works like a charm. I sent up my changes as a [pull request](https://github.com/toshiwo/geohex-v3/pull/1) to [toshiwo](https://github.com/toshiwo) the maintainer of the V3 gem implementation that I forked so we'll see if he thinks its worth integrating it to the main repo.