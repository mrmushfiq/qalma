function moveF(handles,image, sign)

    img = image; 
    min_data = get(handles.data_transfer_min, 'Data');
    column = get(handles.column_mlc, 'Value');
    min = min_data(:,column); %just getting the column required
    my_line = get(handles.select_line,'Value');
    xy = get(handles.xy_data,'Data');
    x=xy(:,1);
    level = str2num(get(handles.level_txt, 'String'));
    
    
    [r2 c2] =  size(min_data);
    
    %for i=my_line:length(min)-1
    % min(i) = min(i) + 1;
    %end

   % min(my_line) = min(my_line) + 1;
    min(my_line) = min(my_line) + sign; 
    
    for i=1:length(min)-1
        leafpos(i) = (min(i) + min(i+1))/2; 
    end

    imshow(img);

    min_s = min; 
    
    hold on
    p = column;
    col = num2str(p);
    text([round(x(p))+level],[0],col, 'Color','black')

    for j=1:length(leafpos)
    %   line([round(x(1))-30 round(x(1))-20],[leafpos(j) leafpos(j)],'Color','r')
        name = num2str(j);

        text([round(x(p))],[leafpos(j)],name, 'Color','yellow')

        line([round(x(p))+level],[leafpos(j)],'Color','r','Marker','*', 'MarkerSize',3)
    end

    hold off

    hold on

    for j=1:length(min_s)
        line([round(x(p))+level-4 round(x(p))+level+11],[min_s(j) min_s(j)],'Color','g')
    end


    hold off

    %capture current graph
    frame = getframe(handles.axes1)
    im_now = frame2im(frame);
    %im_now = getimage(gcf); 
    %imwrite(im_now,'current_positions.png')

    min_data(:,column) = min;
    
    for k=1:c2
        if k ~= column
            min_data(my_line, k) = min_data(my_line, k) + sign;
        end
    end
    
    set(handles.data_transfer_min,'Data',min_data);
end