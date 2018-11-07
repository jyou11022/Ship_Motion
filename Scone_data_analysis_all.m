%%
addpath('C:\Users\JYou1.DESKTOP-FUCAOQH\Desktop\Research\SCONE_Cdata')

lvl = ['1' '2' '3']; %Char. of the motion lvl - Level# 1:low / 2:moderate / 3:high
dof = ['R' 'H']; %Roll(R) or Heave(H) rate as the primary determinant
deck_loc = ['1' '2']; %Flight Deck Loc. - 1:(-280,-15,-53)ft / 2:(-525,15,-53)ft
case_num = ['1' '2' '3' '4' '5']; %Realization # 1~5 cases (0 for all)
data = cell(3,2,2,5);
for a = 1:3
    for b = 1:2
        for c = 1:2
            for d = 1:5
                file_name = strcat('SCONE_C',lvl(a),dof(b),'_FD',deck_loc(c),'_',case_num(d),'.dat');
                fileID = fopen(file_name,'r');
                C1 = textscan(fileID,'%s',19,'HeaderLines', 3); 
                C2 = textscan(fileID, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
                fclose(fileID);
                id = C1{1}; x=[];
                for i = 1:19
                    x = [x C2{i}];
                end
                data{a,b,c,d} = x;
            end
        end
    end
end
%%
lv=1;det=1;
% clearvars -except data C1 lv det
time = data{1,1,1,1}(:,1);
len = length(time);
vert = data{lv,det,1,1}(:,4);
roll = data{lv,det,1,1}(:,5);

% for k = 1:10000
%     vert_var(k) = var(vert(1:len-k)-vert(1+k:len));
%     roll_var(k) = var(roll(1:len-k)-roll(1+k:len));
% end
% figure;
% plot(vert_var/vert_var(1))
% figure;
% plot(roll_var/roll_var(1))
%%
vert_diff = zeros(100,len);
roll_diff = zeros(100,len);
for i = 1:100
    for j = 1:(len-101)
        if i == 1
            vert_diff(i,j) = vert(j+i)-vert(j);
            roll_diff(i,j) = roll(j+i)-roll(j);
        else
            vert_diff(i,j) = vert_diff(i-1,j+i)-vert_diff(i-1,j);
            roll_diff(i,j) = roll_diff(i-1,j+i)-roll_diff(i-1,j);
        end
    end
end
vert_diff = vert_diff(:,1:len-220);
roll_diff = roll_diff(:,1:len-220);
%%
len2 = len - 220; 
vert_d_var = zeros(100,2000);
roll_d_var = zeros(100,2000);
for ii = 1:100
    for kk = 1:2000
        vert_d_var(ii,kk) = var(vert_diff(ii,1:len2-kk)-vert_diff(ii,1+kk:len2));
        roll_d_var(ii,kk) = var(roll_diff(ii,1:len2-kk)-roll_diff(ii,1+kk:len2));
    end
    vert_d_var(ii,:) = vert_d_var(ii,:)./vert_d_var(ii,1);
    roll_d_var(ii,:) = roll_d_var(ii,:)./roll_d_var(ii,1);
end
%%
figure;
for ii = 5:8
    plot3(ones(1,2000)*ii,[1:2000],vert_d_var(ii,:))
    hold on;
end
xlabel('Differentiations');
ylabel('h Time Lags');
zlabel('G_{h}');
title('Variogram of Vertical Movement with Seasonal Differencing');
figure;
for ii = 5:8
    plot3(ones(1,2000)*ii,[1:2000],roll_d_var(ii,:))
    hold on;
end
xlabel('Differentations');
ylabel('h Time Lags');
zlabel('G_{h}');
title('Variogram of Roll Movement with Seasonal Differencing');

figure;
plot(vert_d_var(1,:))

figure;
plot(roll_d_var(1,:)/roll_d_var(1:1))
%%
% 
% for k = 1:10000
%     vert_var(k) = var(vert(1:len-k)-vert(1+k:len));
%     roll_var(k) = var(roll(1:len-k)-roll(1+k:len));
% end
% figure;
% plot(vert_var)
% figure;
% plot(roll_var)
%
% 
% figure; hold on; 
% plot(time(:,1),data{lv,det,1,1}(:,2));
% xlim([0,1800]); xlabel('time (sec)'); ylabel('(ft)');
% title('Forward (x) movement of the ship'); 
% legend('x');
% 
% figure; hold on; 
% plot(time(:,1),data{lv,det,1,1}(:,3));
% xlim([0,1800]); xlabel('time (sec)'); ylabel('(ft)');
% title('Side (y) movement of the ship'); 
% legend('y');
% 
% figure; hold on; 
% plot(time(:,1),data{lv,det,1,1}(:,4));
% xlim([0,1800]); xlabel('time (sec)'); ylabel('(ft)');
% title('Vertical (z) movement of the ship'); 
% legend('z');
% 
% figure; hold on; 
% plot(time(:,1),data{lv,det,1,1}(:,5));
% plot(time(:,1),data{lv,det,1,1}(:,6));
% plot(time(:,1),data{lv,det,1,1}(:,7));
% xlim([0,1800]); xlabel('time (sec)'); ylabel('Angle (Deg)');
% title('Rotaion Angles of the ship'); 
% legend('x(roll)','y(pitch)','z(yaw)');
% 
% figure; hold on; 
% plot(data{lv,det,1,1}(:,2),data{lv,det,1,1}(:,3));
% xlabel('x(ft)'); ylabel('y(ft)');
% title('Ship Path from Top View');
% 
% figure; hold on; 
% plot(data{lv,det,1,1}(:,2),data{lv,det,1,1}(:,4));
% xlabel('x(ft)'); ylabel('z(ft)');
% title('Ship Path from Side View');

% figure; hold on; 
% plot(time(1:1200,1),data{1,1,1,1}(1:1200,5));
% plot(time(1:1200,1),data{2,1,1,1}(1:1200,5));
% plot(time(1:1200,1),data{3,1,1,1}(1:1200,5));
% xlim([0,60]); xlabel('time (sec)'); ylabel('roll angle (rad)');
% title('Roll Motion with Different Levels of Roll attitude'); 
% legend('Low','Moderate','High');
% figure; hold on;
% plot(time(1:1200,1),data{2,1,1,1}(1:1200,4));
% plot(time(1:1200,1),data{2,1,2,1}(1:1200,4));
% xlim([0,60]); xlabel('time (sec)'); ylabel('z (ft)');
% title('Z Axis Motion at different Flight Deck Points'); 
% legend('Deck Point 1:(-280,-15,-53)ft','Deck Point 2:(-525,15,-53)ft');