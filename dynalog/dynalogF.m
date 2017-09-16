function dynalogF(handles, f_a, f_b, p_a, p_b)

    url_a = strcat(p_a,f_a);
    url_b = strcat(p_b,f_b);    
    dataA = csvread(url_a, 6, 0);
    dataB = csvread(url_b, 6, 0);
    
    mag = str2num(get(handles.mag_txt, 'String'));
    scaleFactor = 1.96614;

    planA = dataA(:,15:4:end)/ 100 * scaleFactor * mag;
    actualA = dataA(:,16:4:end)/ 100 * scaleFactor * mag;
    planB = dataB(:,15:4:end)/ 100 * scaleFactor * mag;
    actualB = dataB(:,16:4:end)/ 100 * scaleFactor * mag;

    gap_true = actualA + actualB ;
    gap_planned = planA + planB;
    error = gap_true - gap_planned; 


    a=1;
    b= ones(1,5)/5;
    actualA_f = filter(b,a,double(abs(actualA(:,1))));
    %actualB_f = filter(b,a,double(abs(actualB(:,1))));


    [MaximaA,MaxidxA] = findpeaks(actualA_f);
    %picketsA = abs(actualA(MaxidxA, :));  

    %[MaximaB,MaxidxB] = findpeaks(actualB_f);
    %picketsB = abs(actualB(MaxidxB, :));  
    
    setpixelposition(handles.a_button,[900, 450, 140, 40]);
    setpixelposition(handles.file_a_txt,[900, 420, 150, 30]);
    setpixelposition(handles.b_button,[900, 380, 140, 40]);
    setpixelposition(handles.file_b_txt,[900, 340, 150, 30]);
    
    setpixelposition(handles.dynalyze_button,[900, 260, 140, 40]);
    
    setpixelposition(handles.comment_txt,[900, 150, 150, 100]);
    setpixelposition(handles.report_button,[900, 100, 140, 40]);
    
    set(handles.report_button,'visible','on')
    set(handles.comment_txt,'visible','on')
    setpixelposition(handles.home_button,[900, 550, 150, 40]);

       
    pickets = gap_true(MaxidxA, :);

    [r, c] =  size(pickets);
    f1=figure('Position', [100, 100, 460, 420]);
    %axis([30 400 350 500]);
    
    t=1:1:c;
    for s=1:r
        hold on
        %plot(subplot(ab,1,s),t,gap(s,:),'Marker','*');
        bar(subplot(r,1,s),t,pickets(s,:));
        title(subplot(r,1,s), num2str(s));
        xlabel('Leaves','FontWeight','bold') % x-axis label
        ylabel('Gaps(in mm)','FontWeight','bold') % y-axis label
        hold off
        hold on
        line([1 c],[mean(pickets(s,:)) mean(pickets(s,:))],'LineWidth', 3,'Color','r');
        text([c + 1],[mean(pickets(s,:))],num2str(mean(pickets(s,:))),'Color','r','FontWeight','bold');
        %text([c + 1],[mean(pickets(s,:)) + 3],num2str(std(pickets(s,:))),'Color','g');
        hold off
    end
    saveas(f1,'picket_dyn.png');
    %savefig('picket_dyn.fig');
    close(f1);
    
    axes(handles.axes1);
%     set(handles.axes1,'Units', 'pixels','Position', [50, 50, 560, 460],...
%         'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    set(handles.axes1,'Units', 'pixels','Position', [20, 290, 460, 420],...
        'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    imshow(imread('picket_dyn.png'),'Parent',handles.axes1);
%    imshow(imread('picket_dyn.fig'),'Parent',handles.axes1);
    title('Pickets');
    
    axes(handles.axes2);
    set(handles.axes2,'Units', 'pixels','Position', [540, 380, 330, 260],...
        'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    pcolor(transpose(error))
    shading flat
    colorbar
    title('Error [mm]')
    xlabel('record number')
    ylabel('leaf')

    axes(handles.axes3);
    set(handles.axes3,'Units', 'pixels','Position', [40, 40, 330, 260],...
        'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    pcolor(transpose(gap_planned))
    shading flat
    colorbar
    title('Planned gap [mm]')
    xlabel('record number')
    ylabel('leaf')

    axes(handles.axes4);
    set(handles.axes4,'Units', 'pixels','Position', [540, 40, 330, 260],...
        'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    pcolor(transpose(gap_true))
    shading flat
    colorbar
    title('True gaps [mm]')
    xlabel('record number')
    ylabel('leaf')

end