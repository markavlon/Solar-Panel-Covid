
function F = equations(vars,param1,param2)
    x = vars(1);
    y = vars(2);
    F(1) = x^2 + y^2 - param1^2;  % Example nonlinear equation 1
    F(2) = x-tand(param2)*y;        % Example nonlinear equation 2
end
