/**
 * triangle vertex data structure
 * @param {real} x vertex x coordinate
 * @param {real} y vertex y coordinate
 */
function trianglestuffs_vertex(x, y) constructor {
	self.x = x;
	self.y = y;
	
	/**
	 * determines equality of two triangle vertices
	 * @param {struct.trianglestuffs_vertex} other_vertex the vertex to compare
	 * @returns {bool}
	 */
	static equals_vertex = function(other_vertex) {
		return x == other_vertex.x and y == other_vertex.y;
	}
}

/**
 * triangle edge data structure
 * @param {struct.trianglestuffs_vertex} vertex_a line segment vertex one
 * @param {struct.trianglestuffs_vertex} vertex_b line segment vertex two
 */
function trianglestuffs_edge(vertex_a, vertex_b) constructor {
	self.vertex_a = vertex_a;
	self.vertex_b = vertex_b;
	self.length = point_distance(vertex_a.x, vertex_a.y, vertex_b.x, vertex_b.y);
	
	/**
	 * returns the standard for of this line; ax + by = c
	 * @returns {struct}
	 */
	static get_line_equation = function() {
		var a = vertex_b.y - vertex_a.y;
		var b = vertex_a.x - vertex_b.x;
		var c = a * vertex_a.x + b * vertex_a.y;
		
		return { a, b, c };
		
	}
	
	/**
	 * returns standard form of the perpindicular bisector
	 * @returns {struct}
	 */
	static get_perpindicular_line_equation = function() {
		var midpoint_x = (vertex_a.x + vertex_b.x) * 0.5;
		var midpoint_y = (vertex_a.y + vertex_b.y) * 0.5;
		
		var a = -(vertex_a.x - vertex_b.x);
		var b = vertex_b.y - vertex_a.y;
		var c = a * midpoint_x + b * midpoint_y;
		
		return { a, b, c };
		
	}
	
	/**
	 * determines equality of two triangle edges
	 * @param {struct.trianglestuffs_edge} other_edge the edge to compare
	 * @returns {bool}
	 */	
	static equals_edge = function(other_edge) {
		if ((vertex_a.equals_vertex(other_edge.vertex_a) and vertex_b.equals_vertex(other_edge.vertex_b)) or (vertex_a.equals_vertex(other_edge.vertex_b) and vertex_b.equals_vertex(other_edge.vertex_a))) {
			return true;
		}
		return false;
	}
}

/**
 * triangle data structure
 * @param {struct.trianglestuffs_vertex} vertex_a triangle point a
 * @param {struct.trianglestuffs_vertex} vertex_b triangle point b
 * @param {struct.trianglestuffs_vertex} vertex_c triangle point c
 */
function trianglestuffs_triangle(vertex_a, vertex_b, vertex_c) constructor {
	self.vertex_a = vertex_a;
	self.vertex_b = vertex_b;
	self.vertex_c = vertex_c;
	
	self.edge_list = [
		new trianglestuffs_edge(vertex_a, vertex_b),
		new trianglestuffs_edge(vertex_b, vertex_c),
		new trianglestuffs_edge(vertex_c, vertex_a),
	];
	
	var length_a = edge_list[0].length;
	var length_b = edge_list[1].length;
	var length_c = edge_list[2].length;
	 
	self.circumcenter = undefined;
	self.circumradius = undefined;
	
	self.centroid = new trianglestuffs_vertex(mean(vertex_a.x, vertex_b.x, vertex_c.x), mean(vertex_a.y, vertex_b.y, vertex_c.y));
	
	self.valid = true;
	if (length_a + length_b <= length_c or length_a + length_c <= length_b or length_b + length_c <= length_a) {
		valid = false;
	}
	
	var line_a = edge_list[0].get_perpindicular_line_equation();
	var line_b = edge_list[1].get_perpindicular_line_equation();
	self.circumcenter = trianglestuffs_get_line_intersect(line_a, line_b);
	self.circumradius = point_distance(circumcenter.x, circumcenter.y, vertex_a.x, vertex_a.y);		

	/**
	 * test if a point falls within the circumcircle of this triangle
	 * @param {struct.trianglestuffs_vertex} vertex the point to test
	 * @returns {bool}
	 */
	static vertex_in_circumcircle = function(vertex) {
		return point_in_circle(vertex.x, vertex.y, circumcenter.x, circumcenter.y, circumradius);
	}
	
	/**
	 * returns the barycentric coordinates of a point in this triangle
	 * @param {real} x x position to test
	 * @param {real} y y position to test
	 * @param {real} [sorting] trianglestuffs_sort_order.no_sort / clockwise / counter_clockwise
	 * @returns {struct}
	 */
	static fetch_barycentric_coordinates = function(x, y, sorting = trianglestuffs_sort_order.no_sort) {

		static coordinates = {
			u : 0,
			v : 0,
		}
		
		enum trianglestuffs_sort_order {
			no_sort,
			clockwise,
			counter_clockwise
		}
		
		var vertex_set = [ vertex_a, vertex_b, vertex_c ];
		if (sorting != trianglestuffs_sort_order.no_sort) {
			array_sort(vertex_set, function(vertex_one, vertex_two) {
				return (centroid.x - vertex_two.x) - (centroid.x - vertex_one.x);
			});
			
			if (sorting == trianglestuffs_sort_order.counter_clockwise) {
				array_reverse_ext(vertex_set);
			}
		}
		
		var component_a_x_length = vertex_set[1].x - vertex_set[0].x;
		var component_a_y_length = vertex_set[1].y - vertex_set[0].y;
		
		var component_b_x_length = vertex_set[2].x - vertex_set[0].x;
		var component_b_y_length = vertex_set[2].y - vertex_set[0].y;
		
		var component_c_x_length = x - vertex_set[0].x;
		var component_c_y_length = y - vertex_set[0].y;
		
		var dot_a = dot_product(component_a_x_length, component_a_y_length, component_a_x_length, component_a_y_length);
		var dot_b = dot_product(component_a_x_length, component_a_y_length, component_b_x_length, component_b_y_length);
		var dot_c = dot_product(component_b_x_length, component_b_y_length, component_b_x_length, component_b_y_length);
		var dot_d = dot_product(component_c_x_length, component_c_y_length, component_a_x_length, component_a_y_length);
		var dot_e = dot_product(component_c_x_length, component_c_y_length, component_b_x_length, component_b_y_length);
		
		var denominator = dot_a * dot_c - dot_b * dot_b;
		
		coordinates.u = (dot_c * dot_d - dot_b * dot_e) / denominator;
		coordinates.v = (dot_a * dot_e - dot_b * dot_d) / denominator;
		
		return coordinates;
		
	}
}


/**
 * bowyer-watson triangulation of a set of points
 * @param {array<struct.trianglestuffs_vertex>} point_set the points for triangulation
 * @returns {array<struct.trianglestuffs_triangle>}
 */
function trianglestuffs_get_triangulation(point_set) {
	
	var super_triangle = trianglestuffs_create_super_triangle(point_set);
	
	var good_triangles = [super_triangle];
	var polygon_edges = [];
	
	var point_count = array_length(point_set);
	if (point_count < 3) {
		return [];
	}
	
	for (var vertex_index = 0; vertex_index < point_count; vertex_index = vertex_index + 1) {
		
		polygon_edges = [];
		var vertex_a = point_set[vertex_index];
		
		for (var triangle_index = array_length(good_triangles) - 1; triangle_index > -1; triangle_index = triangle_index - 1) {
			
			var this_triangle = good_triangles[triangle_index];
			if (this_triangle.vertex_in_circumcircle(vertex_a) == true) {
				array_delete(good_triangles, triangle_index, 1);
				
				var edge_a_unique = true;
				var edge_a = this_triangle.edge_list[0];
				
				var edge_b_unique = true;
				var edge_b = this_triangle.edge_list[1];
				
				var edge_c_unique = true;
				var edge_c = this_triangle.edge_list[2];
				
				for (var edge_index = array_length(polygon_edges) - 1; edge_index > -1; edge_index = edge_index - 1) {
					
					if (edge_a_unique == false and edge_b_unique == false and edge_c_unique == false) {
						break;
					}
					
					var this_edge = polygon_edges[edge_index];
					
					if (edge_a_unique == true and edge_a.equals_edge(this_edge) == true) {
						array_delete(polygon_edges, edge_index, 1);
						edge_a_unique = false;
						continue;
					}
					if (edge_b_unique == true and edge_b.equals_edge(this_edge) == true) {
						array_delete(polygon_edges, edge_index, 1);
						edge_b_unique = false;
						continue;
					}
					if (edge_c_unique == true and edge_c.equals_edge(this_edge) == true) {
						array_delete(polygon_edges, edge_index, 1);
						edge_c_unique = false;
						continue;
					}
				}
				
				if (edge_a_unique == true) {
					array_push(polygon_edges, edge_a);
				}
				if (edge_b_unique == true) {
					array_push(polygon_edges, edge_b);
				}
				if (edge_c_unique == true) {
					array_push(polygon_edges, edge_c);
				}
				
			}
			
		}
		
		for (var edge_index = array_length(polygon_edges) - 1; edge_index > -1; edge_index = edge_index - 1) {
		
			var this_edge = polygon_edges[edge_index];
			var vertex_b = this_edge.vertex_a;
			var vertex_c = this_edge.vertex_b;
			
			var potential_triangle = new trianglestuffs_triangle(vertex_a, vertex_b, vertex_c);
			if (potential_triangle.valid == true) {
				array_push(good_triangles, potential_triangle);
			}
			
		}
		
	}

	var super_a = super_triangle.vertex_a;
	var super_b = super_triangle.vertex_b;
	var super_c = super_triangle.vertex_c;
	
	for (var index = array_length(good_triangles) - 1; index > -1; index = index - 1) {
		var this_triangle = good_triangles[index];
		if (this_triangle.vertex_a.equals_vertex(super_a) == true or this_triangle.vertex_a.equals_vertex(super_b) == true or this_triangle.vertex_a.equals_vertex(super_c) or
			this_triangle.vertex_b.equals_vertex(super_a) == true or this_triangle.vertex_b.equals_vertex(super_b) == true or this_triangle.vertex_b.equals_vertex(super_c) or
			this_triangle.vertex_c.equals_vertex(super_a) == true or this_triangle.vertex_c.equals_vertex(super_b) == true or this_triangle.vertex_c.equals_vertex(super_c)) {
			
			array_delete(good_triangles, index, 1);
			
		}
	}
	
	return good_triangles;	
	
}

function ___trianglestuffs_cross_product(vertex_a, vertex_b, vertex_c) {
	return (vertex_b.x - vertex_a.x) * (vertex_c.y - vertex_a.y) - (vertex_b.y - vertex_a.y) * (vertex_c.x - vertex_a.x);
}

/**
 * compute andrew's monotone chain convex hull on a set of points
 * @param {array<struct.trianglestuffs_vertex>} point_set points to be bound
 * @returns {array<struct.trianglestuffs_vertex>}
 */
function trianglestuffs_get_convex_hull(point_set) {
	
	var number_of_points = array_length(point_set);
	if (number_of_points < 3) {
		return [];
	}
	
	array_sort(point_set, function(point_a, point_b) {
		if (point_a.x == point_b.x) {
			return point_a.y - point_b.y;
		}
		return point_a.x - point_b.x;
	});
	
	var upper_vertices = [];
	var lower_vertices = [];
	
	for (var point_index = number_of_points - 1; point_index > -1; point_index = point_index - 1) {
		
		var upper_vertex_count = array_length(upper_vertices);
		while (upper_vertex_count > 1 and ___trianglestuffs_cross_product(point_set[point_index], upper_vertices[upper_vertex_count - 2], upper_vertices[upper_vertex_count - 1]) <= 0) {
			array_pop(upper_vertices);
			upper_vertex_count = array_length(upper_vertices);
		}
		array_push(upper_vertices, point_set[point_index]);
	}
	
	for (var point_index = 0; point_index < number_of_points; point_index = point_index + 1) {
		
		var lower_vertex_count = array_length(lower_vertices);
		while (lower_vertex_count > 1 and ___trianglestuffs_cross_product(point_set[point_index], lower_vertices[lower_vertex_count - 2], lower_vertices[lower_vertex_count - 1]) <= 0) {
			array_pop(lower_vertices);
			lower_vertex_count = array_length(lower_vertices);
		}
		array_push(lower_vertices, point_set[point_index]);
	}
	
	array_pop(upper_vertices);
	array_pop(lower_vertices);
	
	return array_concat(upper_vertices, lower_vertices);
	
}

/**
 * determine the intersection points of two standard form lines
 * @param {struct} line_a line equation one
 * @param {struct} line_b line equation two
 * @returns {struct.trianglestuffs_vertex}
 */
function trianglestuffs_get_line_intersect(line_a, line_b) {
	var a1 = line_a.a;
	var b1 = line_a.b;
	var c1 = line_a.c;
	
	var a2 = line_b.a;
	var b2 = line_b.b;
	var c2 = line_b.c;
	
	var cramer_determinant = a1 * b2 - a2 * b1;
	
	var intersection_x = (b2 * c1 - b1 * c2) / cramer_determinant;
	var intersection_y = (a1 * c2 - a2 * c1) / cramer_determinant;
	
	return new trianglestuffs_vertex(intersection_x, intersection_y);	
}

/**
 * create a triangle in superposition; holding all points
 * @param {array<struct.trianglestuffs_vertex>} point_set the points to triangulate
 * @returns {struct.trianglestuffs_triangle}
 */
function trianglestuffs_create_super_triangle(point_set) {
	var minimum_x = infinity;
	var minimum_y = infinity;
	
	var maximum_x = -infinity;
	var maximum_y = -infinity;
	
	var number_of_points = array_length(point_set);
	for (var index = 0; index < number_of_points; index = index + 1) {
		
		var point_x = point_set[index].x;
		var point_y = point_set[index].y;
		
		minimum_x = point_x < minimum_x ? point_x : minimum_x;
		minimum_y = point_y < minimum_y ? point_y : minimum_y;
		
		maximum_x = point_x > maximum_x ? point_x : maximum_x;
		maximum_y = point_y > maximum_y ? point_y : maximum_y;
		
	}
	
	var square_size = max(maximum_x - minimum_x, maximum_y - minimum_y);
	
	var vertex_a = new trianglestuffs_vertex(minimum_x - (square_size * 2), maximum_y + square_size);
	var vertex_b = new trianglestuffs_vertex(vertex_a.x + (square_size * 2.5), minimum_y - (square_size));
	var vertex_c = new trianglestuffs_vertex(maximum_x + (square_size * 2), maximum_y + square_size);
	
	return new trianglestuffs_triangle(vertex_a, vertex_b, vertex_c);
	
}

/**
 * returns a flattened array of voronoi seed points; fit for a divide & conquer shader
 * @param {array<struct.trianglestuffs_triangle>} triangulation the triangulation belonging to this voronoi graph
 * @returns {array<real>}
 */
function trianglestuffs_get_voronoi_points_flattened(triangulation) {

	var triangle_count = array_length(triangulation);
	var voronoi_points = array_create(triangle_count * 2, undefined);
	
	for (var index = 0; index < triangle_count; index = index + 1) {
		var array_offset = index * 2;
		var this_point = triangulation[index].circumcenter;
		voronoi_points[array_offset + 0] = this_point.x;
		voronoi_points[array_offset + 1] = this_point.y;
	}
	
	return voronoi_points;
	
}