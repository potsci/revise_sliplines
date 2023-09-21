function write_random1(slip_name,frequency,fraction,path)
    fid=fopen([path,'\Random with SF.txt'],'w');
    for i=1:size(slip_name,2)
        fprintf(fid,'%s\t%d\t%f\n',slip_name(i),frequency(i),fraction(i));
    end
    fclose(fid);
end