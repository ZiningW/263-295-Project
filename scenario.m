%% compute
clear
clc
P_a_ped = zeros(5);
P_a_veh = zeros(5);
P_a_out = zeros(5);
P_b_ped = zeros(5);
P_b_veh = zeros(5);
P_b_out = zeros(5);
T_a_veh = zeros(5);
T_a_ped = zeros(5);
T_b_veh = zeros(5);
T_b_ped = zeros(5);
K = zeros(5);
V = zeros(5);

for l_a = 0:4
    for l_b = 0:4
        [k,P,T,v] = optimize_dummy(l_a,l_b);
        K(l_a+1,l_b+1) = k;
        V(l_a+1,l_b+1) = v;
        P_a_ped(l_a+1,l_b+1) = P(1);
        P_a_veh(l_a+1,l_b+1) = P(2);
        P_a_out(l_a+1,l_b+1) = P(3);
        P_b_ped(l_a+1,l_b+1) = P(4);
        P_b_veh(l_a+1,l_b+1) = P(5);
        P_b_out(l_a+1,l_b+1) = P(6);
        T_a_veh(l_a+1,l_b+1) = T(1);
        T_a_ped(l_a+1,l_b+1) = T(2);
        T_b_veh(l_a+1,l_b+1) = T(3);
        T_b_ped(l_a+1,l_b+1) = T(4);
    end
end

P_a_ped = int64(P_a_ped);
P_a_veh = int64(P_a_veh);
P_a_out = int64(P_a_out);
P_b_ped = int64(P_b_ped);
P_b_veh = int64(P_b_veh);
P_b_out = int64(P_b_out);
T_a_veh = round(T_a_veh/3600, 1);
T_a_ped = round(T_a_ped/3600, 1);
T_b_veh = round(T_b_veh/3600, 1);
T_b_ped = round(T_b_ped/3600, 1);
V = int64(V);

[val,idx] = max(V(:));
P_dist = [P_a_ped(idx),P_a_veh(idx);P_b_ped(idx),P_b_veh(idx)];
T_dist = [T_a_ped(idx),T_a_veh(idx);T_b_ped(idx),T_b_veh(idx)];
%% visualization
figure(1)
    b1 = bar3(V);
    xlabel('Vehicle Lanes on Balboa Ave')
    xticklabels({'4','3','2','1','0'})
    ylabel('Vehicle Lanes on Newport Ave')
    yticklabels({'4','3','2','1','0'})
    zlabel('Vehicles Evaculated')
    % text(0:4,0:4,num2str(V))
    colorbar
    for k = 1:length(b1)
        zdata = b1(k).ZData;
        b1(k).CData = zdata;
        b1(k).FaceColor = 'interp';
    end

figure(2)
    b2 = bar3(K);
    xlabel('Pedestrian Lanes on Balboa Ave')
    xticklabels({'0','1','2','3','4'})
    ylabel('Pedestrian Lanes on Newport Ave')
    yticklabels({'0','1','2','3','4'})
    zlabel('Percentage of People through Balboa Ave')
    colorbar
    for k = 1:length(b2)
        zdata = b2(k).ZData;
        b2(k).CData = zdata;
        b2(k).FaceColor = 'interp';
    end