% �����ģ�Lucy-Richardson�����㷨

%����ƽ��ֵ��ת��Ϊ�Ҷ�ͼ��,����������Ϊdouble
Initialimage = im2double( imread('Penguins.jpg') );
[row, col, color] = size(Initialimage);
Grayimage = zeros(row, col);
for i = 1:row
    for j = 1:col
        summ = 0;
        for k = 1:color
            summ = summ + Initialimage(i,j,k)/3;
        end
        Grayimage(i,j) = summ;
    end
end

% ͼ���˻�����
PSF = fspecial('motion',20,10);      %�����˲����ӣ�����Ϊ�˶�ģ����������㶨���
Blur = imfilter(Grayimage,PSF,'conv','circular');      %ͼ���˲�ʵ���˻���ͨ��������
m = 0;
V = 0.04;
BlurandNoise = imnoise(Blur,'gaussian',m,V);      %��Ӹ�˹����
subplot(221), imshow(Initialimage);
title('ԭͼ��');
subplot(222), imshow(Grayimage);
title('�Ҷ�ͼ��');
subplot(223), imshow(Blur);
title('�˻�ͼ��');
subplot(224), imshow(BlurandNoise);
title('�����˻�ͼ');

% ������ʵ��Lucy-Richardson�����㷨�˲�

%-----------------------Lucy-Richardson�����㷨ԭ��------------------------%
% Lucy-Richardson�����㷨ͨ��ÿ�������غ;������
% ͨ�����Ƶ����������õ���Ѹ�ԭ��
% �䶨��ʽΪ
%            f(k+1) = f(k)*[cov( (g / conv(f(k),h), h)]
% ����kΪ��������
%

% �˴�д��һ��Lucy_Richardson��������ʵ��Lucy_Richardson�����˲�
% ֱ�ӵ��ú������ɻ�ԭ���ͼ���������һ������Ϊ��������

Reimage1 = Lucy_Richardson(BlurandNoise, 20, 10, 5);
Reimage2 = Lucy_Richardson(BlurandNoise, 20, 10, 15);
Reimage3 = Lucy_Richardson(BlurandNoise, 20, 10, 50);
Reimage4 = Lucy_Richardson(BlurandNoise, 20, 10, 100);

% �˲�Ч��չʾ
figure(2);
subplot(121), imshow(BlurandNoise), title('�����˻�ͼ��');
subplot(122), imshow(Reimage2), title('��ԭͼ��4:Lucy-Richardson�����˲�');

figure(3);
subplot(221), imshow(Reimage1), title('����5��');
subplot(222), imshow(Reimage2), title('����15��');
subplot(223), imshow(Reimage3), title('����50��');
subplot(224), imshow(Reimage4), title('����100��');

% �ӽ�������������������ϵ�ʱ���˲�Ч��һ�㣬��ά���˲����
% ������������15�������˲�Ч���Ϻ�
% �����������������ӣ���50/100��ʱ����������ʱ��ϳ�(100s����)���õ���ͼ��
% ��������������ߣ���ѩ����϶࣬Ч��Ҳ��̫��(����ʵ�鱨��������)