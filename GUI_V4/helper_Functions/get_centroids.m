function pts = get_centroids(img)
% given an image it extracts all the blob centroids
binPic = logical(img);


[class,Num] = bwlabel(binPic);
pts = zeros(Num,2);
for n =1:Num
  [y,x] = ind2sub(size(binPic),find(class == n));
  pts(n,:) = mean([x,y],1);
  clear x y
end
end