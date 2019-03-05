database = imread('database_Ariel20_pic.docx.png');
databaseBW=imbinarize(database); %making pic binary.
databaseBW=databaseBW(:,:,1);     %making pic one dimentional.
databaseBWinv=1.-databaseBW;      %inverting black and white.
databaseBWlabel=bwlabel(databaseBWinv); %labeling all letters
databaseBWlabel=comb(databaseBWlabel);  %calling our function that combines
%2 parts of the same letter.

%running dictionary
dictionary;


%Datacell will hold matrix of each letter.
bboxes = regionprops(databaseBWlabel,'BoundingBox');
databaseBWlabel=int64(databaseBWlabel);
Datacell=cell([70 3]);

for k=1 : length(bboxes)
    currBB = bboxes(k).BoundingBox;
    A=databaseBWlabel(int64(currBB(2)):int64(currBB(2)+currBB(4)) ,int64(currBB(1)):int64(currBB(1)+currBB(3)));
    A = imresize(int32(A), [100,100]);

    
    B=DictionaryCell(k, :);
    Datacell(k,:)={A,size(A),B(2)};
end
ex =imread('ex4.jpeg');
        exBW=imbinarize(ex); %making pic binary.
        exBW=exBW(:,:,1);     %making pic one dimentional.
        exBWinv=1.-exBW;      %inverting black and white.
        exBWlabel=bwlabel(exBWinv); %labeling all letters


%Excell will hold matrix of each letter.
bboxes = regionprops(exBWlabel,'BoundingBox');
exBWlabel=int64(exBWlabel);
Excell=cell([length(bboxes) 2]);
temp=[2 2];
for k=1 : length(bboxes)
    currBB = bboxes(k).BoundingBox;
    A=exBWlabel(int64(currBB(2)):int64(currBB(2)+currBB(4)) ,int64(currBB(1)):int64(currBB(1)+currBB(3)));
   
    A = A*100;
    
    
    A = imresize(int32(A), [100,100]);
    for i=1:100
        for j=1:100
            if A(i,j) >= 50
                A(i,j) = 1;
            else
                A(i,j) = 0;
            end
        end
    end
    %B=DictionaryCell(k, :);
    
    
    
    temp = A;
    Excell(k,:)={A,size(A)};
end

%the main check

str=cell(length(Excell(1)));
indexToWrite=1;
eight = Datacell(1,1);
for k=1 : length(Excell)
    curLetterToWrite = Datacell(1,3);
    max=0;
    for j=1 : length(Datacell)
       tempMax = 0;
       letterFromInput = cell2mat( Excell(k,1));
       letterFromDataBase = cell2mat( Datacell(j,1));
        
       for r=1 : 100
           for c=1 : 100
             numFromInput = letterFromInput(r,c);
             numFromOutput = letterFromDataBase(r,c);
             
             if (numFromInput == 0 && numFromOutput == 0) || (numFromInput ~= 0 && numFromOutput ~= 0)
                tempMax = tempMax + 1;
             end
           end
       end
       
       if tempMax > max
           max = tempMax;
           curLetterToWrite = Datacell(j,3);
           
       end
    end
    
    str(indexToWrite)=curLetterToWrite(1);           
    if indexToWrite == 7
           eight = letterFromInput;
    end
    indexToWrite = indexToWrite+1;
end

% a function that combines 2 part letter together like in "i"
% combines the dot with the line

function database = comb(database)
[row, col] = size(database);
for r=1:row
    for c=1:col
        if database(r,c)==15
            database(r,c)=16;
        end
        if database(r,c)==19
            database(r,c)=17;
        end
        if database(r,c)==58
            database(r,c)=57;
        end
        if database(r,c)==61
            database(r,c)=60;
        end
    end
end
end