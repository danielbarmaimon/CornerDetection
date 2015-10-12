function [ points ] = nonMaxSuppression(E,sortedValues, n, m, winSize)
points = zeros(2,81);
counter = 1;
iterator = 1;
A1 = E;
%indexPointer = 1;
border = (winSize-1)/2;
while (counter<82)   
    maxValue=find((A1==sortedValues(iterator,1)),1,'first');
    if (isempty(sortedValues(maxValue))== 0)
        [x, y]=ind2sub([n,m],maxValue);
        points(:,counter)=[y,x];
        minX = max(1, x - border);
        maxX = min(n, x + border);
        minY = max(1, y - border);
        maxY = min(m, y + border);
        A1(minX:maxX, minY:maxY)=0;
        counter = counter +1;
    end
    iterator = iterator +1;
end
end

