window_set_size(1024, 1024);
surface_resize(application_surface, 512, 512);
display_set_gui_size(512, 512);
points = [];
hull = [];
triangles = ds_list_create();
calc = 0;
dohull = true;
dotriangles = true;
draw_set_font(font);