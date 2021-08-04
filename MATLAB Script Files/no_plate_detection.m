images=["Number Plate Images/g1.jpeg"
        "Number Plate Images/g2.jpeg"
        "Number Plate Images/g3.jpeg"
        "Number Plate Images/g4.jpeg"
        "Number Plate Images/g5.jpeg"
        "Number Plate Images/g6.jpeg"
        "Number Plate Images/g7.jpeg"
        "Number Plate Images/g8.jpeg"];

plateNumberArray=[];  
timeArray=[];
    
for i=1 : length(images)
    
    image=images(i);
    finalImage=char(image);

    readImage = imread(finalImage);
    toGray = rgb2gray(readImage);
    binarized = imbinarize(toGray);
    readImage = edge(toGray, 'prewitt');

    %Below steps are to find location of number plate
    imgProperties=regionprops(readImage,'BoundingBox','Area', 'Image');
    area = imgProperties.Area;
    n = numel(imgProperties);

    boundingBox = imgProperties.BoundingBox;
    for index=1:n
       if area<imgProperties(index).Area
           area=imgProperties(index).Area;
           boundingBox=imgProperties(index).BoundingBox;
       end
    end    

    readImage = imcrop(binarized, boundingBox);%crop the number plate area
    readImage = bwareaopen(~readImage, 500); %remove some object if it width is too long or too small than 500

    [height, width] = size(readImage);%get width

    subplot(4,2,i);
    imshow(readImage);

    imgProperties=regionprops(readImage,'BoundingBox','Area', 'Image'); %read letter
    n = numel(imgProperties);
    plateNumber=[]; % Initializing the variable of number plate string.

    for index=1:n
       x = length(imgProperties(index).Image(1,:));
       y = length(imgProperties(index).Image(:,1));
       if x<(height/2) & y>(height/3)
           character=DetectLetters(imgProperties(index).Image); % Reading the letter corresponding the binary image 'N'.
           plateNumber=[plateNumber character];% Appending every subsequent character in noPlate variable.
       end
    end
    dt=datetime('now');disp(dt);
    
    fullTitle= plateNumber;
    fullTitle=strcat(plateNumber,": ");
    fullTitle=strcat(fullTitle,char(dt));
    
    title(fullTitle);
    disp(plateNumber);
    
    finalPlateNumber=cellstr(plateNumber);
    plateNumberArray = [plateNumberArray , finalPlateNumber];
    
    timeArray=[timeArray , cellstr(dt)];
    
    finalArray=[plateNumberArray ; timeArray];
    finalArray=finalArray';
    pause(2);
end
columnHeader={'Number Plate','Date & Time'};
xlswrite('C:\Users\Acer\Desktop\Vehicle Database.xls',finalArray,'Sheet1','A2');
xlswrite('C:\Users\Acer\Desktop\Vehicle Database.xls',columnHeader,'Sheet1','A1');
