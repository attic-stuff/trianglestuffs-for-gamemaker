//add a point
if (mouse_check_button_pressed(mb_left)) {
	var t = get_timer();
	array_push(points, new trianglestuffs_point(mouse_x, mouse_y));
	if (array_length(points) > 2) {
		if (dohull) {
			hull = trianglestuffs_form_convex_hull(points, true);
		}
		if (dotriangles) {
			var super = trianglestuffs_create_super_triangle(0, 0, 512, 512);
			ds_list_destroy(triangles);
			triangles = trianglestuffs_form_mesh(points, super, false);
		}
	}
	calc = (get_timer() - t) / 1000;
}
//yeet a point
if (mouse_check_button_pressed(mb_right)) {
	for (var i = array_length(points) - 1; i > -1; i--) {
		var b = points[i];
		var distance = point_distance(mouse_x, mouse_y, b.x, b.y);
		if (distance < 3) {
			array_delete(points, i, 1);
		}
	}
	if (array_length(points) < 3) {
		if (dohull) {
			hull = [];
		}
		if (dotriangles) {
			ds_list_destroy(triangles);
			triangles = ds_list_create();
		}
	} else {
		var t = get_timer();
		if (dohull) {
			hull = trianglestuffs_form_convex_hull(points, true);
		}
		if (dotriangles) {
			var super = trianglestuffs_create_super_triangle(0, 0, 512, 512);
			ds_list_destroy(triangles);
			triangles = trianglestuffs_form_mesh(points, super, false);
		}
		calc = (get_timer() - t) / 1000;
	}
	
}
//toggles
if (keyboard_check_pressed(ord("T"))) {
	dotriangles = !dotriangles;
	if (dotriangles == false) {
		ds_list_destroy(triangles);
		triangles = ds_list_create();
	} else {
		var t = get_timer();
		var super = trianglestuffs_create_super_triangle(0, 0, 512, 512);
		ds_list_destroy(triangles);
		triangles = trianglestuffs_form_mesh(points, super, false);
		calc = (get_timer() - t) / 1000;
	}
}
if (keyboard_check_pressed(ord("H"))) {
	dohull = !dohull;
	if (dohull == false) {
		hull = [];
	} else {
		var t = get_timer();
		hull = trianglestuffs_form_convex_hull(points, true);	
		calc = (get_timer() - t) / 1000;
	}
}