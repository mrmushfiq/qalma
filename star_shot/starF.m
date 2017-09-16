function [radii,pass] = starF(handles,image)
    
%     img=im2double(image);  % converting to gray
%     img=mat2gray(img);      
%     rgb=img(:,:,[1 1 1]);  %converting to rgb
    if length(size(image)) == 3
        img = rgb2gray(image); 
    else
        img=im2double(image); 
        img=mat2gray(img);      
    end
    
  
    % set(handles.wiener_check, 'Value', 0)
   
    [r c channels]=size(img);
    
    w1 = get(handles.w1_pop,'Value');
    w2 = get(handles.w2_pop,'Value');
        
    m_avg = str2num(get(handles.avg_txt, 'String'));
    
    if get(handles.crop_check, 'Value') == 1
        img = imcrop(img,[round(c/20) round(r/20) c/1.2 r/1.3]);
    end
    
    if get(handles.wiener_check, 'Value') == 1
        img = wiener2(img,[w1,w2]);
    end
     
    man = get(handles.manual_check,'Value');
    center_v = get(handles.center_check, 'Value'); 
    %figure
    %imshow(I2);
    %c0 = round(ginput(1));
    
    I2 = img;
    [r1 c1 channels] = size(img);
    if man == 1 & center_v ==1
        c0 = round(ginput(1));
    else
        c0 = [round(c1/2), round(r1/2)];
    end
    
    edge_center_y = [0, c0(2)];
    edge_center_x = [c0(1), 0];

    rad_x = 0.6*pdist([c0;edge_center_x], 'euclidean' );
    rad_y = 0.6*pdist([c0;edge_center_y], 'euclidean' );

    if rad_x <= rad_y
        rad = rad_x;
    else
        rad = rad_y;
    end



    k = 0;

    %added extra pi/4 to get the half of the wave
    %So need a condition 360+ theta = theta
    %could add pi/6 for more numbers
    for theta = 0:pi/300:2*pi  
        k = k+1;
        c_x(k) = round(rad*cos(theta)) + c0(1);
        c_y(k) = round(rad*sin(theta)) + c0(2);
    end


    % because colum -> x and row -> y
    for i=1:length(c_x)
        profile(i) = img(c_y(i), c_x(i));
    end

    width = m_avg;
    ap=1;
    b= ones(1,width)/width;
    profile = double(profile);
    profile = filter(b,ap,profile);


    [Maxima,MaxIdx] = findpeaks(profile);
    DataInv = 1.01*max(profile) - profile;
    [Minima,MinIdx] = findpeaks(DataInv);
    Minima = profile(MinIdx);

    dev = mean(Minima) - Minima;
    del = find(Minima >= mean(Minima)+ 0.05*Minima);
    %or remove the ones less than five percent of max
    Minima(del)=[];
    MinIdx(del)=[];

    if min(MinIdx) < min(MaxIdx)  
        Minima(1)=[];
        MinIdx(1)=[];
    end

    if mod(length(MinIdx),2) ~= 0
        pass = 0;
        radii = '-';
        h = msgbox({'Uneven number of spokes detected. Please switch to manual mode choosing a center of the image'});
        pause(2)
        delete(h);
        return
    else
        pass = 1; 
    end

  %  figure
  %  plot(profile)
  %  hold on
  %  plot(MinIdx, Minima,'o')
  %  hold off

    for m = 1:length(MinIdx)
        if m<=length(MinIdx)/2
            p1_x(m) = c_x(MinIdx(m));
            p1_y(m) = c_y(MinIdx(m));
        else
            p2_x(m- round(length(MinIdx)/2)) = c_x(MinIdx(m));
            p2_y(m-round(length(MinIdx)/2)) = c_y(MinIdx(m));
        end    
    end

    left  = min(min(p1_x), min(p2_x));
    right = max(max(p1_x), max(p2_x));


    sol_count = 1;
    lines = 1:1:length(MinIdx)/2 ;
    permsize =  nchoosek(length(MinIdx)/2, 2);
    perms = nchoosek(lines,2);


    for k=1:permsize
        syms x;
        a1 = (p2_y(perms(k,1)) - p1_y(perms(k,1)))/(p2_x(perms(k,1)) -p1_x(perms(k,1))) ;
        b1 = p1_y(perms(k,1)) - a1*p1_x(perms(k,1));

        a2 = (p2_y(perms(k,2)) - p1_y(perms(k,2)))/(p2_x(perms(k,2)) -p1_x(perms(k,2))) ;
        b2 = p1_y(perms(k,2)) - a2*p1_x(perms(k,2));

        sol_x1 = solve(a1*x + b1 == a2*x + b2, x);
        sol_y1 = a1*sol_x1 + b1;

        int_x(sol_count) = (abs(sol_x1));
        int_y(sol_count) = (abs(sol_y1));
        sol_count = sol_count + 1; 

    end

    qa = 0;
    qb = 0;
    qc = 0;
    syms a;
    syms b;
    syms c;

    for s=1:permsize
        qa = qa + ((int_x(s))^2 + (int_y(s))^2 + a*int_x(s) + b*int_y(s) + c)*2*int_x(s);
        qb = qb + ((int_x(s))^2 + (int_y(s))^2 + a*int_x(s) + b*int_y(s) + c)*2*int_y(s);
        qc = qc + ((int_x(s))^2 + (int_y(s))^2 + a*int_x(s) + b*int_y(s) + c)*2;
    end 

    % find center
    abc = solve(qa == 0, qb == 0, qc == 0, [a b c]);
    cc_x = - abc.a/2;
    cc_y = - abc.b/2;

    % find radius

    for s=1:permsize
        dist(s) = sqrt((int_x(s) - cc_x)^2 + (int_y(s) - cc_y)^2);
    end

    radius = double(max(dist));
    mag = str2num(get(handles.mag_factor_txt, 'String'));
    res = str2num(get(handles.resolution_txt, 'String'));
    
    c_n = 0;

    for theta = 0:pi/100:2*pi  
        c_n = c_n+1;
        circ_x(c_n) = (radius*cos(theta)) + cc_x;
        circ_y(c_n) = (radius*sin(theta)) + cc_y;
    end

    % multiply by  resolution(each pixel length)
    radius2 = radius * res / mag ;

 %  figure
 %  imshow(I2);
 %   hold on
    %imshow(I2,'Parent',handles.axes1);
 %   hold off
 %   hold on
 %   plot(c0(1),c0(2),'Color','Blue','Marker','+', 'MarkerSize',5);
 %   hold off

    imshow(img,'Parent',handles.axes1);

    axes(handles.axes1);

    hold on
    plot(c_x(MinIdx),c_y(MinIdx),'g+');
    hold off


    hold on

    for j=1:length(MinIdx)/2
        line([p1_x(j) p2_x(j)],[p1_y(j) p2_y(j)],'Color','red')
    end

    hold off




    hold on
    for xi=1:permsize
        plot(int_x(xi), int_y(xi), 'yx');
    end

    hold off


    hold on 
    plot(cc_x, cc_y, 'y+');
    hold off


    hold on

    plot(circ_x, circ_y, 'g.')

    hold off
    
    
    set(handles.axes1, 'Units', 'pixels', 'Position', [60, 200, 250, 250],...
        'box','off','XTickLabel',[],'xtick',[],'YTickLabel',[],'ytick',[]);
    
        
    frame = getframe(handles.axes1);
    imf = frame2im(frame);
    imwrite(imf, 'starshot.png');
    imshow(imf,'Parent',handles.axes2);
    set(handles.axes2, 'Units', 'pixels', 'Position', [300, 200, 260, 260],...
        'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    axis off;
    
    axes(handles.axes1);

    zoom(10);
    axis([double(cc_x - radius - 1) double(cc_x + radius + 1) double(cc_y - radius -1) double(cc_y + radius +1)]);
    
    frame = getframe(handles.axes1);
    imf2 = frame2im(frame);
    imwrite(imf2, 'starshot_zoomed.png');
    
    radii = num2str(double(radius2));
 
    set(handles.radius_txt, 'String', num2str(double(radius2)));
    set(handles.mm_txt, 'visible', 'on');
    set(handles.radius_txt, 'visible', 'on');
    set(handles.radius_name, 'visible', 'on');
    set(handles.comment_txt, 'visible', 'on');
    set(handles.report_button, 'visible', 'on');
    
    
end