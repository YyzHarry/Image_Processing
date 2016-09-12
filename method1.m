% ����һ��ֱ�����˲�

% ����Ϊͼ���˻����벿�֣�ÿ�δ�������õ�
% ����ƽ��ֵ��ת��Ϊ�Ҷ�ͼ��,����������Ϊdouble
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
BlurandNoise = imnoise(Blur,'gaussian',0,0.04);      %��Ӹ�˹����
subplot(221), imshow(Initialimage);
title('ԭͼ��');
subplot(222), imshow(Grayimage);
title('�Ҷ�ͼ��');
subplot(223), imshow(Blur);
title('�˻�ͼ��');
subplot(224), imshow(BlurandNoise);
title('�����˻�ͼ');

%---------------------------������ʵ��ֱ�����˲�-----------------------%
Noise = BlurandNoise - Blur;
NoiseFT = fft2(Noise);
IFT = fft2(Grayimage);
HFT = fft2(PSF,row,col);      %�޶�HFT���ݺ���������ԭͼһ�£�����ᱨ��
Reimage = ifft2(IFT + NoiseFT./HFT);      %���˲�ʵ��ͼ��ԭ

% �˲�Ч��չʾ
figure(2);
subplot(121), imshow(BlurandNoise), title('�����˻�ͼ��');
subplot(122), imshow(Reimage), title('��ԭͼ��1:���˲�');

% �ɽ����֪���������������˲����������ã�ԭ�����ڵ��˻�����H(u,v)������0ʱ��N(u,v)/H(u,v)��
% �Ḳ�ǵ�F(u,v),����������Ŵ�,�������˲��õ���ͼ����ԭͼ�����ز���