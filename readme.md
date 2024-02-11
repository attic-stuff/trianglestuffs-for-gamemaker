# triangle stuffs

### for gamemakering

--THIS REPO IS GUNNA GET REWRITTEN SOON--

this repository is home to a set of functions and constructors for gamemaker making language triangulations and triangulation related things. you are free to use this code (not the font or the art if there is any) just know that it comes without support or warranty. you are on your own!

whats so cool about this? well it does a delaunay triangulation on a set of points, which is the sort of Sick Ass Kickflip triangulation of the game development world because it makes sure that no point on any triangle lies inside any other triangle. this allows you to create viable meshes for whatever you want: screen shatter effects, destructible terrain, weird triangle art. whatever you want friend as long as it requires one (1) or more triangles. read more: [delaunay triangulation](https://en.wikipedia.org/wiki/Delaunay_triangulation), [bowyer-watson algorithm](https://en.wikipedia.org/wiki/Bowyer–Watson_algorithm), [convex hulls](https://en.wikipedia.org/wiki/Convex_hull_algorithms).

### the example

![logo](https://github.com/attic-stuff/trianglestuffs-for-gamemaker/blob/main/logo.png)

all of this really cool code is in a project yyz that demonstrates everything working together. go ahead and run it! left click the screen to place a point, right click it to delete it. when there are three or more points on screen both a convex hull (in black) and a set of triangles (in blue) will be calculated in real time. you can press t to turn triangle calculating on or off, and you can press h to turn hull calculating on and off. you can press tab to yeet the whole thing. **note**: this can, with enough points, be quite a time consuming process. so there is a calculation time that shows how many milliseconds the calculation took. so if you add a point, it calculates the triangle and tells you how long that calculation took. you may want to play with running this using yyc, as well as both ds list and array versions of the triangle mesh.

### stuffs:

| trianglestuffs_point(x, y)                                   |
| :----------------------------------------------------------- |
| a constructor for making a new point in space.               |
| **x**: the x coordinate of the point<br />**y**: the y coordinate of the point |
| returns a constructor                                        |

| trianglestuffs_edge(a, b)                                    |
| :----------------------------------------------------------- |
| a constructor that creates an edge, or rather a line segment between two sets of trianglestuffs points. |
| **a**: trianglestuffs point a on the edge line<br />**b**: trianglestuffs point b on the edge line |
| returns a constructor                                        |

| trianglestuffs_triangle(a, b, c)                             |
| :----------------------------------------------------------- |
| a constructor that creates a triangle from three trianglestuffs points. the section below talks a bit more about this one. |
| **a**: trianglestuffs point a on the edge line<br />**b**: trianglestuffs point b on the edge line |
| returns a constructor                                        |

| trianglestuffs_create_super_triangle(x1, y1, x2, y2)         |
| :----------------------------------------------------------- |
| a super triangle is used in bowyer-watson triangulation, and this constructor makes that. this function takes the upper left and lower right corner of a rectangle as arguments—this rectangle should encompass all of your trianglestuffs points you wish to include in the triangulation. |
| **x1**: the lowest x axis point of the rectangle (left)<br />**y1**: the lowest y axis point of the rectangle (top)<br />**x2**: the highest x axis point of the rectangle (right)<br />**y2**: the highest y axis point of the rectangle (bottom) |
| returns a constructor                                        |

| trianglestuffs_validate_triangle(a, b, c)                    |
| :----------------------------------------------------------- |
| validates a proper triangle, however this is unused in the codebase right now. if you get sqrt errors when making your triangle you will need to implement this into the mesh code. |
| **a**: trianglestuffs point a of the triangle<br />**b**: trianglestuffs point b of the triangle<br />**c**: trianglestuffs point c of the triangle |
| returns true/false                                           |

| trianglestuffs_form_mesh(points, super, [convert])           |
| :----------------------------------------------------------- |
| where the magic happens! this is a gml implementation of the bowyet-watson algorithm. it takes a set of points and triangulates them into delaunay triangles which is very nice and pleasant; it returns a ds list of triangles, but optionally you may have it convert that ds list to an array. |
| **points**: the array of trianglestuffs points to triangulate<br />**super**: the super triangle used in the triangulation method<br />**[convert]**: optional argument to convert the returned ds list into an array. turning this on will have a performance impact! |
| returns a ds list of constructors                            |

| trianglestuffs_form_convex_hull(points, [wrap])              |
| :----------------------------------------------------------- |
| this returns an array of trianglestuffs points that form the convex hull of your set of original points. the algorithm used is the monotone chain one. neat! |
| **points**: the array of trianglestuffs points to form a hull around<br />**wrap**: optional argument that duplicates the first point on the hull in the last position of the array, making it a smidge easier to draw the thing |
| returns an array of constructors                             |

### the trianglestuffs triangle

this constructor is kind of special, as it is not just a list of points in a triangle. this triangle is aware of its edges, its circumcenter, its circumradius, and its centroid. that's a lot of C words_!_. the **circumcenter** is the center of a circle that goes around a whole triangle. each of the three points on the triangle lie on this circle. the **circumradius** is the radius of that circle, aka ol' dirty line from the circumcenter to the circle's edge.  the **centroid** is the center point of the triangle. these things can be useful for generating your own polygons, but, *but* the circumradius of a triangle is a really neat thing you can use to calculate a voronoi diagram. that can be very useful for many game development things or tech art things. this library is unconcerned with voronoi diagram, but it is possible to computer the voronoi diagram of your set of triangles using the information stored in the triangle constructor.