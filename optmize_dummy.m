function [k,P,T,v] = optimize_dummy(l_a,l_b)
    % scenario based
    % l_a: lanes for ped on road A
    % l_b: lanes for ped on road B

    % road A is Balboa Blvd
    % road B is Newport Blvd
    % dummy variables/parameters

    % we are using Q directly from liwei right now. We might want to change it
    % after aug factor done

    q_a_veh = 0.04; % veh/sec
    q_b_veh = 0.03; % veh/sec

    q_liwei = 1600/3600; % ped/sec

    psg = 4; % ren/veh

    % population in 4 shapes
    P1 = 200;
    P2 = 284;
    P3 = 4000;
    P4 = 16200;

    V_on = 20000; % veh

    Q_a_ped = l_a*q_liwei; % ped flow on A
    Q_b_ped = l_b*q_liwei; % ped flow on B


    % optimization
    cvx_begin
        variables k(1) T_a_veh(1) T_a_ped(1) T_b_veh(1) T_b_ped(1) P_a_ped(1) P_a_veh(1) P_a_out(1) P_b_ped(1) P_b_veh(1) P_b_out(1)

        % k: percentage of people on big island to road A


        maximize((4-l_a)*q_a_veh*T_a_veh + (4-l_b)*q_b_veh*T_b_veh)
        subject to

            % road A
            P_a_ped == Q_a_ped*T_a_ped; % people get out in ped on A
            P_a_veh == psg*(4-l_a)*q_a_veh*T_a_veh; % people get out in veh on A
            P_a_out == P_a_veh+P_a_ped;

            % road B
            P_b_ped == Q_b_ped*T_b_ped; % people get out in ped on B
            P_b_veh == psg*(4-l_b)*q_b_veh*T_b_veh; % people get out in veh on B
            P_b_out == P_b_veh+P_b_ped;

            % in flow = out flow, every one out!
            P_a_out == P4*k + P1;
            P_b_out == P4*(1-k) + P2 + P3;

            % time within 4 hours
            T_a_veh <= 14400;
            T_a_ped <= 14400;
            T_b_veh <= 14400;
            T_b_ped <= 14400;
            T_a_veh >= 0;
            T_a_ped >= 0;
            T_b_veh >= 0;
            T_b_ped >= 0;

            % count vehicles
            (4-l_a)*q_a_veh*T_a_veh + (4-l_b)*q_b_veh*T_b_veh <= V_on; % cannot use more cars

            % split factor
            k >= 0;
            k <= 1;
    cvx_end
    
    P = [P_a_ped; P_a_veh; P_a_out; P_b_ped; P_b_veh; P_b_out];
    T = [T_a_veh; T_a_ped; T_b_veh; T_b_ped];
    v = (4-l_a)*q_a_veh*T_a_veh + (4-l_b)*q_b_veh*T_b_veh;
    return
end