function progressbar(handles,nload)
    set(handles.figure1,'name',handles.str);
    set(handles.text_progress,'String',strcat(num2str(0),' %'),'FontSize',8);
    progpatch = patch(...
            'XData',            [0 0 0 0],...
            'YData',            [0 0 1 1]);%patch
    percentdone = 0;
    set(handles.text_progress,'String',strcat(num2str(percentdone),' %'),'FontSize',8);
    set(progpatch,'FaceColor',handles.color); 

    fractiondone = (nload);
    percentdone = floor(100*fractiondone);
    if percentdone>98
        percentdone=100; fractiondone=1;
    end
    % Update progress patch
    axes(handles.axes2)
    if percentdone
        set(progpatch,'XData',[0 fractiondone fractiondone 0]);
    end
    set(handles.text_progress,'String',strcat(num2str(percentdone),' %'),'FontSize',8);
    % Force redraw to show changes
    drawnow
end
% 
% x = [100 100 0 0];
% y = [100 100 100 100];
% patch(x,y,'red')
