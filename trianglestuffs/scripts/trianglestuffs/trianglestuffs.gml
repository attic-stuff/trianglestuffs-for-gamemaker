/**
  * vector two for a point on a triangle
  * @param {real} x position on x axis
  * @param {real} y position on y axis
  * @return {struct}
  */
function trianglestuffs_point(x, y) constructor {
	self.x = x;
	self.y = y;
	/**
	  * @description determines if some other point is the same as this point
	  * @param {struct} p the other point
	  */
	static equals = function(p) {
		return p.x == x && p.y == y;
	}
}

/**
  * vector two for an edge of a triangle
  * @param {struct} a point a on the edge
  * @param {struct} b point b on the edge
  * @returns {struct}
  */
function trianglestuffs_edge(a, b) constructor {
	self.a = a;
	self.b = b;
	///@description determines if some other edge is the same as this one
	///@param {struct} e the other edge
	static equals = function(e) {
		return (a.equals(e.a) && b.equals(e.b)) || (a.equals(e.b) && b.equals(e.a));
	}
}

/** returns a triangle !
  * @param {struct} a the first point of the triangle
  * @param {struct} b the second point of the triangle
  * @param {struct} c the third point of the triangle
  */
function trianglestuffs_triangle(a, b, c) constructor {
	self.a = a;
	self.b = b;
	self.c = c;
	self.edges = [
		new trianglestuffs_edge(a, b),
		new trianglestuffs_edge(b, c),
		new trianglestuffs_edge(c, a)
	];
	var lA = point_distance(b.x, b.y, c.x, c.y);
	var lB = point_distance(a.x, a.y, c.x, c.y);
	var lC = point_distance(b.x, b.y, a.x, a.y);
	var aA = dsin(2 * darccos(((lB*lB) + (lC*lC) - (lA*lA)) / (2*lB*lC)));
	var aB = dsin(2 * darccos(((lC*lC) + (lA*lA) - (lB*lB)) / (2*lC*lA)));
	var aC = dsin(2 * darccos(((lA*lA) + (lB*lB) - (lC*lC)) / (2*lA*lB)));
	var denominator = aA + aB + aC;
	self.circumradius = (lA*lB*lC) / sqrt((lA+lB+lC) * (lB+lC-lA) * (lC+lA-lB) * (lA+lB-lC));
	self.circumcenter = new trianglestuffs_point((a.x * aA + b.x * aB + c.x * aC) / denominator, (a.y * aA + b.y * aB + c.y * aC) / denominator);
	self.centroid = new trianglestuffs_point((a.x + b.x + c.x) / 3, (a.y + b.y + c.y) / 3);
	
	static point_is_in_circumcircle = function(p) {
		return point_in_circle(p.x, p.y, circumcenter.x, circumcenter.y, circumradius);		
	}
	
	static point_is_in_triangle = function(p) {
		return point_in_triangle(p.x, p.y, a.x, a.y, b.x, b.y, c.x, c.y);
	}
}

/**
  * create a right triangle that encompasses a whole ass rectangle
  * @param {real} x1 the left-most coordinate of the rectangle
  * @param {real} y1 the top-most coordinate of the rectangle
  * @param {real} x2 the right-most coordinate of the rectangle
  * @param {real} y2 the bottom-most coordinate of the rectnalge
  * @return {struct}
  */
function trianglestuffs_create_super_triangle(x1, y1, x2, y2) {
	var width = x2 - x1;
	var height = y2 - y1;
	var margin = 10;
	var a = new trianglestuffs_point(x1 - margin, y2 + margin);
	var b = new trianglestuffs_point(x2 + width + margin, y2 + margin);
	var c = new trianglestuffs_point(x1 - margin, y1 - height - margin);
	return new trianglestuffs_triangle(a, b, c);
}

/**
  * validate a triangle
  * @param {struct} a the first point
  * @param {struct} b the second point
  * @param {struct} c the third point
  * @return {bool}
  */
function trianglestuffs_validate_triangle(a, b, c) {
	var A = point_distance(b.x, b.y, c.x, c.y);
	var B = point_distance(a.x, a.y, c.x, c.y);
	var C = point_distance(b.x, b.y, a.x, a.y);
	return (A + B > C) && (B + C > A) && (A + C > B);	
}

/** 
  * reates a convex hull around a series of points using the monotone chain algorithm
  * @array
  * @param {array} points the list of points
  * @param {bool} wrap if true then the first and last points on the return array will be the same
  * @return {array}
  */
function trianglestuffs_form_convex_hull(points, wrap = false) {
	array_sort(points, function(a, b) {
		if (a.x == b.x) {
			return a.y - b.y;
		}
		return a.x - b.x;
	});
	static cross_product = function(origin, a, b) {
		return (a.x - origin.x) * (b.y - origin.y) - (a.y - origin.y) * (b.x - origin.x);
	}
	var upper = [];
	var lower = [];
	var hull = [];
	var iterations = array_length(points);
	if (iterations < 3) {
		return hull;
	}
	for (var i = 0; i < iterations; i++) {
		var length = array_length(lower);
		while (length > 1 && cross_product(points[i], lower[length - 2], lower[length - 1]) <= 0) {
			array_delete(lower, length - 1, 1);
			length = array_length(lower);
		}
		array_push(lower, points[i]);
	}
	for (var i = iterations - 1; i > -1; i--) {
		var length = array_length(upper);
		while (length > 1 && cross_product(points[i], upper[length - 2], upper[length - 1]) <= 0) {
			array_delete(upper, length - 1, 1);
			length = array_length(upper);
		}
		array_push(upper, points[i]);
	}
	array_delete(lower, array_length(lower) - 1, 1);
	if (wrap == false) {
		array_delete(upper, array_length(upper) - 1, 1);
	}
	array_copy(hull, 0, lower, 0, array_length(lower));
	array_copy(hull, array_length(hull), upper, 0, array_length(upper));
	return hull;
}
	
/**
  * solves a constrained mesh of delaunay triangles using the bowyer watson algorithm
  * @param {array} points the list of points in the triangulation
  * @param {struct.trianglestuffs_triangle} super the super triangle containing all points
  * @param {bool} convert whether or not to return a ds list or an array
  */
function trianglestuffs_form_mesh(points, super, convert = false) {
	var length = array_length(points);
	var triangles = ds_list_create();
	triangles[| 0] = super;
	var discard = ds_list_create();
	for (var i = 0; i < length; i++) {
		var origin = points[i];
		ds_list_clear(discard);
		for (var j = ds_list_size(triangles) - 1; j > -1; j--) {
			if (triangles[| j].point_is_in_circumcircle(origin) == true) {
				ds_list_add(discard, triangles[| j]);
				ds_list_delete(triangles, j);
			}	
		}
		for (var j = 0, dim = ds_list_size(discard); j < dim; j++) {
			var eu0 = true;
			var eu1 = true;
			var eu2 = true;
			for (var k = 0; k < dim; k++) {
				if (eu0 + eu1 + eu2 == 0) {
					break;
				}
				if (discard[| j] != discard[| k]) {
					if (eu0 == true && (discard[| j].edges[0].equals(discard[| k].edges[0]) || discard[| j].edges[0].equals(discard[| k].edges[1]) || discard[| j].edges[0].equals(discard[| k].edges[2]))) {
						eu0 = false;
					}
					if (eu1 == true && (discard[| j].edges[1].equals(discard[| k].edges[0]) || discard[| j].edges[1].equals(discard[| k].edges[1]) || discard[| j].edges[1].equals(discard[| k].edges[2]))) {
						eu1 = false;
					}
					if (eu2 == true && (discard[| j].edges[2].equals(discard[| k].edges[0]) || discard[| j].edges[2].equals(discard[| k].edges[1]) || discard[| j].edges[2].equals(discard[| k].edges[2]))) {
						eu2 = false;
					}
				}
			}
			//AUTHOR'S NOTE if you are getting errors uncomment the validations
			if (eu0) {
				var pb = discard[| j].edges[0].a;
				var pc = discard[| j].edges[0].b;
				//if (trianglestuffs_validate_triangle(origin, pb, pc)) {
					ds_list_add(triangles, new trianglestuffs_triangle(origin, pb, pc));
				//}
			}
			if (eu1) {
				var pb = discard[| j].edges[1].a;
				var pc = discard[| j].edges[1].b;
				//if (trianglestuffs_validate_triangle(origin, pb, pc)) {
					ds_list_add(triangles, new trianglestuffs_triangle(origin, pb, pc));
				//}
			}
			if (eu2) {
				var pb = discard[| j].edges[2].a;
				var pc = discard[| j].edges[2].b;
				//if (trianglestuffs_validate_triangle(origin, pb, pc)) {
					ds_list_add(triangles, new trianglestuffs_triangle(origin, pb, pc));
				//}
			}
		}
	}
	for (var i = ds_list_size(triangles) - 1; i > -1; i--) {
		var iteration = triangles[| i];
		if (iteration.a.equals(super.a) || iteration.a.equals(super.b) || iteration.a.equals(super.c) ||
			iteration.b.equals(super.a) || iteration.b.equals(super.b) || iteration.b.equals(super.c) ||
			iteration.c.equals(super.a) || iteration.c.equals(super.b) || iteration.c.equals(super.c)) {
			ds_list_delete(triangles, i);
		}
	}
	ds_list_destroy(discard);
	if (convert) {
		var count = ds_list_size(triangles);
		var array = array_create(count);
		for (var i = 0; i < count; i++) {
			array[i] = triangles[| i];	
		}
		ds_list_destroy(triangles);
		triangles = array;
	}
	return triangles;
}