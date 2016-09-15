% ��������ά���˲�

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
BlurandNoise = imnoise(Blur,'gaussian',0,0.04);      %��Ӹ�˹����
subplot(221), imshow(Initialimage);
title('ԭͼ��');
subplot(222), imshow(Grayimage);
title('�Ҷ�ͼ��');
subplot(223), imshow(Blur);
title('�˻�ͼ��');
subplot(224), imshow(BlurandNoise);
title('�����˻�ͼ');

% ������ʵ��ά���˲�

%------------------------------ά���˲�ԭ��-------------------------------%
% ����ʽ��G(f)=1/H(f)[|H(f)|^2/( |H(f)|^2+N(f)/S(f) )]
% ��Ϊά���˲������ݺ���������H(f)Ϊ�˻�����Ƶ��S(f)�������źŹ�����
%                        N(f)������������

Noise = BlurandNoise - Blur;
NoiseF = abs( fft2(Noise) ).^2;      %����������
IF = abs( fft2(Grayimage) ).^2;      %ԭͼ������
HFT = fft2(PSF,row,col);      %�޶�HFT���ݺ���������ԭͼһ�£�����ᱨ��
HF = abs(HFT).^2;
GFT = fft2(BlurandNoise);      %�˻�����Ƶ��
Reimage = ifft2( GFT.*( HF./(HF+NoiseF./IF) )./HFT  );      %ά���˲�ʵ��ͼ��ԭ

% �˲�Ч��չʾ
figure(2);
subplot(121), imshow(BlurandNoise), title('�����˻�ͼ��');
subplot(122), imshow(Reimage), title('��ԭͼ��2:ά���˲�');

% ά���˲���Ч����ͼ������űȴ�Сֱ�����
% ������������ʱά���˲��൱�����˲����ָ��˶�ģ��Ч���Ǽ��õ�
% ��ά���˲�Ϊ�����˲����Ը�˹�����˲�Ч���Ϻã������űȽϵ�ʱ��ԭЧ���ܺ�
% �������ű�����ά���˲���Ч��Ҳ���½�����������