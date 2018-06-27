function wlF_load(handles, img_url)

    %[pathstr,name,ext] = fileparts(img_url);
    %if ext == '.dcm'

    %img_d = imread(img_url);
    img_d = dicomread(img_url);
    
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));
    %axes(handles.axes1); 
    %imshow(img);
    img = wiener2(img,[5,5]);
    
    zz = get(handles.zoom_pop, 'Value');
    
    %[x,y] = ginput(1);
    left_slider = round(get(handles.ball_slider, 'Value'));
    right_slider = round(get(handles.radiation_slider, 'Value'));
    
    try 
        sed = strel('disk',left_slider);
        ses = strel('square',right_slider);

        im_t = imtophat(img,sed); %disk worked first
        im_b = imbothat(img,ses); %sq worked first 
        %imshow(im_t);

        ball_b = im2bw(im_t,graythresh(im_t));
        ball_b= imclearborder(ball_b);
        %imshow(ball_b);

        rad_b = im2bw(im_b,graythresh(im_b));
        rad_b= imclearborder(rad_b);
        %imshow(rad_b);
        ball_l = bwlabel(ball_b);
        imshow(ball_l,'Parent',handles.axes2);

        rad_l = bwlabel(rad_b);
        imshow(rad_l,'Parent',handles.axes3);
        %imshow(ball_l);

        stats = regionprops(ball_l,'Centroid');
        center_ball = stats.Centroid;
    catch
        h = msgbox('Opps! You lost the object. Please increase or decrease the parameters for it to reappear');
    end 
    
    
    imshow(img,'Parent',handles.axes1);
    axes(handles.axes1);
    
    hold on
    plot(center_ball(1),center_ball(2),'Color','magenta','Marker','+', 'MarkerSize',3)
    hold off

    stats2 = regionprops(rad_l,'BoundingBox');
    rad_stats= stats2.BoundingBox;
    upleft = [rad_stats(1),rad_stats(2)];
    width = rad_stats(3);
    height = rad_stats(4);
    downright= upleft + [width,height];
    upright = upleft+[width, 0];
    downleft = downright - [width,0]; 
    
    center_rad = (upleft + downright)/2;
%     corner2 = (upright + downleft)/2;
%     center_rad = (center_rad + corner2 )/2 ;
%     
    %imshow(rad_l);
    hold on
    plot(center_rad(1),center_rad(2),'Color','g','Marker','x', 'MarkerSize',3)
    hold off
    
    res = str2num(get(handles.res_txt,'String'));
    mag = str2num(get(handles.mag_txt,'String'));
    mag2 = 1.0/mag;  % since object = image/maginification factor
    center = [center_rad ; center_ball];
    %delx = abs(center_rad(1) - center_ball(1))
    %dely = abs(center_rad(2) - center_ball(2)) 
    
    diff = pdist(center, 'euclidean' );
    %diff = sqrt(sum((center_rad - center_ball) .^ 2));
    diff2 = diff * mag2 * res;
    set(handles.distance_txt, 'String', num2str(diff2));

    % marking the filtered images
    axes(handles.axes3);
    hold on
    plot(center_rad(1),center_rad(2),'Color','g','Marker','x', 'MarkerSize',3)
    hold off
    zoom(zz)
    
    axes(handles.axes2);
    hold on
    plot(center_ball(1),center_ball(2),'Color','magenta','Marker','+', 'MarkerSize',3)
    hold off
    zoom(zz)
    
    axes(handles.axes1)
    zoom(zz)
end
