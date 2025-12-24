function Print_probability_of_non_zero_probability_steady_state(RM,P,nonzero) 
    for i=1:size(RM,2)
        if nonzero(i)
            label=num2str(i);
            for j=1:numel(RM(:,i))
                str=num2str(RM(j,i));
                if (numel(str)>1)
                    str=['(',str,')'];
                end
                label=strcat(label, str);
            end
            fprintf('%s %6.4f\n', label,P(i));
        end
    end
end