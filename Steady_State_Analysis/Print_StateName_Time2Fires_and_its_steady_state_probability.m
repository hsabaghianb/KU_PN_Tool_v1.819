function Print_StateName_Time2Fires_and_its_steady_state_probability(RM,RMD,RMTD,P) 
    item={};
    max1=0;
    max2=0;
    max3=0;
    for i=1:size(RM,2)
        label1=''; %Marking
        for j=1:numel(RM(:,i))
            str1=num2str(RM(j,i));
            if (numel(str1)>1)
                str1=['(',str1,')'];
            end
            label1=strcat(label1, str1);
        end
        
        label2='';  %delays
        for j=1:numel(RMD(:,i))
            str2=num2str(RMD(j,i));
            if (numel(str2)>1)
                str2=['(',str2,')'];
            end
            label2=strcat(label2, str2);
        end

        label3='{'; %token delays
        for j=1:numel(RMTD{i})
            str3='[';
            for k=1:numel(RMTD{i}{j})    
                str3=[str3,num2str(RMTD{i}{j}{k})];
                if k<numel(RMTD{i}{j}) 
                   str3=[str3,','];
                end
            end
            str3=[str3,']']; 
            if j<numel(RMTD{i}) 
               str3=[str3,','];
            end
            label3=strcat(label3, str3);
        end
        label3=[label3,'}']; 


%       save printing items in matrix cell array
        item{i,1}=label1;
        item{i,2}=label2;
        item{i,3}=label3;

%       Obtain max lenght of each item
        if numel(label1)>max1
            max1=numel(label1);
        end
        if numel(label2)>max2
            max2=numel(label2);
        end
        if numel(label3)>max3
            max3=numel(label3);
        end
    end

%   print title and printing items 
        label1='Pl_Marking';
        label2='Trans_delay';
        label3='Token-delay';
        len1=numel(label1);
        len2=numel(label2);
        len3=numel(label3);
        if max1<len1
            max1=len1;
        end
        if max2<len2
            max2=len2;
        end
        if max3<len3
            max3=len3;
        end
        label1=[repmat(' ',1,fix((max1-len1)/2)),label1, repmat(' ',1,fix((max1-len1)/2))];
        label2=[repmat(' ',1,fix((max2-len2)/2)),label2, repmat(' ',1,fix((max2-len2)/2))];
        label3=[repmat(' ',1,fix((max3-len3)/2)),label3, repmat(' ',1,fix((max3-len3)/2))];
        fprintf('Index   %s   %s   %s   Steady State Probability\n', label1,label2,label3);

    for i=1:size(RM,2)
%       line-up printing items by adding blanks before printing
        item{i,1}=[item{i,1},repmat(' ',1,max1-numel(item{i,1}))];
        item{i,2}=[item{i,2},repmat(' ',1,max2-numel(item{i,2}))];
        item{i,3}=[item{i,3},repmat(' ',1,max3-numel(item{i,3}))];
        fprintf('%5d   %s   %s   %s   %6.4f\n', i,item{i,1},item{i,2},item{i,3},P(i));
    end
end