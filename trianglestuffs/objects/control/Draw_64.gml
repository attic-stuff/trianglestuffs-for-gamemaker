var text = "click to add a point, right click to yeet a point. press T to toggle triangles, and press H to toggle the hull !" +
		   "\n\npoints: " + string(array_length(points)) +
		   "\ntriangles: " + string(ds_list_size(triangles)) +
		   "\nlast calculation: " + string(calc) + "ms";
draw_text_ext_color(2, -4, text, 9, 128, #080808, #080808, #080808, #080808, 1);
draw_text_ext_color(2, -5, text, 9, 128, #dbd2b8, #dbd2b8, #dbd2b8, #dbd2b8, 1);