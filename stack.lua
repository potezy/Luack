require 'matrix' -- remove later

function new_stack()
	 local stack, i = {}
	 i = makeMatrix(4,4)	 
	 identify(i)
	 --printMatrix(i)
	 table.insert(stack,i)
	 print(sizeOf(stack))
end
new_stack()
function push()

end


function pop()


end
