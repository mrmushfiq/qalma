function dicomF2(handles,image)
    img = image;
    w1 = get(handles.w1_pop, 'Value');
    w2 = get(handles.w2_pop, 'Value');
    
    lefty = str2num(get(handles.width_left_txt, 'String'));
    righty = str2num(get(handles.width_left_txt, 'String'));
    
    if get(handles.wiener_check, 'Value')==1
        img = wiener2(img,[w1,w2]);
    end
    
    
    [r,c] = size(img);
 
    n=get(handles.picket_num_pop,'Value');
 
    hold on
    [x,y] = ginput(n);
    pos = [x,y];
    marked = insertMarker(img,pos,'o','color','yellow','size',14);
    imshow(marked,'Parent',handles.axes1);
    hold off
 

    level = str2num(get(handles.level_txt, 'String'));
    profile_y = cell(n);
    profile_x = cell(n);

    for j=1:n
        %profile_y{j} = img(:,round(x(j))+29);
        profile_y{j} = img(:,round(x(j))+level);
    end

    for l=1:n
        profile_x{l} = img(round(y(l)),:);
    end 



  
    hold on
    
    imshow(marked);
    
    hold off

    for p=1:n

       pix2 = profile_y{p}; 
       pix2 = double(pix2);

      if p==1  
        f_y=figure;
        plot(pix2);
        savefig('f_y.fig');
        close(f_y);
      end
       
       [Maxima,MaxIdx] = findpeaks(pix2);
       DataInv = 1.01*max(pix2) - pix2;
       [Minima,MinIdx] = findpeaks(DataInv);
        Minima = pix2(MinIdx);


        MinIdx2 = MinIdx;
        
        
        min_s = MinIdx2; % just added 
        
        for i=1:length(min_s)-1
            leafpos(i) = (min_s(i) + min_s(i+1))/2; 
        end

        %figure
        %imshow(img);
        %imshow(marked);


        hold on
        col = num2str(p);
        text([round(x(p))+level],[0],col, 'Color','black')

        for j=1:length(leafpos)
        %   line([round(x(1))-30 round(x(1))-20],[leafpos(j) leafpos(j)],'Color','r')
            name = num2str(j);
            if p==1
                text([round(x(p))],[leafpos(j)],name, 'Color','yellow')
            end
            line([round(x(p))+level],[leafpos(j)],'Color','r','Marker','*', 'MarkerSize',3)
        end

        hold off

        hold on

        for j=1:length(min_s)
            line([round(x(p))+level-4 round(x(p))+level+11],[min_s(j) min_s(j)],'Color','g')
        end


        hold off

        min_data{p,:} = min_s;
        size_l(p)= length(min_s);

        for l=1:length(leafpos)
            profile_edge{l} = img(round(leafpos(l)),:);
            my_x = round(x(p));
            y_raw= profile_edge{l};
            
            % moving average
            width=str2double(get(handles.smoothing_param,'String'));
            a=1;
            b= ones(1,width)/width;
            y_pro = filter(b,a,double(y_raw));
           
            if  l == round(length(leafpos)/2) & p == 1
                profile1 = y_pro;
                f_x_s=figure;
              

                plot(y_pro);

                
                savefig('f_x_s.fig');
                close(f_x_s);
            end
            
            [Maxima_full,MaxIdx_full] = findpeaks(y_pro);
            % now we inverse ypro and and Maxima becomes minima
            y_pro = 1.01*max(y_pro) - y_pro;
            [Mimima_full,MinIdx_full] = findpeaks(y_pro);
            x_pro = 1:1:length(y_pro);
            
            for i=1:length(y_pro)
               if (i < my_x- lefty | i > my_x+ righty)
                   y_pro(i)=0;
               end
            end
            
            %count_m = 1;

            

            y_pro = double(y_pro);
            Inv_e = 1.01*max(y_pro) - y_pro;
            [Minima_e,MinIdx_e] = findpeaks(Inv_e);
            Minima_e = y_pro(MinIdx_e);
            avg_e = mean(Minima_e);
            


            %cutting to the level of minimm minima
            nonzero = find(y_pro > 0);
            y_pro(nonzero) = y_pro(nonzero) - min(Minima_e) ;

            %interpolate
            xx = 1:0.1:length(y_pro);
            y_pro = spline(x_pro,y_pro,xx);

            ymax= max(y_pro);  %finding max
            f_e= find(y_pro == ymax); %get index for max y
            center = max(xx(f_e)); %finding center
            y_norm = y_pro./ymax; %Normalize to 1

            x_r=find(xx >= center); %indices of xx
            x_l=find(xx <= center);

            y_r = y_norm(x_r);
            y_l = y_norm(x_l);

            h_r= min(find(y_r <= 0.5)); %indices
            h_l= max(find(y_l <= 0.5));

            fwhm_l = xx(x_l(h_l));
            fwhm_r = xx(x_r(h_r));

            %disp('pixel');
            fwhm(l) = ( fwhm_r -fwhm_l );
            fwhm_pix(p,l) = ( fwhm_r -fwhm_l );
            
            %disp('in mm');
            
            mag = str2num(get(handles.mag_txt, 'String'));
            
            res = str2num(get(handles.res_txt, 'String'));
            
            factor = res / mag ;
            gap(p,l) = fwhm(l) * factor ;
            
            
            %gap_cell{p} = fwhm(l) * 0.781 ./mag;

            dis = num2str(gap(p,l));
            dis_pix = num2str(fwhm_pix(p,l));
            
            hold on
            plot([fwhm_l],[leafpos(l)],'Color','magenta','Marker','+', 'MarkerSize',3)
            plot([fwhm_r],[leafpos(l)],'Color','magenta','Marker','+', 'MarkerSize',3)
           % text([round(x(p))+30],[leafpos(l)],dis, 'Color','yellow')
           
            hold off

        end

      
    end 
    
    min_l = min(size_l);

   for z=1:n 
        min_data{z}=[min_data{z,1}(1:min_l)];
   end
   
   [r1 c1] = size(min_data);
   
   min_data = reshape(min_data,[c1 r1]);

   
   min_data = cell2mat(min_data);
   
    set(handles.data_transfer_min,'Data',min_data);
   
    xy(:,1)=x;  % array of inputs converted to table
    xy(:,2)=y;
    set(handles.xy_data, 'Data', xy);

    %capture current graph
    frame = getframe(handles.axes1)
    im_now = frame2im(frame);
    %im_now = getimage(gcf); 
    imwrite(im_now,'current_positions.png')

    f1=figure;
    [ab,cd] = size(gap);
    t=1:1:cd;
    nbins = cd;
    
    
    for s=1:ab
        hold on
        %plot(subplot(ab,1,s),t,gap(s,:),'Marker','*');
        bar(subplot(ab,1,s),t,gap(s,:));
        %bar(subplot(ab,1,s),t,fwhm_pix(s,:));
        title(subplot(ab,1,s), num2str(s));
        xlabel('Leaves') % x-axis label
        ylabel('Gaps(in mm)') % y-axis label
        hold off
        hold on
        line([1 cd],[mean(gap(s,:)) mean(gap(s,:))],'LineWidth', 3,'Color','r');
        text([cd + 1],[mean(gap(s,:))],num2str(mean(gap(s,:))),'Color','r');
        text([cd + 1],[mean(gap(s,:)) + 11 ],num2str(std(gap(s,:))),'Color','m');
        text([cd - 12],[mean(gap(s,:)) + 11 ],'Standard Deviation','Color','m');
        hold off
    end
    
    
    
    saveas(f1,'edge_gaps.png');
    pause(2);
    close(f1);
    

    f_x=figure;
    set(f_x, 'Position', [100, 100, 725, 648]);
    hold on
    plot(profile1);
    hold off

    liner = 1:2:700;
    liner = double(liner);

    hold on 
    line([round(x(p))- lefty],[liner],'Color','r','Marker','.', 'MarkerSize',2);
    line([round(x(p))+ righty],[liner],'Color','r','Marker','.', 'MarkerSize',2);
    hold off

    %saveas(f_x,'f_x.fig');
    savefig('f_x.fig');
    close(f_x);
   
   % imshow(x_img);
   if get(handles.profile_check, 'Value') == 1
       openfig('f_x.fig');
   end
   
   if get(handles.profile_v_check,'Value')== 1
    openfig('f_y.fig');
   end
end
   

