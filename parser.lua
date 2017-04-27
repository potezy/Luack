
function sizeOf(matrix)
	 local size = 0
	 for _ in pairs(matrix) do size = size + 1 end
	 return size
end

function string:split(sep) --credit to lua user manual
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
 end

function make_int(matrix)
	 for i = 1, sizeOf(matrix) do
	     matrix[i] = tonumber(matrix[i])
	 end
	 return matrix
end

function parseFile(f)
	 local lines,s,n,lstack,sizeL,top,temp = {},0,"pic.png"
	 lstack = new_stack()
	 for line in io.lines(f) do
	     table.insert(lines, line)
	     s = s + 1
	 end
	 for i = 1, s do 
	     top = lstack[sizeOf(lstack)]
	     ln = lines[i]:split(" ")

	     if (ln[1] == "line") then
	     	args = lines[i+1]:split(" ")
	     	addEdge(eMatrix, args[1], args[2],args[3],args[4],args[5],args[6])
		matrixMult(top , eMatrix)
		draw(board,eMatrix)
		eMatrix = makeMatrix(4,0)		

	     elseif (ln[1] == "ident") then
	     	    identify(tMatrix)
	
	     elseif (ln[1] == "scale") then
	     	    args = lines[i+1]:split(" ")
		    temp = scale(args[1], args[2], args[3])
		    top =matrixMult(top,temp)
		    lstack[sizeOf(lstack)] = top		    

	     elseif (ln[1] == "move") then 
	     	    args = lines[i+1]:split(" ")
	     	    temp = translate(args[1], args[2],args[3])
		    --printMatrix(temp)
		    top = matrixMult(top,temp)		    		    	      
		    lstack[sizeOf(lstack)] = top		    

	     elseif (ln[1] == "rotate") then
	     	    args = lines[i+1]:split(" ")
	     	    temp = rotate(args[1], math.rad(args[2]))
		    top = matrixMult(top,temp)		   	
		    lstack[sizeOf(lstack)] = top		    

             elseif (ln[1] == "apply") then
	     	    eMatrix = matrixMult(tMatrix, eMatrix)
		    poly_matrix = matrixMult(tMatrix,poly_matrix)	

	     elseif (ln[1] == "save") then
	     	    args = lines[i+1]:split(" ")
		    save(board)
		    n = args[1]
		    os.execute("convert line.ppm " .. n) 
	
	     elseif (ln[1] == "display") then
	     	    save(board)
	     	    local a = "display line.ppm" 
		    print(a)
	     	    os.execute(a) 
	
	     elseif (ln[1] == "circle") then
	     	    args = lines[i+1]:split(" ")
		    circle(args[1], args[2], args[3], args[4])	
		    eMatrix =matrixMult(top,eMatrix)
		    draw(board,eMatrix)
		    eMatrix = makeMatrix(4,0)	    	    

	     elseif (ln[1] == "hermite" or ln[1] == "bezier") then
	     	    args = lines[i+1]:split(" ")
		    add_curve(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8], ln[1])
		    eMatrix =matrixMult(top,eMatrix)
		    draw(board, eMatrix)
		    eMatrix = makeMatrix(4,0)		    

	     elseif (ln[1] == "clear") then
	     	    eMatrix = {{},{},{},{}}
		    poly_matrix = makeMatrix(4,0)		    

	     elseif (ln[1] == "sphere") then
	     	    args = lines[i+1]:split(" ")
		    add_sphere(args[1],args[2],args[3],args[4])
		    poly_matrix = matrixMult(top,poly_matrix)
		    draw_polygons(poly_matrix,board,4)
		    poly_matrix = makeMatrix(4,0)		    

	     elseif (ln[1] == "torus") then
	     	    args = lines[i+1]:split(" ")
		    add_torus(args[1],args[2],args[3],args[4],args[5])	     	    
		    
		    poly_matrix = matrixMult(top,poly_matrix)
		    draw_polygons(poly_matrix,board,4)
		    poly_matrix = makeMatrix(4,0)

	     elseif (ln[1] == "box") then
	     	    args = lines[i+1]:split(" ")
		    --print(args[6])
		    add_box(args[1],args[2],args[3],args[4],args[5],args[6])
		    
		    --printMatrix(poly_matrix)
		    --printMatrix(top)
		    --printMatrix(poly_matrix)

		    poly_matrix = matrixMult(top,poly_matrix)
		    --printMatrix(poly_matrix)
		    draw_polygons(poly_matrix,board,4)		    
		    poly_matrix = makeMatrix(4,0)

             elseif (ln[1] == "push") then
	     	    push(lstack)

	     elseif (ln[1] == "pop") then
	     	    pop(lstack)
	     
	     
	     	    	     
	     end
 	 end
end

--parseFile("commands")