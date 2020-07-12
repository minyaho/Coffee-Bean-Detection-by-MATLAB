% by minyaho
% 07 2020

clear all;close all;clc;

fprintf('[INFO] Coffee Bean Detection Program will start!\n')

% �ѼƳ]�w
area_threshold = 1200; % ���n���e��
gray_th=0.3; % �G���ഫ���e��

fprintf('[NOTE] The area threshold = %.1f, and the gray threshold = %.1f.\n',area_threshold,gray_th);

% �Ϲ�Ū��
filename=input('[INFO] Pleas input image file name (like *.jpg): ','s');
im = imread(filename);
%figure,imshow(im); % ��ܭ��

% �Ƕ��ഫ
imgy=rgb2gray(im);
%figure,imshow(imgy); % ��ܦǶ���

% �G���ഫ
imb=im2bw(imgy,gray_th);
figure,imshow(imb); % ��ܤG����

% ���T�B�z (���B��)
sq=ones(11,11);
imb=imopen(imb,sq);
figure,imshow(imb);

% ��t����
edge_im=edge(imb,'canny');
%figure,imshow(edge_im);

% �аO����
% ���z:
%   bwlabel(IMAGE,)�O�G���Ϲ��������аO�t��k�A
%   �D�n��G���G���Ϲ����U�Ӥ����������i��аO�C
% �Ϊk:
%   L = bwlabel(BW,n) or [L,num] = bwlabel(BW,n)
% ����:
%   ��ܪ�^�MBW�ۦP�j�p���Ʋ�L�C 
%   L���]�t�F�s�q��H���е��C
%   �Ѽ�n��4��8�A���O����4�F��M8�F��A�q�{�Ȭ�8�C

[mark_image,num] = bwlabel(edge_im,8);
% mark_image: �аO���G���Ϲ���m
% num: �аO�������Ӽ�

% ��ؼаO:[x,y,disp_x,disp_y]
% �ت�:�ئ�Q���Ѫ�����
status=regionprops(mark_image,'BoundingBox');

% �����I�аO:[x,y]
% �ت�:�аO�X���Ѫ����骺�����I
centroid = regionprops(mark_image,'Centroid');

% ��ܼаO�᪺�Ϲ�
figure,imshow(mark_image),title('�аO�᪺�Ϲ�');

% �b�Ϲ��W���[��ؼаO�P���޼аO
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
	text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
end

% ��X�G���Ϲ����̤j���n������
area_array=[1:num];
for i=1:num
	copy_mark_image = mark_image;
	image_part = (copy_mark_image == i);
    round_area = regionprops(image_part,'Area');
	area_array(i)=round_area.Area;
end

fprintf('[INFO] %s: Detecting...\n',filename);

% �I�X�@�ب�
[max_value,index]=max(area_array);
if max_value > area_threshold
    % ���\�����T��
	fprintf('[INFO] %s: Successful! We find it.\n', filename)

    % ���o�ؼЪ��y��+�ƭ��ഫ�B��
	label_pos=int32(floor(centroid(index).Centroid));
    
    % �y�мƭȭץ�
    pos(1)=label_pos(2)-249;
    pos(2)=label_pos(2)+250;
    pos(3)=label_pos(1)-249;
    pos(4)=label_pos(1)+250;
    
    % �y�нd��ץ� (�{�ɭȳB�z)
    size_im = size(im);
    if pos(1) <= 0; pos(1)=1; end
    if pos(2) >= size_im(1); pos(2)=size_im(1); end
    if pos(3) <= 0; pos(1)=1; end
    if pos(4) >= size_im(2); pos(4)=size_im(2); end
    
    % ���o�ؼаT��
	target=im(pos(1):pos(2),pos(3):pos(4),:);
    
    % ��ܵ��G
	figure,imshow(target)
	imwrite(target,[filename,'_result','.jpg']);
    fprintf('[SAVE] %s: Save in %s\n', filename, [filename,'_result','.jpg'])

else
    % ���~�����T��
	fprintf('[INFO] %s: Failed! We can''t find it.\n', filename )
    
end
