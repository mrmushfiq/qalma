function ciF(handles,img_url)
    img = dicomread(img_url);
 
    img=im2double(img);
    img=uint8(255*mat2gray(img));
   
    w1 = get(handles.w_1_pop, 'Value');
    w2 = get(handles.w_2_pop, 'Value');
    
    wr= get(handles.wiener_check, 'Value');
    
    if wr == 1
        img=wiener2(img, [w1,w2]);
    end
    
    
    cont2 = get(handles.contrast_high_slider, 'Value');
    cont1 = get(handles.contrast_low_slider, 'Value');
    
    img2 = imadjust(img,[cont1 cont2],[]);  %or at 0.8
   
    %img=wiener2(img, [4,2]);
    %img=wiener2(img, [2,2]);
    %img2 = imadjust(img,[0 0.84],[]); 
    
    dk = get(handles.dark_check, 'Value');
    bt = get(handles.bright_check, 'Value');
    
    if dk == 1
        pol = 'dark';
    elseif bt == 1
        pol = 'bright'
    else 
        h = msgbox({'Please check atleast one box'});
    end
    
    sense = get(handles.sensitivity_slider, 'Value' );
    thresh = get(handles.threshold_slider, 'Value' );
    r1 = get(handles.radius1_pop, 'Value');
    r2 = get(handles.radius2_pop, 'Value');
    
    warning('off','all');

    if get(handles.manual_check,'Value') == 0
        [centers, radii] = imfindcircles(img2,[r1 r2],...
         'ObjectPolarity', pol,'Sensitivity',sense,'EdgeThreshold',thresh, 'Method','twostage');
    else
        centers = ginput(4);
    end
    
    axes(handles.axes1); 
    %figure(1)
    imshow(img2);
    
    if get(handles.manual_check,'Value') == 1
        hold on
        plot(centers(:,1),centers(:,2), 'bx','MarkerSize',12);
        hold off
    end
    
    hold on
    %plot(centers(:,1),centers(:,2), 'r+');
    p1 = line(centers(:,1),centers(:,2), 'Color', 'green', 'linewidth',3);
    line([centers(4,1) centers(1,1)],[centers(4,2) centers(1,2)],'Color', 'green', 'linewidth',3);
    hold off
    %viscircles(centers,radii);

    centers2 = round(sortrows(centers,1));

    profile{1} = img2(:, centers2(1,1));  %y
    profile{2} = img2(centers2(1,2),:);   %x
    profile{3} = img2(:, centers2(3,1));  %y
    profile{4} = img2(centers2(4,2), :);  %x

    %figure(2)
    %plot(profile_1_y);

    for i=1:4

        pro = double(profile{i});
        Inv = 1.01*max(pro) - pro;
        pro = Inv;
        [Minima,MinIdx] = findpeaks(Inv);
        Minima = pro(MinIdx);
        avg_e = mean(Minima);

        %cutting to the level of minimm minima
       % nonzero = find(pro > 0);
       % pro(nonzero) = pro(nonzero) - min(Minima) ;

       if(size(profile{i},1) > 1) 
           x_pro = 1:1:size(profile{i},1);
       else
           x_pro = 1:1:size(profile{i},2);
       end

        %interpolate
        xx = 1:0.1:length(pro);
        y_pro = spline(x_pro,pro,xx);

        ymax= max(y_pro);
        f_e= find(y_pro == ymax); %get index for max y
        center = median(xx(f_e)); %finding center
        y_norm = y_pro./ymax; %Normalize to 1

        x_r=find(xx >= center); %indices of xx
        x_l=find(xx <= center);

        y_r = y_norm(x_r);
        y_l = y_norm(x_l);

        h_r= min(find(y_r <= 0.5)); %indices
        h_l= max(find(y_l <= 0.5));

        p_l(i) = xx(x_l(h_l));
        p_r(i) = xx(x_r(h_r));


    end
     
    setpixelposition(handles.analyze_button,[280, 70, 122, 31]);

    hold on
    p2 = line([centers2(1,1) centers2(1,1)], [p_l(1) p_r(1)], 'Color', 'Red', 'linewidth', 2 );

    line([p_l(2) p_r(2)], [centers2(1,2) centers2(1,2)], 'Color', 'Red', 'linewidth', 2 );

    line([centers2(3,1) centers2(3,1)], [p_l(3) p_r(3)],  'Color', 'Red', 'linewidth', 2);

    line([p_l(4) p_r(4)], [centers2(4,2) centers2(4,2)],  'Color', 'Red', 'linewidth', 2 );
    hold off
    legend([p1 p2], 'Light Field','Radiation Field')
    
    
    % dice coefficient 
    %light field
    x1 =centers(:,1);
    y1 =centers(:,2);
    b1 = poly2mask(x1, y1, 350, 420);
    
    x2 = [centers2(1,1)  centers2(3,1)  centers2(3,1) centers2(1,1)];
    y2 = [p_l(1)  p_l(3) p_r(3) p_r(1)];
    b2 = poly2mask(x2, y2, 350, 420);
    andim = b1 & b2;
   % orim = b1 | b2;
    dc = 2* sum(andim)/(sum(b1) + sum(b2)); 
    dc = sprintf('%0.2f',dc);  
    set(handles.dice_txt, 'String', num2str(dc)); 

end