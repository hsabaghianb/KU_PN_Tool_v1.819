
function h = Draw_PN_Model_2(H)

% ایجاد یک شیء از کلاس graph
g = graph();

% اضافه کردن چند راس به گراف
% راسهای محلها با شکل دایره و راسهای ترانزیشنها با شکل مستطیل نمایش داده میشوند
% برچسب راسها شامل شماره، نام و پارامترهای مربوطه است
% رنگ راسها بر اساس نوع محل یا ترانزیشن تعیین میشود
for i = 1:numel(H.P) % برای هر محل
g.add_node(['P' num2str(i)], 'shape', 'circle', 'label', [num2str(i),'-',H.P{i},',',num2str(H.Cap(i)), '(', num2str(numel(H.M0{i})), ')']);
if H.Pl_Type(i)==0 % اگر محل عادی باشد
g.set_node_attr(['P' num2str(i)], 'color', [0.85,0.85,0.85]); % رنگ خاکستری
g.set_node_attr(['P' num2str(i)], 'linecolor', [0,0,0]); % رنگ خط مشکی
g.set_node_attr(['P' num2str(i)], 'textcolor', [0,0,0]); % رنگ متن مشکی
elseif H.Pl_Type(i)==1 % اگر محل نهایی باشد
g.set_node_attr(['P' num2str(i)], 'color', [1,1,1]); % رنگ سفید
g.set_node_attr(['P' num2str(i)], 'linecolor', [0,0,0]); % رنگ خط مشکی
g.set_node_attr(['P' num2str(i)], 'textcolor', [0,0,0]); % رنگ متن مشکی
end
end

for i = 1:numel(H.T) % برای هر ترانزیشن
g.add_node(['T' num2str(i)], 'shape', 'box', 'label', [num2str(i),'-',H.T{i},',',num2str(H.Delay(i)), '/', num2str(H.TknDly(i)), '/', num2str(H.Priority(i)), '/', num2str(H.ProbWeight(i))]);
if H.Tr_Type(i)==0 % اگر ترانزیشن فوری باشد
g.set_node_attr(['T' num2str(i)], 'color', [0,0,0]); % رنگ مشکی
g.set_node_attr(['T' num2str(i)], 'linecolor', [0,0,0]); % رنگ خط مشکی
g.set_node_attr(['T' num2str(i)], 'textcolor', [1,1,1]); % رنگ متن سفید
g.set_node_attr(['T' num2str(i)], 'fontsize', g.get_node_attr(['T' num2str(i)], 'fontsize') + 2); % اندازه متن بزرگتر
elseif H.Tr_Type(i)==1 % اگر ترانزیشن زماندار باشد
g.set_node_attr(['T' num2str(i)], 'color', [1,1,1]); % رنگ سفید
g.set_node_attr(['T' num2str(i)], 'linecolor', [0,0,0.4]); % رنگ خط آبی تیره
g.set_node_attr(['T' num2str(i)], 'textcolor', [0,0,0.4]); % رنگ متن آبی تیره
elseif H.Tr_Type(i)==2 % اگر ترانزیشن تصادفی نمایی باشد
g.set_node_attr(['T' num2str(i)], 'color', [0.85,0.85,0.85]); % رنگ خاکستری
g.set_node_attr(['T' num2str(i)], 'linecolor', [0,0,0]); % رنگ خط مشکی
g.set_node_attr(['T' num2str(i)], 'textcolor', [0,0,0]); % رنگ متن مشکی
elseif H.Tr_Type(i)==3 % اگر ترانزیشن تصادفی نرمال باشد
g.set_node_attr(['T' num2str(i)], 'color', [0.85,0.85,0.85]); % رنگ خاکستری
g.set_node_attr(['T' num2str(i)], 'linecolor', [0,0,0]); % رنگ خط مشکی
g.set_node_attr(['T' num2str(i)], 'textcolor', [0,0,0]); % رنگ متن مشکی
elseif H.Tr_Type(i)==4 % اگر ترانزیشن تصادفی یکنواخت باشد
g.set_node_attr(['T' num2str(i)], 'color', [0.85,0.85,0.85]); % رنگ خاکستری
g.set_node_attr(['T' num2str(i)], 'linecolor', [0,0,0]); % رنگ خط مشکی
g.set_node_attr(['T' num2str(i)], 'textcolor', [0,0,0]); % رنگ متن مشکی
elseif H.Tr_Type(i)>=11 && H.Tr_Type(i)<=23 % اگر ترانزیشن یک جزء BPMN باشد
g.set_node_attr(['T' num2str(i)], 'color', [1,1,1]); % رنگ سفید
g.set_node_attr(['T' num2str(i)], 'linecolor', [0,0,0.4]); % رنگ خط آبی تیره
g.set_node_attr(['T' num2str(i)], 'textcolor', [0,0,0.4]); % رنگ متن آبی تیره
else
errmsg=['Error:Transition Type ', num2str(Type), ' is unknown! (in transition ''', Name, ''')'];
error(errmsg);
end
end

% اضافه کردن چند یال به گراف
% یالها بین محلها و ترانزیشنها قرار میگیرند
% وزن یالها برابر با تعداد نشانههای لازم برای فعال شدن ترانزیشنها است
for i = 1:size(H.Pre,1) % برای هر سطر ماتریس Pre
for j = 1:size(H.Pre,2) % برای هر ستون ماتری

