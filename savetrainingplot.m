function stop=savetrainingplot(info)

stop=false;  %prevents this function from ending trainNetwork prematurely
if info.State == 'done'   %check if all iterations have completed
% if true
        curFig = findall(groot, 'Type', 'Figure');
        saveas(curFig(1),'train.png')  % save figure as .png, you can change this
end

end