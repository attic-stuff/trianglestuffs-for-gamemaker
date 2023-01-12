draw_set_color(#080808);	
for (var i = 0, dim = array_length(hull) - 1; i < dim; i++) {
	var a = hull[i];
	var b = hull[i+1];
	draw_line_width(a.x, a.y, b.x, b.y, 2);
}
draw_set_color(#ffffff);

draw_set_color(#dbd2b8);
for (var i = 0, dim = array_length(points); i < dim; i++) {
	var a = points[i];
	draw_circle(a.x, a.y, 3, true);
}

draw_set_color(#1f2e41);
for (var i = 0, dim = ds_list_size(triangles); i < dim; i++) {
	var a = triangles[| i].a;
	var b = triangles[| i].b;
	var c = triangles[| i].c;
	draw_triangle(a.x, a.y, b.x, b.y, c.x, c.y, true);
}