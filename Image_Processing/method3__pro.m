% �Է������Ĳ���/��һ��д�� --- �õ��������ճ���
% �˷����е��õ�f_deconvreg�����ǰ���matlab�Դ���deconvreg����Ϊģ��д��
% ����Ч��û��֮ǰ�Լ�д��method3�е�Ч����
% ��������Լ����С���˷��˲�

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

% ������ʵ��Լ����С���˷��˲�
% ��ǰһ�δ��벻ͬ,����д��f_deconvreg�������ڵ��������������ճ���
% ������ͨ�����Եõ�gammaֵ��ŵķ�Χ�ٽ��е���

% ����������
Noise_info = row * col *(V + m^2);

% �����������Ž�
[Reimage, lagra] = f_deconvreg(BlurandNoise, PSF, Noise_info);

% �˲�Ч��չʾ
figure(2);
subplot(121), imshow(BlurandNoise), title('�����˻�ͼ��');
subplot(122), imshow(Reimage), title('��ԭͼ��3.pro:Լ����С���˷��˲�2');
