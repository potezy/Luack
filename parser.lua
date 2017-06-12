
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
	     	addEdge(eMatrix, ln[2],ln[3],ln[4],ln[5],ln[6],ln[7])
		matrixMult(top , eMatrix)
		draw(board,eMatrix)
		eMatrix = makeMatrix(4,0)		

	     elseif (ln[1] == "ident") then
	     	    identify(tMatrix)
	
	     elseif (ln[1] == "scale") then
		    temp = scale(ln[2], ln[3], ln[4])
		    top =matrixMult(top,temp)
		    lstack[sizeOf(lstack)] = top		    

	     elseif (ln[1] == "move") then 
	     	    temp = translate(ln[2],ln[3],ln[4])
		    --printMatrix(temp)
		    top = matrixMult(top,temp)		    		    	      
		    lstack[sizeOf(lstack)] = top		    

	     elseif (ln[1] == "rotate") then
	     	    temp = rotate(ln[2], math.rad(ln[3]))
		    top = matrixMult(top,temp)		   	
		    lstack[sizeOf(lstack)] = top		    

             elseif (ln[1] == "apply") then
	     	    eMatrix = matrixMult(tMatrix, eMatrix)
		    poly_matrix = matrixMult(tMatrix,poly_matrix)	

	     elseif (ln[1] == "save") then
		    save(board)
		    n = ln[2]
		    os.execute("convert line.ppm " .. n) 
	
	     elseif (ln[1] == "display") then
	     	    save(board)
	     	    local a = "display line.ppm" 
		    print(a)
	     	    os.execute(a) 
	
	     elseif (ln[1] == "circle") then
		    circle(ln[2], ln[3], ln[4], ln[5])	
		    eMatrix =matrixMult(top,eMatrix)
		    draw(board,eMatrix)
		    eMatrix = makeMatrix(4,0)	    	    

	     elseif (ln[1] == "hermite" or ln[1] == "bezier") then
		    add_curve(ln[2],ln[3],ln[4],ln[5],ln[6],ln[7],ln[8],ln[9], ln[1])
		    eMatrix =matrixMult(top,eMatrix)
		    draw(board, eMatrix)
		    eMatrix = makeMatrix(4,0)		    

	     elseif (ln[1] == "clear") then
	     	    eMatrix = {{},{},{},{}}
		    poly_matrix = makeMatrix(4,0)		    

	     elseif (ln[1] == "sphere") then
		    add_sphere(ln[2],ln[3],ln[4],ln[5])
		    poly_matrix = matrixMult(top,poly_matrix)
		    draw_polygons(poly_matrix,board,4)
		    poly_matrix = makeMatrix(4,0)		    

	     elseif (ln[1] == "torus") then
		    add_torus(ln[2],ln[3],ln[4],ln[5])	     	    
		    
		    poly_matrix = matrixMult(top,poly_matrix)
		    draw_polygons(poly_matrix,board,4)
		    poly_matrix = makeMatrix(4,0)

	     elseif (ln[1] == "box") then
		    --print(args[6])
		    add_box(ln[2],ln[3],ln[4],ln[5],ln[6],ln[7])
		    
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