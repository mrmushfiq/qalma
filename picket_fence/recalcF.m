function recalcF(handles,image)

    img = image; 
    min_data = get(handles.data_transfer_min, 'Data');
    my_line = get(handles.select_line,'Value');
    xy = get(handles.xy_data,'Data');
    x=xy(:,1);
    column = get(handles.column_mlc, 'Value');
    
    
    lefty = str2num(get(handles.width_left_txt, 'String'));
    righty = str2num(get(handles.width_left_txt, 'String'));
    
    n=get(handles.picket_num_pop,'Value');
   
    imshow(img);


    for p=1:n

        min_s = min_data(:,p);
        
        for i=1:length(min_s)-1
            leafpos(i) = (min_s(i) + min_s(i+1))/2; 
        end


 %------------
        for l=1:length(leafpos)
            profile_edge{l} = img(round(leafpos(l)),:);
            my_x = round(x(p));
            y_raw= profile_edge{l};
            
            % moving average
            width=str2double(get(handles.smoothing_param,'String'));
            a=1;
            b= ones(1,width)/width;
            y_pro = filter(b,a,double(y_raw));
            
           % f_x=figure;
           % plot(y_pro);
           % saveas(f_x,'f_x.png');
           % close(f_x);
            
            [Maxima_full,MaxIdx_full] = findpeaks(y_pro);
            % now we inverse ypro and and Maxima becomes minima
            y_pro = 1.01*max(y_pro) - y_pro;
            [Mimima_full,MinIdx_full] = findpeaks(y_pro);
            x_pro = 1:1:length(y_pro);
            
            for i=1:length(y_pro)
               if (i < my_x-lefty | i > my_x + righty)
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
            
           % gap(p,l) = fwhm(l) * 0.781;
            mag = str2num(get(handles.mag_txt, 'String'));
            
            res = str2num(get(handles.res_txt, 'String'));
            
            factor = res / mag ;
            gap(p,l) = fwhm(l) * factor ;
            
            
            gap_cell{p} = fwhm(l) * 0.781;

            dis = num2str(gap(p,l));
            dis_pix = num2str(fwhm_pix(p,l));
            
            hold on
            plot([fwhm_l],[leafpos(l)],'Color','magenta','Marker','+', 'MarkerSize',3)
            plot([fwhm_r],[leafpos(l)],'Color','magenta','Marker','+', 'MarkerSize',3)
           % text([round(x(p))+30],[leafpos(l)],dis, 'Color','yellow')
           
            hold off

        end

      
    end 
    
        %capture current graph
    frame = getframe(handles.axes1)
    im_now = frame2im(frame);

    
    f1=figure
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
        hold off
    end
    close(f1);

end