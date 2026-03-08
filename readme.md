# trianglestuffs

### for gamemakering
a gamemaker library for triangulating a set of points using the [bowyer-watson](https://en.wikipedia.org/wiki/Bowyer–Watson_algorithm) algorithm. suitable for all yer screen shattering, mesh making, and terrain deforming gamemaker needs. it also provides tools for creating voronoi diagrams 'cause the voronoi diagram of a set of points is the dual graph of a delaunay triangulation! make stuff that looks like this:  

![example](https://github.com/attic-stuff/trianglestuffs-for-gamemaker/blob/main/example.png)  

### how to use
you can download the yyz file and open it to see an example of this library in action, or download the trianglestuffs_backend.gml file and drag it to your project in the ide, or copy and paste the contents of the gml file to a new script asset in your project.

### data structures:
|trianglestuffs_vertex(x, y)|
|:-------------------------|
| contains the position information of a triangle vertex |
| **x**: the vertex's x position |
| **y**: the vertex's y position |  

_methods:_  
> equals_vertex(other_vertex)  

_example:_
```js
array_push(point_set, new trianglestuffs_vertex(4, 20));
```

|trianglestuffs_edge(vertex_a, vertex_b) |
|:---------------------------------------|
| contains the edge, or line segment, information of one side of a triangle |
| **vertex_a**: the first vertex of the line segment |
| **vertex_b**: the second vertex of the line segment |

_methods:_  
> equals_edge(other_edge)  
> get_line_equation()  
> get_perpindicular_line_equation()

_example:_
```js
var point_a = new trianglestuffs_vertex(4, 20);
var point_b = new trianglestuffs_vertex(6, 9);
var triangle_edge = new trianglestuffs_edge(point_a, point_b);
```

|trianglestuffs_triangle(vertex_a, vertex_b, vertex_c) |
|:-----------------------------------------------------|
|contains the vertex information of a triangle, as well as information such as the circumcircle, centroid, and circumradius. |
| **vertex_a**: first vertex of the triangle |
| **vertex_b**: second vertex of the triangle |
| **vertex_c**: third vertex of the triangle |

_methods:_  
> vertex_in_circumcircle(vertex)  
> fetch_barycentric_coordinates(x, y, sorting)

_example:_
```js
var point_a = new trianglestuffs_vertex(4, 20);
var point_b = new trianglestuffs_vertex(6, 9);
var point_c = new triangle_stuffs_vertex(1, 13)
var whole_ass_triangle = new trianglestuffs_triangle(point_a, point_b, point_c);
```
### functions
|trianglestuffs_get_triangulation(point_set) |
|:-------------------------------------------|
|calculates the delaunay triangulation of a set of points. returns an array of trianglestuff_triangle structs |
| **point_set**: an array of trianglestuff_vertex structs what need triangulating |

_example:_
```js
var set_of_points = [

    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),

]
var mesh_you_up = trianglestuffs_get_triangulation(set_of_points);
```

|trianglestuffs_get_convex_hull(point_set) |
|:-------------------------------------------|
|calculates the convex hull of a set of trianglestuff_vertex points |
| **point_set**: an array of trianglestuff_vertex structs to wrap the hull around |

_example:_
```js
var set_of_points = [

    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),

]
var hull_thing = trianglestuffs_get_convex_hull(set_of_points);
```

|trianglestuffs_get_voronoi_seeds_flattened(triangulation) |
|:---------------------------------------------------------|
|returns a set of positions as a flat array that can be sent to a shader to be used for greedy, naive voronoi shader|
|**triangulation**: the array of triangles to grab seeds from|  

_example:_  
```js
/* CREATE EVENT */
points_register = shader_get_uniform(voronoi_shader, "seed_points");

var set_of_points = [

    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),

]

var mesh_you_up = trianglestuffs_get_triangulation(set_of_points);
seed_set = trianglestuffs_get_voronoi_seeds_flattened(mesh_you_up);

/* DRAW EVENT */
shader_set(voronoi_shader);
shader_set_uniform_f_array(voronoi_shader, seed_set);
draw_cool_stuff_or_whatever();
shader_reset();
```

|trianglestuffs_get_voronoi_edges(triangulation, [clipping_plane]) |
|:---------------------------------------------------------------|
|returns a set of edges that create a voronoi diagram of a triangulation. these edges do not close, but can be clipped to a rectangular area. to change how far towards infinity the infinite edges stretch you can change the `trianglestuffs_voronoi_infinity` macro to some cool number you like, or just leave it be.
|**triangulation**: the triangulation to turn into voronoi cells
|**[clipping_plane]**: optional array that must contain members `left, top, right, bottom` and form a rectangle clipping plane. edges outside of the plane are yeeted.
  
_example:_
```js
var set_of_points = [

    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),
    new trianglestuff_vertex(irandom(room_width), irandom(room_height)),

]

var mesh_you_up = trianglestuffs_get_triangulation(set_of_points);
var clip_plane = {
    left : 0,
    top : 0,
    right : room_width,
    bottom : room_height
}
edge_set = trianglestuffs_get_voronoi_edges(mesh_you_up, clip_plane);
```

### license
this source is provided without warranty. you are free to use and remix the provided code however you like, without attribution. you may not use the font included in the yyz file for any reason. its called [textmachine](https://polyducks.itch.io/textmachine-handwriting-font) by polyducks and it rules.