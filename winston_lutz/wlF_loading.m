function wlF_loading(handles, img_url)

    %img_d = imread(img_url);
    img_d = dicomread(img_url);
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));
        %imshow(img);
    img = wiener2(img,[5,5]);    
        
    zz = get(handles.zoom_pop, 'Value');
    imshow(img,'Parent',handles.axes1);
    axes(handles.axes1); 
    zoom(zz);
    
    
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
        axes(handles.axes2);
        zoom(zz)
        
        rad_l = bwlabel(rad_b);
        imshow(rad_l,'Parent',handles.axes3);
        axes(handles.axes3);
        zoom(zz)
        %imshow(ball_l);
        %zoom(3)
        
        stats = regionprops(ball_l,'Centroid');
        center_ball = stats.Centroid;
    catch
        h = msgbox('Opps! You lost the object. Please increase or decrease the parameters for it to reappear');
    end
      
    
   % imshow(img,'Parent',handles.axes1);
     
    
   % axes(handles.axes1);
    
%     hold on
%     plot(center_ball(1),center_ball(2),'Color','magenta','Marker','+', 'MarkerSize',3)
%     hold off
% 
%     stats2 = regionprops(rad_l,'BoundingBox');
%     rad_stats= stats2.BoundingBox;
%     upleft = [rad_stats(1),rad_stats(2)];
%     width = rad_stats(3);
%     height = rad_stats(4);
%     downright= upleft + [width,height];
%     upright = upleft+[width, 0];
% 
%     center_rad = (upleft + downright)/2;
% 
%     %imshow(rad_l);
%     hold on
%     plot(center_rad(1),center_rad(2),'Color','g','Marker','x', 'MarkerSize',3)
%     hold off
% 
%     center = [center_rad ; center_ball];
%     diff = pdist(center, 'euclidean' )
end
