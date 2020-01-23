%Script to output diff eq solutions

function [Y] = OstRip(params, y, T, Ry_UN, Sy_UN, fNi, fY, t)

    R = y(1);
    sigma = y(2);
    
    R_g = 8.3145;

    %32 element parameter vector: ordering
    %K, Beta^k_n, A, Beta^A_n, B, Beta^B_n
    %R = radius of Ni, sigma = stdev of Ni
    %T=Temp, t=time, Ry = Radius of YSZ, Sy = Stdev of YSZ
    %fNi = vol frac of Ni, fY = vol frac of YSZ
 
    K = params(1);Bk=params(2:22);
    A = params(23);BA = params(24:26);
    B = params(27);BB = params(28:30);

    %R, sigma, Ry, Sy, fNi, fY
    
    %======================================================================
    %Normalizing:
    %Variables: R_Ni, S_Ni, R_y, S_y, f_Ni, f_Y
    
    %Weights:   0.8 , 0.3,  0.57, 0.13
    
    W_RNi=0.8;W_SNi=0.3;W_RY=0.57;W_SY=0.13;    
    
    R_Norm = 1 - exp(-R/W_RNi);
    sigma_Norm = 1 - exp(-sigma/W_SNi);
    Ry = 1 - exp(-Ry_UN/W_RY);
    Sy = 1 - exp(-Sy_UN/W_SY);
    
    %======================================================================
    %Defining Discrepancy Functions
    dk = Bk(1) * phi(R_Norm) + Bk(2) * phi(sigma_Norm) + Bk(3) * phi(Ry) +...
        Bk(4) * phi(Sy) + Bk(5) * phi(fNi) + Bk(6) * phi(fY) + ...
        Bk(7) * phi(R_Norm) * phi(sigma_Norm) + Bk(8) * phi(R_Norm) * phi(Ry) + ...
        Bk(9) * phi(R_Norm) * phi(Sy) + Bk(10) * phi(R_Norm) * phi(fNi) + ...
        Bk(11) * phi(R_Norm) * phi(fY) + Bk(12) * phi(sigma_Norm) * phi(Ry) +...
        Bk(13) * phi(sigma_Norm) * phi(Sy) + Bk(14) * phi(sigma_Norm) * phi(fNi) + ...
        Bk(15) * phi(sigma_Norm) * phi(fY) + Bk(16) * phi(Ry) * phi(Sy) + ...
        Bk(17) * phi(Ry) * phi(fNi) + Bk(18) * phi(Ry) * phi(fY) + ...
        Bk(19) * phi(Sy) * phi(fNi) + Bk(20) * phi(Sy) * phi(fY) + ...
        Bk(21) * phi(fNi) * phi(fY);
    
    da = BA(1) * phi(R_Norm) + BA(2) * phi(sigma_Norm) + BA(3) * phi(R_Norm) * phi(sigma_Norm);
    
    db = BB(1) * phi(R_Norm) + BB(2) * phi(sigma_Norm) + BB(3) * phi(R_Norm) * phi(sigma_Norm);
    
    %======================================================================
    %The actual model part
    dRdt = K * exp(dk) * (A * exp(da) - B * exp(db)) / (2 * R_g * T * R^2);

    dsdt = K * exp(dk) / (R_g * T * sigma * R) * ((1 - B * exp(db)) + ...
    (3 * sigma^2 + 4 * R^2) / R^2 * (A * exp(da) - B * exp(db)));

    Y = [dRdt; dsdt];
end

function out = phi(in)
    %in is a normalized input variable
    out = in - 0.5;
end

