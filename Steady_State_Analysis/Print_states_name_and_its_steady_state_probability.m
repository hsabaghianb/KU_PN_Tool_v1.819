function Print_states_name_and_its_steady_state_probability(RM,P) 
    fprintf('Index   Pl_Marking   Steady State Probability\n');
    for i=1:size(RM,2)
        label='';
        for j=1:numel(RM(:,i))
            str=num2str(RM(j,i));
            if (numel(str)>1)
                str=['(',str,')'];
            end
            label=strcat(label, str);
        end
        fprintf('%5d   %s         %6.4f\n', i, label,P(i));
    end
end