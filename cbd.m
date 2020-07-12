% by minyaho
% 07 2020

clear all;close all;clc;

fprintf('[INFO] Coffee Bean Detection Program will start!\n')

% 參數設定
area_threshold = 1200; % 面積門檻值
gray_th=0.3; % 二元轉換門檻值

fprintf('[NOTE] The area threshold = %.1f, and the gray threshold = %.1f.\n',area_threshold,gray_th);

% 圖像讀取
filename=input('[INFO] Pleas input image file name (like *.jpg): ','s');
im = imread(filename);
%figure,imshow(im); % 顯示原圖

% 灰階轉換
imgy=rgb2gray(im);
%figure,imshow(imgy); % 顯示灰階圖

% 二元轉換
imb=im2bw(imgy,gray_th);
figure,imshow(imb); % 顯示二元圖

% 雜訊處理 (閉運算)
sq=ones(11,11);
imb=imopen(imb,sq);
figure,imshow(imb);

% 邊緣偵測
edge_im=edge(imb,'canny');
%figure,imshow(edge_im);

% 標記物體
% 概述:
%   bwlabel(IMAGE,)是二元圖像元素的標記演算法，
%   主要對二維二元圖像中各個分離的部分進行標記。
% 用法:
%   L = bwlabel(BW,n) or [L,num] = bwlabel(BW,n)
% 說明:
%   表示返回和BW相同大小的數組L。 
%   L中包含了連通對象的標註。
%   參數n為4或8，分別對應4鄰域和8鄰域，默認值為8。

[mark_image,num] = bwlabel(edge_im,8);
% mark_image: 標記的二元圖像位置
% num: 標記的元素個數

% 方框標記:[x,y,disp_x,disp_y]
% 目的:框住被辨識的物體
status=regionprops(mark_image,'BoundingBox');

% 中心點標記:[x,y]
% 目的:標記出辨識的物體的中心點
centroid = regionprops(mark_image,'Centroid');

% 顯示標記後的圖像
figure,imshow(mark_image),title('標記後的圖像');

% 在圖像上附加方框標記與索引標記
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
	text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
end

% 找出二元圖像中最大面積的物體
area_array=[1:num];
for i=1:num
	copy_mark_image = mark_image;
	image_part = (copy_mark_image == i);
    round_area = regionprops(image_part,'Area');
	area_array(i)=round_area.Area;
end

fprintf('[INFO] %s: Detecting...\n',filename);

% 截出咖啡豆
[max_value,index]=max(area_array);
if max_value > area_threshold
    % 成功偵測訊息
	fprintf('[INFO] %s: Successful! We find it.\n', filename)

    % 取得目標物座標+數值轉換運算
	label_pos=int32(floor(centroid(index).Centroid));
    
    % 座標數值修正
    pos(1)=label_pos(2)-249;
    pos(2)=label_pos(2)+250;
    pos(3)=label_pos(1)-249;
    pos(4)=label_pos(1)+250;
    
    % 座標範圍修正 (臨界值處理)
    size_im = size(im);
    if pos(1) <= 0; pos(1)=1; end
    if pos(2) >= size_im(1); pos(2)=size_im(1); end
    if pos(3) <= 0; pos(1)=1; end
    if pos(4) >= size_im(2); pos(4)=size_im(2); end
    
    % 取得目標訊息
	target=im(pos(1):pos(2),pos(3):pos(4),:);
    
    % 顯示結果
	figure,imshow(target)
	imwrite(target,[filename,'_result','.jpg']);
    fprintf('[SAVE] %s: Save in %s\n', filename, [filename,'_result','.jpg'])

else
    % 錯誤偵測訊息
	fprintf('[INFO] %s: Failed! We can''t find it.\n', filename )
    
end
