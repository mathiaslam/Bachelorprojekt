var selectedItems = document.selectedItems; 
for(var i = 0; i < selectedItems.length; i++) { 
	var selectedItem = selectedItems[i]; 
	if(selectedItem instanceof TextItem){
		print("Yeah");
		
		var outlineGroup = selectedItem.createOutline();
		selectedItem.remove();
		
		var pjump = null;
		
		for(var j = 0; j < outlineGroup.children.length; j++){
			var letter = outlineGroup.children[j];
			
			
			
			
			for(var g = 0; g < letter.children.length; g++){
			
			
				
				var shape = letter.children[g];
				
				
				if( shape.closed ){
					
					shape.segments[shape.segments.length-1].remove();
					shape.closed = false;
					
					
				   //var myCircle = new Path.Circle(shape.curves[0].point1, 1);
				   //myCircle.strokeColor = "#ff4500";
					
					
					
				}
				
				
				
				if(shape.strokeColor == null ){
					shape.strokeColor = shape.fillColor;
					shape.fillColor = null;
					shape.strokeCap = 'round';
					shape.strokeJoin = 'round';
				}
				
				
				
				if(pjump != null) {
				//var myLine = new Path.Line(pjump, shape.segments[0].point);
				}
				
				
				
				/* Make linear */
			   for(var h= 0; h < shape.curves.length; h++) {
			   //	
			   	var curve = shape.curves[h];
			   //	
			   ////	if(!curve.isLinear()){
			   //		curve.handle1.x = 0;
			   //		curve.handle1.y = 0;
			   //		
			   //		curve.handle2.x = 0;
			   //		curve.handle2.y = 0;
			   //		
			   ////	}
			
				pjump = new Point(curve.point2.x, curve.point2.y);
			
			   }
				
				
				print(shape.curves);
				
			
			}
			
			//print(letter instanceof PathItem);
			
		}
		
		
		//outlineGroup.remove();
		
		
	}
}