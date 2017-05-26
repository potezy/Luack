--globals
XRES = 500
YRES = 500
step = .1
MAX_COLOR = 255

poly_matrix = {{},{},{},{}}

function add_box(x , y , z , width , height, depth)
	 local x1,y1,z1,x0,y0,z0
	 x0 = x
	 x1 = x + width
	 y0 = y
	 y1 = y - height
	 z0 = z
	 z1 = z - depth
	add_polygon(poly_matrix, x0,y0,z0, --v1
	             x0,y0,z1, 
		     x1,y0,z0) 
	add_polygon(poly_matrix,x0,y0,z1, 
		     x1,y0,z1, 
		     x1,y0,z0) 
	add_polygon(poly_matrix,x0,y0,z0,
		     x1,y0,z0,
		     x1,y1,z0)
	add_polygon(poly_matrix,x0,y1,z0,
		     x0,y0,z0,
		     x1,y1,z0)
	add_polygon(poly_matrix,x1,y0,z0,
		     x1,y0,z1,
		     x1,y1,z1)
	 add_polygon(poly_matrix,x1,y1,z1,
		     x1,y1,z0,
		     x1,y0,z0)
	 add_polygon(poly_matrix,x1,y0,z1,
		     x0,y0,z1,
		     x0,y1,z1)
	 add_polygon(poly_matrix,x0,y1,z1,
		     x1,y1,z1,
		     x1,y0,z1)
	 add_polygon(poly_matrix,x0,y0,z1,
	             x0,y0,z0,
		     x0,y1,z0)
	 add_polygon(poly_matrix,x0,y1,z0,
		     x0,y1,z1,
		     x0,y0,z1)	
	 add_polygon(poly_matrix,x0,y1,z0,
		     x1,y1,z0,
		     x1,y1,z1)
	 add_polygon(poly_matrix,x1,y1,z1,
		     x0,y1,z1,
	 	     x0,y1,z0)
end

function add_polygon(matrix,x0,y0,z0, x1,y1,z1, x2,y2,z2)
	 local temp = sizeOf(matrix[1])
	 addPoint(matrix, x0,y0,z0)
	 addPoint(matrix, x1,y1,z1)
	 addPoint(matrix, x2,y2,z2)
end

function vertices(y0,y1,y2)
	 local top,mid,bot
	 if (y0>=y1 and y0>=y2) then
	    top = {x0,y0}
	    if (y1 >= y2) then
	       mid = {x1,y1}
	       bot = {x2,y2}
	    end
	 else if (y1>=y2 and y1>=y0) then	
	    top = {x1,y1}
	    if (y0 >= y2) then
	       mid = {x0,y0}
	       bot = {x2,y2}
	    end   
	 else
	    top = {x2,y2}
	    if (y0 >= y1) then
	       mid = {x0,y0} 
	       bot = {x1,y1}
	    end
	  end
	  return bot,mid,top 
	 
end

function scan_line( matrix, board,i)
	 local x0,x1,x2,y0,y1,y2,bot,top,mid
	 y0 = matrix[2][i]
`	 y1 = matrix[2][i+1]
	 y2 = matrix[2][i+2]
	 bot,mid,top = verticies(y0,y1,y2)
	 
	 local deltaY,dx1,dx0 
	 deltaY = 1
	 dx0 = (top[1] - bot[1]) / (top[2] - top[1])
	 dx1 = (mid[1] - bot[1]) / (mid[2] - bot[2])
	 for minY = 0, max[2]-min[2], deltaY do
	     if (minY +min[2] > mid[2]) then
	     	
	 end 
	 
	 
	 

end

function draw_polygons(matrix,board,c)
	 
	  for i = 1, sizeOf(matrix[1])-3 ,3 do
	      local color = Color:new(i^2%256 , i^3%256, i^4%256)
	      local color2 = Color:new(250,125,50)	
	      if backface_cull(matrix[1][i],matrix[2][i],matrix[3][i], matrix[1][i+1],matrix[2][i+1],matrix[3][i+1],matrix[1][i+2],matrix[2][i+2],matrix[3][i+2]) then 
	      
	      --scan_line(matrix,board,color2,i)
	      
	      draw_line(matrix[1][i],
			matrix[2][i],
	   		matrix[1][i+1],
	   		matrix[2][i+1],
			color,board)

	      draw_line(matrix[1][i+1],
			matrix[2][i+1],
	   		matrix[1][i+2],
	   		matrix[2][i+2],
			color,board)

	      draw_line(matrix[1][i+2],
			matrix[2][i+2],
	   		matrix[1][i],
	   		matrix[2][i],
			color,board)		
	 end

	 end
end

--object to store color
Color = {red = 0, green = 0 , blue = 0}

--constructors 
function Color:new ( r , g ,b )
	 local color = {}
	 setmetatable(color , self)
	 self.__index = self 
	 self.red = r 
	 self.green = g
	 self.blue = b
	 return color
end

--create the array to store pixels 
board = {}
for i = 0, XRES-1 do
    board[i] = {}
    for k = 0, YRES -1 do
    	board[i][k] = Color:new(0,0,0)
    end
end



--function to draw line
function draw_line(x0 , y0 , x1, y1 , c , s)
	 x0 = tonumber(x0)
	 x1 = tonumber(x1)
	 y0 = tonumber(y0)
	 y1 = tonumber(y1)
	 if (x0>x1) then
	    xt = x0 	   
	    yt = y0
	    x0 = x1
	    y0 = y1
	    x1 = xt
	    y1 = yt
	 end
	 x = x0
	 y = y0
	 A = 2*(y1-y0)
	 B = -2*(x1 - x0)
	    if (math.abs(x1-x0) >= math.abs(y1-y0)) then
	       if (A > 0) then
	       	  D = A + B/2
	       	  while (x <x1) do
	       	     	plot(s,c,x,y)
			if ( D >0) then	
			   y = y +1  
		     	   D = D + B
			end
			x = x +1
			D = D + A
		  end
		  plot(s , c , x , y)
	       else D = A - B/2
	       	    while (x < x1) do
		    	  plot(s,c,x,y)
			  if (D<0) then
			     y = y -1
			     D = D - B
			  end
			  x = x +1
			  D = D + A
		    end
		    plot(s,c,x,y)
	       end
	    else
		if (A > 0) then
		   D = A/2 + B
		   while ( y < y1) do
		   	 plot( s , c , x ,y)
			 if ( D < 0) then
			    x = x + 1
			    D = D + A
	    	   	 end
			 y = y +1
			 D = D + B
		   end
	 	   plot( s , c , x ,y)
		else D = A/2 - B
		     while (y > y1) do
		     	   plot(s,c,x,y)
			   if  (D > 0) then
			       x = x +1
			       D = D + A
			   end
			   y = y -1
			   D = D - B
		     end
		     plot(s,c,x,y)
		end
	
	   end	
	
end



function draw(board, eMatrix)
	 for i = 1 , sizeOf(eMatrix[1]) , 2 do
	     local x1 = math.floor(eMatrix[1][i])
	     local x2 = math.floor(eMatrix[1][i+1])
	     local y1 = math.floor(eMatrix[2][i])
	     local y2 = math.floor(eMatrix[2][i+1])
	     --print(x1,y1,x2,y2)
	     color = Color:new((x1+x2)%255, (y1+y2)%255, (x1+x2+y1+y2)%255)
	     draw_line(x1,y1,x2,y2,color,board)
	 end
	 
	 --printMatrix(eMatrix)
end

function addPoint(matrix, x,y,z)
	 table.insert(matrix[1],x) 	 
	 table.insert(matrix[2],y)
	 table.insert(matrix[3],z)
	 table.insert(matrix[4],1)
end

function addEdge(matrix, x1,y1,z1,x2,y2,z2)
	 addPoint(matrix,x1,y1,z1)
	 addPoint(matrix,x2,y2,z2)
end

function add_curve(x0,y0,x1,y1,x2,y2,x3,y3,t)
	 local xcoef,ycoef,xcor0,ycor0,xcor1,ycor1
	 xcoef , ycoef = coef(x0,y0,x1,y1,x2,y2,x3,y3,t)
	 xcor0 = xcoef[4][1]
	 ycor0 = ycoef[4][1]
	 for t = 0, 1 ,step do
	     xcor1 = xcoef[1][1] * t^3 + xcoef[2][1] * t^2 +xcoef[3][1] *t + xcoef[4][1]
	     ycor1 = ycoef[1][1] * t^3 + ycoef[2][1] * t^2 +ycoef[3][1] *t + ycoef[4][1]
	     addEdge(eMatrix, xcor0,ycor0,0,xcor1,ycor1,0)
	     xcor0 = xcor1
	     ycor0 = ycor1
	 end
end

function circle(cx , cy , cz , r)
	 --print("potato")
	 local step = .01
	 local xcor, ycor, xcor0, ycor0
	 xcor0 = r + cx --first point
	 ycor0 = cy     --first point
	 for t = 0, 1+step, step do
	     theta = 2 * pi * t
	     xcor1 = r * cos(theta) + cx
	     ycor1 = r * sin(theta) + cy
	     addEdge(eMatrix, xcor0 , ycor0 , 0 , xcor1 , ycor1, 0)
	     ycor0 = ycor1
	     xcor0 = xcor1
	 end
	 
end
--[[
function add_box(x , y , z , width , height, depth)
	 addEdge(eMatrix, x, y, z, x, y, z)--upper left
	 addEdge(eMatrix, x+width, y, z, x+width, y, z)--upper right
	 addEdge(eMatrix, x, y-height, z, x, y-height, z)--lower left
	 addEdge(eMatrix, x+width, y-height, z, x+width, y-height, z)--lower right
	 addEdge(eMatrix, x, y, z-depth, x, y, z-depth)
	 addEdge(eMatrix, x+width, y, z-depth, x+width, y, z-depth)
	 addEdge(eMatrix, x, y-height,z-depth,x,y-height,z-depth)
	 addEdge(eMatrix, x+width, y-height,z-depth,x+width,y-height,z-depth)
end
--]]
function add_sphere(cx , cy , cz , r )
	 local sphere_points,num_steps, x0 , y0 , z0 ,x1,y1,z1,x2,y2,z2,x3,y3,z3
	 sphere_points = generate_sphere(cx,cy,cz,r)
	 ss = sizeOf(sphere_points[1])

	 num_steps = 1/step 
	 local lat, longt = 0,0
	 for i = 0, num_steps -2  do
	     lat = lat +1
	     for l = 0, num_steps-1  do
	     	 local index = i * num_steps + l +1
		 index = math.floor(index)
		 --print(index)
		 longt = longt +1
		 add_polygon( poly_matrix,
			      sphere_points[1][index],
			      sphere_points[2][index],
			      sphere_points[3][index],
			      sphere_points[1][index +1],
			      sphere_points[2][index +1],
			      sphere_points[3][index +1],
			      sphere_points[1][index + num_steps +1],
			      sphere_points[2][index + num_steps +1],
			      sphere_points[3][index + num_steps +1])
	         add_polygon( poly_matrix,
		 	      sphere_points[1][index],
			      sphere_points[2][index],
			      sphere_points[3][index],
			      sphere_points[1][index +1 +num_steps],
			      sphere_points[2][index +1 +num_steps],
			      sphere_points[3][index +1 +num_steps],
			      sphere_points[1][index +num_steps], 	
			      sphere_points[2][index +num_steps],
			      sphere_points[3][index +num_steps])
			     
	      end
          end
	  
	  for longt = 1, num_steps  do
	      index = lat * num_steps + longt 
	      index = math.floor(index)
	      add_polygon( poly_matrix,           
	      		    sphere_points[1][index],
			    sphere_points[2][index],
			    sphere_points[3][index],
			    sphere_points[1][index +1],
			    sphere_points[2][index +1],
			    sphere_points[3][index +1],
			    sphere_points[1][longt+1],
			    sphere_points[2][longt+1],
			    sphere_points[3][longt+1])
	      add_polygon( poly_matrix,
	      		   sphere_points[1][index],
			   sphere_points[2][index],
			   sphere_points[3][index],
			   sphere_points[1][longt+1],
			   sphere_points[2][longt+1],
			   sphere_points[3][longt+1],
			   sphere_points[1][longt],
			   sphere_points[2][longt],
			   sphere_points[3][longt])
               end
end

function generate_sphere(cx , cy , cz , r)
         local rot,rotation,circlec,circ,x,y,z,num_steps, point_matrix
         point_matrix = makeMatrix(4,0)
	 local i = 0
	 num_steps = (1/step )
         for rotation = 0, num_steps-1, 1 do
	     rot = rotation/num_steps
             for circlec = 0, num_steps -1, 1 do
	     	 circ = circlec/num_steps 
                 x = r * cos(circ * pi) + cx
                 y = r * sin(circ * pi) * cos(rot * 2 * pi) + cy
                 z = r * sin(circ * pi) * sin(rot * 2 * pi) + cz
                 addPoint(point_matrix, x,y,z)
		 i = i +1
             end
	     --print(i)
         end
         return point_matrix
end



function add_torus(cx , cy , cz , r1 , r2)
	 local tPoints,x0,x1,x2,x3,y0,y1,y2,y3,z0,z1,z2,z3,size,lat,longt,num_steps
	 tPoints = generate_torus(cx,cy,cz,r1,r2)
	 num_steps = 1/step
	 for lat = 0, num_steps -1 do
	     for longt = 0, num_steps-1  do
	     	 local index = lat * num_steps +longt
		 add_polygon( poly_matrix,
		 	      tPoints[1][index],
			      tPoints[2][index],
			      tPoints[3][index],
			      tPoints[1][index +1],
			      tPoints[2][index +1],
			      tPoints[3][index +1],
			      tPoints[1][index + num_steps],
			      tPoints[2][index + num_steps],
			      tPoints[3][index + num_steps])
	         add_polygon( poly_matrix,
		 	      tPoints[1][index +1 +num_steps],
			      tPoints[2][index +1 +num_steps],
			      tPoints[3][index +1 +num_steps],
			      tPoints[1][index + num_steps],
			      tPoints[2][index + num_steps],
			      tPoints[3][index + num_steps],
			      tPoints[1][index +1],
			      tPoints[2][index +1],
			      tPoints[3][index +1])
	     end 		      
	 end
	 
end

function generate_torus(cx , cy , cz , r1 , r2)
	 local rot,circ,x,y,z, torus_points,r,c
	 torus_points = makeMatrix(4,0)
	 num_steps = math.floor(1/step +.1)
	 local i = 0 
	 for r = 0, num_steps do
	     rot = r /num_steps
	     for c = 0, num_steps -1 do
	     	 circ = c/num_steps
	     	 x = cos(rot * 2 * pi) * (r1 * cos(circ * 2 * pi) + r2) + cx
		 y = r1 * sin(circ * 2 * pi) + cy
		 z = -1 * sin(rot * 2 * pi) * (r1 * cos(circ * 2 * pi) + r2) + cz
		 addPoint(torus_points, x ,y ,z)
	      end
	   --   print(i)
	 end
	 --print(i)
	 return torus_points
end

function backface_cull(x0,y0,z0,x1,y1,z1,x2,y2,z2)
	 local dx0,dx1,dy1,dy0,n
	 dx0 = x1-x0
	 dx1 = x2-x0
	 dy1 = y2-y0
	 dy0 = y1-y0
	 n = dx0*dy1 - dy0*dx1
	 return n > 0
end
