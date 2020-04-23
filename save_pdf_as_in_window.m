function save_pdf_as_in_window(GCF,directory_str,filename_str)

if length(directory_str) > 0
    if ~exist(directory_str, 'dir')
       mkdir(directory_str)
       disp(['Created new directory: ' directory_str])       
    end
    savedir = [directory_str '/' filename_str];
else
    savedir = filename_str;
end
    
h = GCF;
set(h, 'Units','centimeters');
scrn_pos = get(h,'Position');
set(h, 'PaperPosition',[0 0 scrn_pos(3:4)],'PaperSize',[scrn_pos(3:4)]);
print(h,savedir,'-dpdf')
end