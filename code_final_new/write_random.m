function write_random(slip_name,frequency,fraction)
    fid=fopen('Random.txt','w');
    for i=1:size(slip_name,2)
        fprintf(fid,'%s\t%d\t%f\n',slip_name(i),frequency(i),fraction(i));
    end
    fclose(fid);
end